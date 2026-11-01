package lbc.fixes;

import net.neoforged.bus.api.IEventBus;
import net.neoforged.fml.ModList;
import net.neoforged.fml.common.Mod;

/**
 * Correctifs du pack pack_LBC : mixins, plus des gestionnaires d'evenements serveur (BossMultijoueur, BossButin, MonturesDegats, GardeALaMort). Aucun contenu, aucun paquet reseau.
 * Chaque mixin est sans effet si le mod vise est absent (config mixin "required": false).
 */
@Mod(LbcFixes.MOD_ID)
public final class LbcFixes {
    public static final String MOD_ID = "lbcfixes";

    public LbcFixes(IEventBus modBus) {
        // composant de Better Inventory (mod retire) : seulement si le mod n'est pas la, sinon doublon d'enregistrement
        if (!ModList.get().isLoaded("betterinventory")) AnciensComposants.COMPOSANTS.register(modBus);
    }
}
