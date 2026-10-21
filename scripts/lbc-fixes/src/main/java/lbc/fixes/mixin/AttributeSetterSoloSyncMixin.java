package lbc.fixes.mixin;

import net.minecraft.client.Minecraft;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

/**
 * AttributeSetter 2.3 : a chaque arrivee d'un joueur dans un monde (connexion, reapparition, changement de dimension)
 * le serveur envoie ses entrees au client, qui les recharge (DataReloader.load : vide puis remplit les listes statiques).
 * En solo et pour l'hote LAN, client et serveur integre partagent ces listes : le fil de rendu les vide pendant que le
 * serveur les parcourt pour les creatures qui se chargent -> ConcurrentModificationException, crash a la mort.
 * Le serveur integre a deja charge les memes donnees : on ignore le paquet dans ce cas. Serveur dedie inchange.
 */
@Mixin(targets = "com.httpedro.attributesetter.network.ClientPayloadHandler", remap = false)
public abstract class AttributeSetterSoloSyncMixin {

    @Inject(method = "handle(Lcom/httpedro/attributesetter/network/SyncTargetTypesPayload;Lnet/neoforged/neoforge/network/handling/IPayloadContext;)V",
            at = @At("HEAD"), cancellable = true, remap = false)
    private void lbcfixes$ignorerEnSolo(CallbackInfo ci) {
        if (Minecraft.getInstance().hasSingleplayerServer()) ci.cancel();
    }
}
