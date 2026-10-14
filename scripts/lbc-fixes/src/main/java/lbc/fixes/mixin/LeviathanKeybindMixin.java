package lbc.fixes.mixin;

import com.github.wolfshotz.wyrmroost.entities.dragon.ButterflyLeviathanEntity;
import java.util.function.Predicate;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.projectile.ProjectileUtil;
import net.minecraft.world.phys.AABB;
import net.minecraft.world.phys.EntityHitResult;
import net.minecraft.world.phys.Vec3;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Redirect;

/**
 * Wyrmroost 1.4.1 : Mafs.rayTraceEntities passe la portee (40) comme distance AU CARRE a
 * ProjectileUtil.getEntityHitResult, donc l'eclair monte du Butterfly Leviathan ne vise qu'a ~6 blocs.
 * Meme calcul, avec la portee au carre. Limite a l'eclair du Leviathan.
 */
@Mixin(ButterflyLeviathanEntity.class)
public abstract class LeviathanKeybindMixin {

    @Redirect(method = "recievePassengerKeybind",
            at = @At(value = "INVOKE",
                    target = "Lcom/github/wolfshotz/wyrmroost/util/Mafs;rayTraceEntities(Lnet/minecraft/world/entity/Entity;DLjava/util/function/Predicate;)Lnet/minecraft/world/phys/EntityHitResult;"))
    private EntityHitResult lbcfixes$rayTraceWithRealRange(Entity from, double range, Predicate<Entity> filter) {
        Vec3 look = from.getViewVector(0.0F);
        Vec3 eye = from.getEyePosition();
        Vec3 end = eye.add(look.scale(range));
        AABB box = from.getBoundingBox().expandTowards(look.scale(range)).inflate(1.0);
        return ProjectileUtil.getEntityHitResult(from, eye, end, box, filter, range * range);
    }
}
