package lbc.fixes.mixin;

import net.minecraft.world.entity.LivingEntity;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Redirect;

/**
 * Petting 5.0.2 : PetHelper.isTamed compte aussi tout mob apprivoise par un autre moyen (TamableAnimal, cheval,
 * OwnableEntity : dragons Wyrmroost, chiens Doggy Talents, familiers...). Petting leur ajoute alors ses IA et
 * annule le clic droit main vide de leur proprietaire (ordre assis) : plus moyen de monter un cheval ou un dragon.
 * La 4.2 avait une liste noire par mod, la 5 non. Petting ne gere donc plus que les mobs qu'il a lui-meme apprivoises.
 */
@Mixin(targets = "net.yigitguven.petting.util.PetHelper", remap = false)
public abstract class PettingOwnPetsMixin {

    @Redirect(method = "isTamed", at = @At(value = "INVOKE",
            target = "Lnet/yigitguven/petting/util/PetHelper;isVanillaTamed(Lnet/minecraft/world/entity/LivingEntity;)Z"), remap = false)
    private static boolean lbcfixes$seulementSesFamiliers(LivingEntity entity) {
        return false;
    }
}
