package lbc.fixes;

import net.minecraft.core.registries.Registries;
import net.minecraft.nbt.CompoundTag;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.tags.TagKey;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.ai.attributes.AttributeInstance;
import net.minecraft.world.entity.ai.attributes.AttributeModifier;
import net.minecraft.world.entity.ai.attributes.Attributes;
import net.minecraft.world.entity.player.Player;
import net.neoforged.bus.api.SubscribeEvent;
import net.neoforged.fml.common.EventBusSubscriber;
import net.neoforged.neoforge.event.entity.living.LivingIncomingDamageEvent;

/**
 * Vie des boss selon le nombre de joueurs autour d'eux. A chaque coup recu, un boss du tag pack_lbc:boss_multijoueur
 * (datapack, build-datapack section 12) compte les joueurs vivants a 48 blocs (ni spectateurs ni createurs) et gagne
 * +50 % de vie max par joueur en plus du premier (multiplie la vie deja renforcee par le pack). Il garde la meme part
 * de vie. Le compte ne redescend jamais : partir pendant le combat n'affaiblit pas le boss.
 */
@EventBusSubscriber(modid = LbcFixes.MOD_ID)
public final class BossMultijoueur {

    private static final TagKey<EntityType<?>> BOSS = TagKey.create(Registries.ENTITY_TYPE, ResourceLocation.fromNamespaceAndPath("pack_lbc", "boss_multijoueur"));
    private static final ResourceLocation MODIFICATEUR = ResourceLocation.fromNamespaceAndPath(LbcFixes.MOD_ID, "multijoueur");
    private static final String CLE = "lbcfixes_joueurs";
    private static final double PAR_JOUEUR = 0.5;
    private static final double RAYON = 48.0;

    private BossMultijoueur() {
    }

    @SubscribeEvent
    public static void onDegatsRecus(LivingIncomingDamageEvent event) {
        LivingEntity boss = event.getEntity();
        if (boss.level().isClientSide() || !boss.getType().is(BOSS)) return;
        int joueurs = 0;
        for (Player p : boss.level().players()) {
            if (p.isAlive() && !p.isSpectator() && !p.isCreative() && p.distanceToSqr(boss) <= RAYON * RAYON) joueurs++;
        }
        CompoundTag data = boss.getPersistentData();
        if (joueurs <= Math.max(1, data.getInt(CLE))) return;
        AttributeInstance vie = boss.getAttribute(Attributes.MAX_HEALTH);
        if (vie == null) return;
        float part = boss.getHealth() / boss.getMaxHealth();
        vie.removeModifier(MODIFICATEUR);
        vie.addPermanentModifier(new AttributeModifier(MODIFICATEUR, PAR_JOUEUR * (joueurs - 1), AttributeModifier.Operation.ADD_MULTIPLIED_TOTAL));
        boss.setHealth(part * boss.getMaxHealth());
        data.putInt(CLE, joueurs);
    }
}
