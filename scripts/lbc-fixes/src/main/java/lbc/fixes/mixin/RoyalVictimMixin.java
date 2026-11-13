package lbc.fixes.mixin;

import net.minecraft.core.Holder;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.world.effect.MobEffect;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.Mob;
import net.minecraft.world.entity.ai.goal.target.NearestAttackableTargetGoal;
import net.minecraft.world.entity.player.Player;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

/**
 * Royal Variations 2.0.7 : ChosenVictimGoal est ajoute a TOUS les morts-vivants sans maitre, et son canUse() relance
 * findTarget() a chaque tick (pas d'intervalle aleatoire comme le but vanilla) : getEntitiesOfClass dans un rayon de
 * suivi + 20 blocs, puis pour chaque entite MobUtil.areAllies -> isAlliedTo (Petting arePetsOfSameOwner, couteux).
 * Mesure serveur 2026-11-13 : ~37 % du tick a lui seul, serveur a ~14 TPS avec un joueur.
 * Correctif : une recherche tous les 10 ticks par mob (decalee), et seulement si un joueur proche (64 blocs) porte
 * l'effet royalvariations:chosen_victim (pose par le zombie royal ; en pratique ses victimes sont des joueurs).
 */
@Mixin(targets = "com.mongoose.royalvariations.common.entities.ai.ChosenVictimGoal", remap = false)
public abstract class RoyalVictimMixin extends NearestAttackableTargetGoal<LivingEntity> {

    private RoyalVictimMixin(Mob mob) {
        super(mob, LivingEntity.class, false);
    }

    @Unique
    private static Holder<MobEffect> lbcfixes$victime;

    @Inject(method = "canUse", at = @At("HEAD"), cancellable = true, remap = false)
    private void lbcfixes$victimeProcheSeulement(CallbackInfoReturnable<Boolean> cir) {
        Mob m = this.mob;
        if ((m.tickCount + m.getId()) % 10 != 0) { cir.setReturnValue(false); return; }
        if (lbcfixes$victime == null) {
            lbcfixes$victime = BuiltInRegistries.MOB_EFFECT.getHolder(ResourceLocation.fromNamespaceAndPath("royalvariations", "chosen_victim")).orElse(null);
            if (lbcfixes$victime == null) return;   // effet introuvable : comportement d'origine (une fois sur 10)
        }
        for (Player p : m.level().players()) {
            if (p.distanceToSqr(m) < 64 * 64 && p.hasEffect(lbcfixes$victime)) return;
        }
        cir.setReturnValue(false);
    }
}
