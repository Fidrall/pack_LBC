package lbc.fixes.mixin;

import net.minecraft.world.entity.monster.Spider;
import net.minecraft.world.entity.player.Player;
import net.neoforged.neoforge.event.entity.living.LivingDeathEvent;
import net.trashelemental.infested.util.event.ModItemsDrop;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

/**
 * Infested Swarms and Spiders 2.4.2 : chaque araignee qui meurt (y compris celles des autres mods, qui
 * heritent de Spider) peut lacher un Spider Egg, quelle que soit la cause de la mort, avec une chance
 * codee en dur (aucune config). Trop d'oeufs dans le pack : on ne garde que les araignees tuees par un
 * joueur, et une fois sur deux. Les oeufs de poisson d'argent et d'abeille ne changent pas.
 */
@Mixin(ModItemsDrop.class)
public abstract class SpiderEggDropMixin {

    private static final float LBCFIXES_CHANCE_GARDEE = 0.5f;

    @Inject(method = "onEntityDeath", at = @At("HEAD"), cancellable = true)
    private static void lbcfixes$moinsDOeufs(LivingDeathEvent event, CallbackInfo ci) {
        if (!(event.getEntity() instanceof Spider spider)) return;
        if (!(event.getSource().getEntity() instanceof Player) || spider.getRandom().nextFloat() >= LBCFIXES_CHANCE_GARDEE) {
            ci.cancel();
        }
    }
}
