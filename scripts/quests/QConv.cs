using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

public static class QConv {
    public static HashSet<string> Items, Ns;
    public static Dictionary<string, List<string>> RemovedDeps = new Dictionary<string, List<string>>();
    public static HashSet<string> KeptQuests = new HashSet<string>();
    public static List<string> Report = new List<string>();

    static Random Rng = new Random();
    public static string NewId() { var b = new byte[8]; Rng.NextBytes(b); b[0] &= 0x7F; return BitConverter.ToString(b).Replace("-", ""); }
    static readonly string[] Tiers = { "commune", "rare", "epique", "legendaire" };

    static bool ValidItem(string id) { return id != null && Items.Contains(id); }
    static bool NsOk(string id) {
        if (string.IsNullOrEmpty(id)) return true;
        id = id.TrimStart('#'); int i = id.IndexOf(':'); if (i < 0) return true;
        return Ns.Contains(id.Substring(0, i));
    }
    static string ItemId(object item) {
        if (item is SC) return ((SC)item).Str("id");
        if (item is string) return Snbt.Unq((string)item);
        return null;
    }
    static int CoinTier(string id) {
        switch (id) {
            case "magic_coins:silver_coin": case "kubejs:token_basic": return 0;
            case "magic_coins:gold_coin": case "kubejs:token_medium": return 1;
            case "magic_coins:crystal_coin": case "kubejs:token_advanced": case "kubejs:heart_container": return 2;
        }
        return -1;
    }
    public static SC Crate(string rid, int tier) {
        var comp = new SC(); comp.Set("ftbquests:loot_crate", Snbt.Q(Tiers[tier]));
        var item = new SC(); item.Set("count", "1"); item.Set("id", Snbt.Q("ftbquests:lootcrate")); item.Set("components", comp);
        var r = new SC(); r.Set("id", Snbt.Q(rid)); r.Set("item", item); r.Set("type", Snbt.Q("item"));
        return r;
    }
    static bool TaskOk(SC t) {
        string type = t.Str("type") ?? "item";
        switch (type) {
            case "item": return ValidItem(ItemId(t.Get("item")));
            case "kill": return NsOk(t.Str("entity"));
            case "advancement": return NsOk(t.Str("advancement"));
            case "dimension": return NsOk(t.Str("dimension"));
            case "structure": return NsOk(t.Str("structure"));
            case "biome": return NsOk(t.Str("biome"));
            default: return NsOk(type);
        }
    }

    // Pass 1: decide kept quests for all chapters
    public static void Scan(SC ch) {
        var quests = ch.Get("quests") as SL; if (quests == null) return;
        foreach (SC q in quests) {
            string id = q.Str("id");
            var tasks = q.Get("tasks") as SL;
            bool any = tasks != null && tasks.Cast<SC>().Any(TaskOk);
            if (any) KeptQuests.Add(id);
            else { var deps = new List<string>(); var d = q.Get("dependencies") as SL; if (d != null) foreach (string x in d) deps.Add(Snbt.Unq(x)); RemovedDeps[id] = deps; }
        }
    }
    static IEnumerable<string> ResolveDep(string id, HashSet<string> seen) {
        if (KeptQuests.Contains(id)) { yield return id; yield break; }
        if (!seen.Add(id)) yield break;
        List<string> up; if (RemovedDeps.TryGetValue(id, out up)) foreach (var u in up) foreach (var r in ResolveDep(u, seen)) yield return r;
    }

    // Pass 2: rewrite chapter
    public static SC Rewrite(SC ch, string name) {
        int qin = 0, qout = 0, crates = 0, tRemoved = 0, rRemoved = 0;
        var quests = ch.Get("quests") as SL; var outQ = new SL();
        string firstIcon = null;
        foreach (SC q in quests) {
            qin++;
            string id = q.Str("id");
            if (!KeptQuests.Contains(id)) continue;
            qout++;
            var tasks = (SL)q.Get("tasks"); var nt = new SL();
            foreach (SC t in tasks) { if (TaskOk(t)) { nt.Add(t); if (firstIcon == null && (t.Str("type") ?? "item") == "item") firstIcon = ItemId(t.Get("item")); } else tRemoved++; }
            q.Set("tasks", nt);
            // dependencies
            var d = q.Get("dependencies") as SL;
            if (d != null) {
                var nd = new List<string>();
                foreach (string x in d) foreach (var r in ResolveDep(Snbt.Unq(x), new HashSet<string>())) if (!nd.Contains(r) && r != id) nd.Add(r);
                if (nd.Count == 0) q.Remove("dependencies"); else { var l = new SL(); foreach (var r in nd) l.Add(Snbt.Q(r)); q.Set("dependencies", l); }
            }
            // rewards
            var rw = q.Get("rewards") as SL; int tier = -1; var nr = new SL(); string firstRid = null;
            if (rw != null) foreach (SC r in rw) {
                string type = r.Str("type") ?? "item";
                if (firstRid == null) firstRid = r.Str("id");
                if (type == "item") { string iid = ItemId(r.Get("item")); int ct = CoinTier(iid); if (ct > tier) tier = ct; if (ValidItem(iid)) nr.Add(r); else rRemoved++; }
                else if (type == "random" || type == "loot" || type == "choice" || type == "all_table") { rRemoved++; if (tier < 0) tier = 0; }
                else nr.Add(r);
            }
            if (tier >= 0) { nr.Add(Crate(NewId(), tier)); crates++; }
            if (nr.Count > 0) q.Set("rewards", nr); else q.Remove("rewards");
            var ic = q.Get("icon"); if (ic != null && !ValidItem(ItemId(ic))) q.Remove("icon");
            outQ.Add(q);
        }
        ch.Set("quests", outQ);
        var cic = ch.Get("icon"); if (cic != null && !ValidItem(ItemId(cic))) { if (firstIcon != null) { var ni = new SC(); ni.Set("id", Snbt.Q(firstIcon)); ch.Set("icon", ni); } else ch.Remove("icon"); }
        var imgs = ch.Get("images") as SL; if (imgs != null) { var ni = new SL(); foreach (SC im in imgs) if (NsOk(im.Str("image"))) ni.Add(im); ch.Set("images", ni); }
        var links = ch.Get("quest_links") as SL; if (links != null) { var nl = new SL(); foreach (SC lk in links) if (KeptQuests.Contains(lk.Str("linked_quest"))) nl.Add(lk); ch.Set("quest_links", nl); }
        Report.Add(string.Format("{0,-28} quetes {1,3} -> {2,3} | taches retirees {3,3} | recompenses retirees {4,3} | caisses {5,3}", name, qin, qout, tRemoved, rRemoved, crates));
        return ch;
    }

    // remove given quests from a chapter, re-pointing dependencies transitively
    public static int RemoveQuests(SC ch, HashSet<string> del) {
        var quests = (SL)ch.Get("quests"); var depOf = new Dictionary<string, List<string>>();
        foreach (SC q in quests) { var l = new List<string>(); var d = q.Get("dependencies") as SL; if (d != null) foreach (string x in d) l.Add(Snbt.Unq(x)); depOf[q.Str("id")] = l; }
        Func<string, HashSet<string>, List<string>> res = null;
        res = (id, seen) => { var o = new List<string>(); if (!del.Contains(id)) { o.Add(id); return o; } if (!seen.Add(id)) return o; List<string> up; if (depOf.TryGetValue(id, out up)) foreach (var u in up) o.AddRange(res(u, seen)); return o; };
        var outQ = new SL(); int n = 0;
        foreach (SC q in quests) {
            if (del.Contains(q.Str("id"))) { n++; continue; }
            var d = q.Get("dependencies") as SL;
            if (d != null) { var nd = new List<string>(); foreach (string x in d) foreach (var r in res(Snbt.Unq(x), new HashSet<string>())) if (!nd.Contains(r)) nd.Add(r); if (nd.Count == 0) q.Remove("dependencies"); else { var l = new SL(); foreach (var r in nd) l.Add(Snbt.Q(r)); q.Set("dependencies", l); } }
            outQ.Add(q);
        }
        ch.Set("quests", outQ); return n;
    }

    // collect ids of objects kept (for lang)
    public static void CollectIds(object o, HashSet<string> ids) {
        if (o is SC) { var c = (SC)o; var id = c.Str("id"); if (id != null && id.Length == 16) ids.Add(id); foreach (var kv in c) CollectIds(kv.Value, ids); }
        else if (o is SL) foreach (var x in (SL)o) CollectIds(x, ids);
    }
}
