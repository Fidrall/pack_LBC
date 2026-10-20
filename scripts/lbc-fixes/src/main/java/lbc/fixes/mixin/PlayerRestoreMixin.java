package lbc.fixes.mixin;

import net.minecraft.server.level.ServerPlayer;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

/**
 * Les donnees persistantes d'entite ne suivent pas le joueur a la mort (NeoForge 21.1 n'a plus de PlayerPersisted) :
 * on recopie la date de la derniere baisse de palier (WorldTierCooldownMixin), sinon mourir remettrait le delai a zero.
 */
@Mixin(ServerPlayer.class)
public abstract class PlayerRestoreMixin {

    @Inject(method = "restoreFrom", at = @At("TAIL"), remap = false)
    private void lbcfixes$garderBaissePalier(ServerPlayer ancien, boolean garderTout, CallbackInfo ci) {
        String cle = "lbcfixes_baisse_palier"; // meme cle que WorldTierCooldownMixin (une classe mixin ne se reference pas)
        if (ancien.getPersistentData().contains(cle)) {
            ((ServerPlayer) (Object) this).getPersistentData().putLong(cle, ancien.getPersistentData().getLong(cle));
        }
    }
}
