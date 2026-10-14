package lbc.fixes.mixin;

import com.github.wolfshotz.wyrmroost.entities.dragon.AbstractDragonEntity;
import com.github.wolfshotz.wyrmroost.entities.dragon.ButterflyLeviathanEntity;
import com.llamalad7.mixinextras.injector.wrapoperation.Operation;
import com.llamalad7.mixinextras.injector.wrapoperation.WrapOperation;
import net.minecraft.world.entity.LivingEntity;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;

/**
 * Wyrmroost 1.4.1 : AbstractDragonEntity.aiStep efface la cible quand canAttack est faux, et canAttack
 * est toujours faux pour un dragon monte. La cible donnee par le pilote (touche "attaque secondaire")
 * disparait donc avant le tick 10 de l'animation d'eclair, et la foudre ne tombe jamais.
 * On garde la cible uniquement pendant l'animation d'eclair du Butterfly Leviathan.
 */
@Mixin(AbstractDragonEntity.class)
public abstract class DragonKeepTargetMixin {

    @WrapOperation(method = "aiStep",
            at = @At(value = "INVOKE",
                    target = "Lcom/github/wolfshotz/wyrmroost/entities/dragon/AbstractDragonEntity;canAttack(Lnet/minecraft/world/entity/LivingEntity;)Z"))
    private boolean lbcfixes$keepLightningTarget(AbstractDragonEntity dragon, LivingEntity target, Operation<Boolean> original) {
        if (dragon instanceof ButterflyLeviathanEntity
                && dragon.getAnimation() == ButterflyLeviathanEntity.LIGHTNING_ANIMATION
                && target.isAlive()) {
            return true;
        }
        return original.call(dragon, target);
    }
}
