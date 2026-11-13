package lbc.fixes.mixin;

import com.llamalad7.mixinextras.injector.wrapmethod.WrapMethod;
import com.llamalad7.mixinextras.injector.wrapoperation.Operation;
import dev.ryanhcode.sable.api.SubLevelAssemblyHelper;
import lbc.fixes.VidageDiffere;
import net.minecraft.core.BlockPos;
import net.minecraft.server.level.ServerLevel;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

/**
 * Sable 2.0.6 SubLevelAssemblyHelper.moveBlocks : 1re boucle = copie de chaque bloc (et de son contenu) dans la structure,
 * 2e = mises a jour, 3e = retrait des blocs d'origine. Les vidages notes par SableFixVidageMixin pendant la 1re boucle
 * sont faits juste apres elle (2e appel a setIgnoreOnPlace), quand tout est copie et avant les retraits.
 */
@Mixin(value = SubLevelAssemblyHelper.class, remap = false)
public abstract class SableDeplacementMixin {

    @WrapMethod(method = "moveBlocks", remap = false)
    private static void lbcfixes$contexteVidage(ServerLevel level, SubLevelAssemblyHelper.AssemblyTransform transform, Iterable<BlockPos> blocks, Operation<Void> original) {
        VidageDiffere.debut();
        try {
            original.call(level, transform, blocks);
        } finally {
            VidageDiffere.vider();
            VidageDiffere.fin();
        }
    }

    @Inject(method = "moveBlocks", remap = false, at = @At(value = "INVOKE", ordinal = 1,
            target = "Ldev/ryanhcode/sable/platform/SableAssemblyPlatform;setIgnoreOnPlace(Lnet/minecraft/world/level/Level;Z)V"))
    private static void lbcfixes$viderApresCopie(CallbackInfo ci) {
        VidageDiffere.vider();
    }
}
