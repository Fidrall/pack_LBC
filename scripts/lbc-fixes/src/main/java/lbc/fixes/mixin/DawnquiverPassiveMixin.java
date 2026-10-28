package lbc.fixes.mixin;

import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.OwnableEntity;
import net.minecraft.world.entity.monster.Enemy;
import net.yigitguven.petting.util.PetHelper;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

/**
 * Simply Swords 1.70 : le petit arc passif de la Dawnquiver tire sur la cible valide la plus lointaine, joueurs compris.
 * Le filtre de cette recherche (lambda de findFurthestTarget, seul appel : tickHeldPassive) ne garde que les monstres
 * hostiles qui ne sont pas des familiers. Le tir tenu (findActiveTarget) n'est pas touche.
 */
@Mixin(targets = "net.sweenus.simplyswords.world.DawnquiverAbilityManager", remap = false)
public abstract class DawnquiverPassiveMixin {

    @Inject(method = "lambda$findFurthestTarget$10(Lnet/minecraft/world/entity/LivingEntity;DLnet/minecraft/world/entity/LivingEntity;)Z",
            at = @At("HEAD"), cancellable = true, remap = false)
    private static void lbcfixes$monstresSeulement(LivingEntity porteur, double portee, LivingEntity cible, CallbackInfoReturnable<Boolean> cir) {
        if (!(cible instanceof Enemy) || (cible instanceof OwnableEntity o && o.getOwnerUUID() != null) || PetHelper.isTamed(cible)) {
            cir.setReturnValue(false);
        }
    }
}
