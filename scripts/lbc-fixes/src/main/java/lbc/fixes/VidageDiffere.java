package lbc.fixes;

import java.util.ArrayList;
import java.util.Collections;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.Set;
import com.mojang.logging.LogUtils;
import net.minecraft.core.BlockPos;
import net.minecraft.core.Direction;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.level.Level;
import net.neoforged.neoforge.capabilities.Capabilities;
import net.neoforged.neoforge.items.IItemHandler;
import net.neoforged.neoforge.items.IItemHandlerModifiable;

/**
 * Sable Fix vide l'inventaire (capacite objets) de chaque bloc d'origine juste apres l'avoir copie dans la structure
 * physique. Pour un coffre double ou un coffre-fort Create, cette capacite couvre TOUS les blocs du meuble : vider la
 * premiere moitie vidait aussi la seconde avant qu'elle soit copiee, et son contenu etait perdu.
 * Pendant le deplacement Sable (SubLevelAssemblyHelper.moveBlocks), on note donc les positions a vider et on les vide
 * toutes une fois chaque bloc copie, avant que les blocs d'origine soient retires (sinon ils lacheraient leur contenu).
 * Fil serveur uniquement.
 */
public final class VidageDiffere {
    private static final org.slf4j.Logger LOG = LogUtils.getLogger();
    private record Cible(Level level, BlockPos pos) {}

    private static int profondeur;
    private static final List<Cible> cibles = new ArrayList<>();

    private VidageDiffere() {}

    public static void debut() {
        if (profondeur++ == 0) cibles.clear();
    }

    public static void fin() {
        if (profondeur > 0 && --profondeur == 0) cibles.clear();
    }

    public static boolean actif() {
        return profondeur > 0;
    }

    public static void noter(Level level, BlockPos pos) {
        if (level != null && pos != null) cibles.add(new Cible(level, pos.immutable()));
    }

    /** Vide toutes les positions notees (appele quand toute la structure a ete copiee). */
    public static void vider() {
        if (cibles.isEmpty()) return;
        List<Cible> liste = new ArrayList<>(cibles);
        cibles.clear();
        Set<IItemHandler> vus = Collections.newSetFromMap(new IdentityHashMap<>());
        for (Cible c : liste) {
            try {
                viderHandler(c.level().getCapability(Capabilities.ItemHandler.BLOCK, c.pos(), null), vus);
                for (Direction d : Direction.values()) viderHandler(c.level().getCapability(Capabilities.ItemHandler.BLOCK, c.pos(), d), vus);
            } catch (RuntimeException e) {
                LOG.error("[lbcfixes] vidage differe impossible en {}", c.pos(), e);
            }
        }
    }

    private static void viderHandler(IItemHandler h, Set<IItemHandler> vus) {
        if (h == null || !vus.add(h)) return;
        if (h instanceof IItemHandlerModifiable m) {
            for (int i = 0; i < m.getSlots(); i++) if (!m.getStackInSlot(i).isEmpty()) m.setStackInSlot(i, ItemStack.EMPTY);
            return;
        }
        for (int i = 0; i < h.getSlots(); i++) {
            for (int essai = 0; essai < 64 && !h.getStackInSlot(i).isEmpty(); essai++) {
                if (h.extractItem(i, Integer.MAX_VALUE, false).isEmpty()) break;
            }
        }
    }
}
