package lbc.fixes;

import com.mojang.brigadier.CommandDispatcher;
import com.mojang.brigadier.arguments.IntegerArgumentType;
import dev.ryanhcode.sable.api.sublevel.SubLevelContainer;
import dev.ryanhcode.sable.sublevel.ServerSubLevel;
import dev.ryanhcode.sable.sublevel.SubLevel;
import dev.ryanhcode.sable.sublevel.storage.SubLevelRemovalReason;
import me.corvino.aeronauticsdiscovery.event.FlyoverUtils;
import net.minecraft.ChatFormatting;
import net.minecraft.commands.CommandSourceStack;
import net.minecraft.commands.Commands;
import net.minecraft.nbt.CompoundTag;
import net.minecraft.network.chat.Component;
import net.minecraft.world.phys.Vec3;
import org.joml.Vector3dc;

import java.util.ArrayList;
import java.util.List;

/**
 * /vaisseaux_discovery liste [rayon] et /vaisseaux_discovery supprimer <rayon> (op niveau 2).
 * Ne touche qu'aux vaisseaux crees par Create Aeronautics Discovery (montgolfieres, avions, patrouilles) : ceux dont les
 * donnees Sable portent mod_id = aeronauticsdiscovery. Les vaisseaux des joueurs n'ont pas cette marque.
 * Sable ne connait que les vaisseaux charges : la commande agit autour de la position de celui qui la lance.
 * Les mobs a bord (pilotes) sont retires avec le vaisseau, jamais les joueurs (fonction de nettoyage de Discovery).
 */
final class VaisseauxDiscovery {

    private static final String MOD = "aeronauticsdiscovery";

    private VaisseauxDiscovery() {
    }

    static void enregistrer(CommandDispatcher<CommandSourceStack> dispatcher) {
        dispatcher.register(Commands.literal("vaisseaux_discovery")
                .requires(src -> src.hasPermission(2))
                .then(Commands.literal("liste")
                        .executes(ctx -> lister(ctx.getSource(), 256))
                        .then(Commands.argument("rayon", IntegerArgumentType.integer(1, 4096))
                                .executes(ctx -> lister(ctx.getSource(), IntegerArgumentType.getInteger(ctx, "rayon")))))
                .then(Commands.literal("supprimer")
                        .then(Commands.argument("rayon", IntegerArgumentType.integer(1, 4096))
                                .executes(ctx -> supprimer(ctx.getSource(), IntegerArgumentType.getInteger(ctx, "rayon"))))));
    }

    private static List<ServerSubLevel> trouver(CommandSourceStack src, int rayon) {
        List<ServerSubLevel> res = new ArrayList<>();
        SubLevelContainer conteneur = SubLevelContainer.getContainer(src.getLevel());
        if (conteneur == null) return res;
        Vec3 o = src.getPosition();
        double max = (double) rayon * rayon;
        for (SubLevel sl : conteneur.getAllSubLevels()) {
            if (!(sl instanceof ServerSubLevel s) || s.isRemoved()) continue;
            CompoundTag donnees = s.getUserDataTag();
            if (donnees == null || !MOD.equals(donnees.getString("mod_id"))) continue;
            if (distance2(s, o) > max) continue;
            res.add(s);
        }
        return res;
    }

    private static double distance2(ServerSubLevel s, Vec3 o) {
        Vector3dc p = s.logicalPose().position();
        double dx = p.x() - o.x, dy = p.y() - o.y, dz = p.z() - o.z;
        return dx * dx + dy * dy + dz * dz;
    }

    private static int lister(CommandSourceStack src, int rayon) {
        List<ServerSubLevel> trouves = trouver(src, rayon);
        if (trouves.isEmpty()) {
            src.sendSuccess(() -> Component.literal("Aucun vaisseau Discovery chargé à moins de " + rayon + " blocs."), false);
            return 0;
        }
        src.sendSuccess(() -> Component.literal(trouves.size() + " vaisseau(x) Discovery à moins de " + rayon + " blocs :").withStyle(ChatFormatting.GOLD), false);
        Vec3 o = src.getPosition();
        for (ServerSubLevel s : trouves) {
            Vector3dc p = s.logicalPose().position();
            String modele = s.getUserDataTag().getString("template_id");
            String ligne = String.format(" - %s (%s) en %d %d %d, à %d blocs", s.getName() == null ? "sans nom" : s.getName(),
                    modele.isEmpty() ? "?" : modele, Math.round(p.x()), Math.round(p.y()), Math.round(p.z()), Math.round(Math.sqrt(distance2(s, o))));
            src.sendSuccess(() -> Component.literal(ligne), false);
        }
        return trouves.size();
    }

    private static int supprimer(CommandSourceStack src, int rayon) {
        List<ServerSubLevel> trouves = trouver(src, rayon);
        SubLevelContainer conteneur = SubLevelContainer.getContainer(src.getLevel());
        int n = 0;
        for (ServerSubLevel s : trouves) {
            if (s.isRemoved()) continue;
            FlyoverUtils.removeAllEntitiesInSublevel(s, false);
            conteneur.removeSubLevel(s, SubLevelRemovalReason.REMOVED);
            n++;
        }
        int total = n;
        src.sendSuccess(() -> Component.literal(total + " vaisseau(x) Discovery supprimé(s) à moins de " + rayon + " blocs."), true);
        return total;
    }
}
