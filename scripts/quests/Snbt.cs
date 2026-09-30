using System;
using System.Collections.Generic;
using System.Text;

public class SC : List<KeyValuePair<string, object>> {
    public object Get(string k) { foreach (var kv in this) if (kv.Key == k) return kv.Value; return null; }
    public void Set(string k, object v) { for (int i = 0; i < Count; i++) if (this[i].Key == k) { this[i] = new KeyValuePair<string, object>(k, v); return; } Add(new KeyValuePair<string, object>(k, v)); }
    public void Remove(string k) { RemoveAll(kv => kv.Key == k); }
    public string Str(string k) { var v = Get(k) as string; return v == null ? null : Snbt.Unq(v); }
}
public class SL : List<object> { }

public static class Snbt {
    static string s; static int p;
    public static object Parse(string text) { s = text; p = 0; Ws(); return Val(); }
    static void Ws() { while (p < s.Length && (char.IsWhiteSpace(s[p]) || s[p] == ',')) p++; }
    static object Val() {
        Ws(); char c = s[p];
        if (c == '{') { p++; var o = new SC(); Ws(); while (s[p] != '}') { string k = Key(); Ws(); if (s[p] != ':') throw new Exception("':' attendu pos " + p); p++; o.Add(new KeyValuePair<string, object>(k, Val())); Ws(); } p++; return o; }
        if (c == '[') { p++; var l = new SL(); Ws();
            if (p + 1 < s.Length && s[p + 1] == ';' && "IBL".IndexOf(s[p]) >= 0) { l.Add("#" + s[p]); p += 2; }
            Ws(); while (s[p] != ']') { l.Add(Val()); Ws(); } p++; return l; }
        if (c == '"' || c == '\'') return QStr();
        int st = p; while (p < s.Length && !char.IsWhiteSpace(s[p]) && s[p] != ',' && s[p] != '}' && s[p] != ']') p++;
        return s.Substring(st, p - st);
    }
    static string Key() { Ws(); if (s[p] == '"' || s[p] == '\'') return Unq(QStr()); int st = p; while (s[p] != ':' && !char.IsWhiteSpace(s[p])) p++; return s.Substring(st, p - st); }
    static string QStr() { char q = s[p]; int st = p; p++; while (s[p] != q) { if (s[p] == '\\') p++; p++; } p++; return s.Substring(st, p - st); }
    public static string Unq(string v) {
        if (v.Length >= 2 && (v[0] == '"' || v[0] == '\'')) { var sb = new StringBuilder(); for (int i = 1; i < v.Length - 1; i++) { if (v[i] == '\\' && i + 1 < v.Length - 1) { i++; } sb.Append(v[i]); } return sb.ToString(); }
        return v;
    }
    public static string Q(string raw) { return "\"" + raw.Replace("\\", "\\\\").Replace("\"", "\\\"") + "\""; }
    static bool SimpleKey(string k) { foreach (char c in k) if (!(char.IsLetterOrDigit(c) || c == '_' || c == '.' || c == '-' || c == '+')) return false; return k.Length > 0; }
    public static string Write(object o) { var sb = new StringBuilder(); W(sb, o, 0); sb.Append('\n'); return sb.ToString(); }
    static void Ind(StringBuilder sb, int n) { sb.Append('\t', n); }
    static void W(StringBuilder sb, object o, int d) {
        if (o is SC) { var c = (SC)o; if (c.Count == 0) { sb.Append("{ }"); return; } sb.Append("{\n"); foreach (var kv in c) { Ind(sb, d + 1); sb.Append(SimpleKey(kv.Key) ? kv.Key : Q(kv.Key)); sb.Append(": "); W(sb, kv.Value, d + 1); sb.Append('\n'); } Ind(sb, d); sb.Append('}'); }
        else if (o is SL) { var l = (SL)o; if (l.Count == 0) { sb.Append("[ ]"); return; } int start = 0; sb.Append('['); if (l[0] is string && ((string)l[0]).StartsWith("#")) { sb.Append(((string)l[0]).Substring(1)).Append(';'); start = 1; }
            bool simple = true; for (int i = start; i < l.Count; i++) if (!(l[i] is string)) simple = false;
            if (simple) { for (int i = start; i < l.Count; i++) { if (i > start) sb.Append(", "); sb.Append((string)l[i]); } sb.Append(']'); }
            else { sb.Append('\n'); for (int i = start; i < l.Count; i++) { Ind(sb, d + 1); W(sb, l[i], d + 1); sb.Append('\n'); } Ind(sb, d); sb.Append(']'); } }
        else sb.Append((string)o);
    }
}
