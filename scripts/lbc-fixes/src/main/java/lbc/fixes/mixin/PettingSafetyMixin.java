package lbc.fixes.mixin;

import com.mojang.logging.LogUtils;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.world.entity.Mob;
import net.neoforged.neoforge.event.entity.EntityJoinLevelEvent;
import net.yigitguven.petting.data.PetSavedData;
import net.yigitguven.petting.init.PettingModAttachments;
import net.yigitguven.petting.util.PetHelper;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

/**
 * Avant lbcfixes 1.0.7, PetSafetyEvents a fait des familiers Petting de mobs deja apprivoises par leur mod (dragons
 * Wyrmroost, chevaux, chiens...) : Petting prend leur clic droit (assis / debout) et refuse de les monter (hors liste).
 * A leur entree dans le monde, on retire ces donnees Petting, sauf aux mobs que Petting sait apprivoiser
 * (tags petting:tames_with/*). Le proprietaire du mod d'origine n'est pas touche.
 */
@Mixin(targets = "net.yigitguven.petting.event.PetSafetyEvents", remap = false)
public abstract class PettingSafetyMixin {
    private static final org.slf4j.Logger LOG = LogUtils.getLogger();

    @Inject(method = "onEntityJoinLevel", at = @At("HEAD"), remap = false)
    private static void lbcfixes$rendLesFamiliersDesAutres(EntityJoinLevelEvent event, CallbackInfo ci) {
        if (!(event.getLevel() instanceof ServerLevel level) || !(event.getEntity() instanceof Mob mob)) return;
        if (!mob.hasData(PettingModAttachments.PET_DATA) || !mob.getData(PettingModAttachments.PET_DATA).isTamed()) return;
        if (!PetHelper.isVanillaTamed(mob) || mob.getType().builtInRegistryHolder().tags()
                .anyMatch(t -> t.location().getNamespace().equals("petting") && t.location().getPath().startsWith("tames_with/"))) return;
        mob.removeData(PettingModAttachments.PET_DATA);
        PetSavedData.get(level).removePet(mob.getUUID());
        LOG.info("[lbcfixes] {} {} : donnees Petting retirees (apprivoise par son propre mod)", mob.getType().getDescriptionId(), mob.getUUID());
    }
}
