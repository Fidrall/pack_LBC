package lbc.fixes;

import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.OwnableEntity;
import net.minecraft.world.entity.TraceableEntity;
import net.minecraft.world.entity.player.Player;
import net.neoforged.bus.api.EventPriority;
import net.neoforged.bus.api.SubscribeEvent;
import net.neoforged.fml.common.EventBusSubscriber;
import net.neoforged.neoforge.event.entity.EntityMobGriefingEvent;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Les sorts de Cataclysm Spellbooks utilisent les entites de Cataclysm (rayon abyssal, faille dimensionnelle...) qui cassent
 * des blocs. La faille lancee par un sort passe meme outre mobGriefing (Cataclysm Spellbooks force le droit hors claim FTB).
 * Ici : une entite de Cataclysm ou de Cataclysm Spellbooks ne casse pas de blocs quand elle vient d'un joueur (lanceur,
 * proprietaire, ou proprietaire de son invocateur). Les boss n'ont pas de proprietaire joueur : ils cassent toujours.
 * Priorite LOWEST pour passer apres le gestionnaire de Cataclysm Spellbooks.
 */
@EventBusSubscriber(modid = LbcFixes.MOD_ID)
public final class SortsSansCasse {

    /** Accesseur du lanceur pour les entites de Cataclysm qui n'implementent ni TraceableEntity ni OwnableEntity (null = aucun). */
    private static final Map<Class<?>, Object> ACCES = new ConcurrentHashMap<>();
    private static final Object AUCUN = new Object();

    private SortsSansCasse() {
    }

    @SubscribeEvent(priority = EventPriority.LOWEST)
    public static void onCasse(EntityMobGriefingEvent event) {
        Entity e = event.getEntity();
        if (e == null || !event.canGrief() || !deCataclysm(e)) return;
        if (vientDUnJoueur(e)) event.setCanGrief(false);
    }

    private static boolean deCataclysm(Entity e) {
        String nom = e.getClass().getName();
        return nom.startsWith("com.github.L_Ender.cataclysm.") || nom.startsWith("net.acetheeldritchking.cataclysm_spellbooks.");
    }

    private static boolean vientDUnJoueur(Entity e) {
        for (int i = 0; i < 4 && e != null; i++) {
            if (e instanceof Player) return true;
            e = lanceur(e);
        }
        return false;
    }

    private static Entity lanceur(Entity e) {
        if (e instanceof OwnableEntity o) return o.getOwner();
        if (e instanceof TraceableEntity t) return t.getOwner();
        // Abyss_Blast_Entity : champ public caster ; Dimensional_Rift_Entity : getOwner()
        Object acces = ACCES.computeIfAbsent(e.getClass(), SortsSansCasse::trouverAcces);
        try {
            if (acces instanceof Method m) return (Entity) m.invoke(e);
            if (acces instanceof Field f) return (Entity) f.get(e);
        } catch (ReflectiveOperationException | ClassCastException ignore) {
        }
        return null;
    }

    private static Object trouverAcces(Class<?> c) {
        for (String nom : new String[] {"getOwner", "getCaster"}) {
            try {
                Method m = c.getMethod(nom);
                if (Entity.class.isAssignableFrom(m.getReturnType())) return m;
            } catch (NoSuchMethodException ignore) {
            }
        }
        try {
            Field f = c.getField("caster");
            if (Entity.class.isAssignableFrom(f.getType())) return f;
        } catch (NoSuchFieldException ignore) {
        }
        return AUCUN;
    }
}
