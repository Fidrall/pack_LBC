package lbc.fixes.mixin;

import com.somake.somakespells.entity.PumpkinZoneEntity;
import net.minecraft.core.Holder;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.world.effect.MobEffect;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Redirect;

/**
 * Somake Spells 1.0.8 : la zone du sort Pumpkin Bomb cree son effet avec Holder.direct (effet non
 * enregistre). Toute sauvegarde de cet effet (Relics, donnees du joueur) leve une exception :
 * Neruina tuait la zone puis expulsait le joueur. On utilise le holder enregistre de l'effet.
 */
@Mixin(PumpkinZoneEntity.class)
public abstract class PumpkinZoneMixin {

    @SuppressWarnings({"rawtypes", "unchecked"})
    @Redirect(method = "tick",
            at = @At(value = "INVOKE",
                    target = "Lnet/minecraft/core/Holder;direct(Ljava/lang/Object;)Lnet/minecraft/core/Holder;"))
    private Holder lbcfixes$registeredEffect(Object value) {
        if (value instanceof MobEffect effect) {
            return BuiltInRegistries.MOB_EFFECT.wrapAsHolder(effect);
        }
        return Holder.direct(value);
    }
}
