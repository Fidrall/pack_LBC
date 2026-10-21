package lbc.fixes;

import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.ai.attributes.Attributes;
import net.neoforged.bus.api.SubscribeEvent;
import net.neoforged.fml.common.EventBusSubscriber;
import net.neoforged.neoforge.event.entity.EntityAttributeModificationEvent;

import java.util.Map;

/**
 * Petting 5 : l'attaque d'une monture chevauchee appelle Mob.doHurtTarget, qui lit les attributs de degats et de recul
 * sans verifier qu'ils existent. Le sanglier du Crepuscule et l'Aerwhale n'ont pas d'attribut de degats (mesure sur
 * serveur de test le 2026-10-21) : on le leur ajoute, avec le recul s'il manque aussi. Sans effet si le mod est absent.
 */
@EventBusSubscriber(modid = LbcFixes.MOD_ID, bus = EventBusSubscriber.Bus.MOD)
public final class MonturesDegats {

    private static final Map<String, Double> DEGATS = Map.of(
            "twilightforest:boar", 3.0,
            "aether:aerwhale", 4.0);

    private MonturesDegats() {
    }

    @SubscribeEvent
    public static void onAttributs(EntityAttributeModificationEvent event) {
        for (EntityType<? extends LivingEntity> type : event.getTypes()) {
            ResourceLocation id = BuiltInRegistries.ENTITY_TYPE.getKey(type);
            Double degats = DEGATS.get(id.toString());
            if (degats == null) continue;
            if (!event.has(type, Attributes.ATTACK_DAMAGE)) event.add(type, Attributes.ATTACK_DAMAGE, degats);
            if (!event.has(type, Attributes.ATTACK_KNOCKBACK)) event.add(type, Attributes.ATTACK_KNOCKBACK, 0.0);
        }
    }
}
