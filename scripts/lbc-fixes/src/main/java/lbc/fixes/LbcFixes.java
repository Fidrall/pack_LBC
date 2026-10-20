package lbc.fixes;

import net.neoforged.fml.common.Mod;

/**
 * Correctifs du pack pack_LBC : mixins, plus des gestionnaires d'evenements serveur (BossMultijoueur, BossButin). Aucun contenu, aucun paquet reseau.
 * Chaque mixin est sans effet si le mod vise est absent (config mixin "required": false).
 */
@Mod(LbcFixes.MOD_ID)
public final class LbcFixes {
    public static final String MOD_ID = "lbcfixes";

    public LbcFixes() {
    }
}
