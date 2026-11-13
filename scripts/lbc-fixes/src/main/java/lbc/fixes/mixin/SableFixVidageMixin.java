package lbc.fixes.mixin;

import lbc.fixes.VidageDiffere;
import net.minecraft.world.level.block.entity.BlockEntity;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

/**
 * Sable Fix 1.1.0 (inventoryDuplication) : pendant un deplacement Sable, le vidage de la capacite objets du bloc
 * d'origine est reporte a la fin de la copie (voir VidageDiffere et SableDeplacementMixin). Sinon un coffre double ou un
 * coffre-fort Create perd le contenu des blocs copies apres le premier.
 */
@Mixin(targets = "com.finkkk.sable_fix.util.InventoryClearHelper", remap = false)
public abstract class SableFixVidageMixin {

    @Inject(method = "clearItemHandlerCapabilities", at = @At("HEAD"), cancellable = true, remap = false)
    private static void lbcfixes$reporterVidage(BlockEntity be, CallbackInfoReturnable<Boolean> cir) {
        if (!VidageDiffere.actif()) return;
        VidageDiffere.noter(be.getLevel(), be.getBlockPos());
        cir.setReturnValue(false);
    }
}
