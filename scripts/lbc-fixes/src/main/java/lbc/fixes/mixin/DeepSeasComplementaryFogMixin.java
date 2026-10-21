package lbc.fixes.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

/**
 * Create Deep Seas 3.4.x : avec Complementary Reimagined, une brume beige recouvre tout le paysage par temps clair
 * (meme bug que le ticket GitHub #122, ouvert, sans correctif). Deep Seas injecte dans les shaders composites de
 * Complementary un brouillard d'eau "derriere la coque" (cdsWaterBehindHull / waterFogColor) qui s'applique ici sur
 * tout l'ecran. On rend le shader tel quel : seul ce brouillard des hublots de sous-marin disparait.
 */
@Mixin(targets = "com.maxenonyme.createsubmarine.submarine.compat.iris.ComplementarySupport", remap = false)
public abstract class DeepSeasComplementaryFogMixin {

    @Inject(method = "patch(Ljava/lang/String;)Ljava/lang/String;", at = @At("HEAD"), cancellable = true, remap = false)
    private static void lbcfixes$sansBrouillardDeCoque(String source, CallbackInfoReturnable<String> cir) {
        cir.setReturnValue(source);
    }
}
