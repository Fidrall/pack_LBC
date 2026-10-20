package lbc.fixes;

import net.minecraft.ChatFormatting;
import net.minecraft.core.registries.Registries;
import net.minecraft.network.chat.Component;
import net.minecraft.resources.ResourceKey;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.tags.TagKey;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.level.storage.loot.LootParams;
import net.minecraft.world.level.storage.loot.LootTable;
import net.minecraft.world.level.storage.loot.parameters.LootContextParamSets;
import net.minecraft.world.level.storage.loot.parameters.LootContextParams;
import net.neoforged.bus.api.SubscribeEvent;
import net.neoforged.fml.common.EventBusSubscriber;
import net.neoforged.neoforge.event.entity.living.LivingDeathEvent;

import java.util.Optional;

/**
 * Butin de boss individuel. Un boss du tag pack_lbc:butin_boss/<famille>_t<palier> (datapack, build-datapack section 14)
 * tue par un joueur fait tirer la table pack_lbc:boss/<famille>_t<palier> (sac de la famille + chance de carte) pour
 * CHAQUE joueur vivant a 300 blocs (meme dimension), directement dans son inventaire (au sol a ses pieds s'il est plein).
 * Le butin normal du boss tombe toujours au sol.
 */
@EventBusSubscriber(modid = LbcFixes.MOD_ID)
public final class BossButin {

    private static final String PREFIXE = "butin_boss/";
    private static final double RAYON = 300.0;

    private BossButin() {
    }

    @SubscribeEvent
    public static void onMort(LivingDeathEvent event) {
        LivingEntity boss = event.getEntity();
        if (!(boss.level() instanceof ServerLevel level) || !(boss.getKillCredit() instanceof Player)) return;
        Optional<TagKey<EntityType<?>>> tag = boss.getType().builtInRegistryHolder().tags()
                .filter(t -> t.location().getNamespace().equals("pack_lbc") && t.location().getPath().startsWith(PREFIXE)).findFirst();
        if (tag.isEmpty()) return;
        ResourceLocation id = ResourceLocation.fromNamespaceAndPath("pack_lbc", "boss/" + tag.get().location().getPath().substring(PREFIXE.length()));
        LootTable table = level.getServer().reloadableRegistries().getLootTable(ResourceKey.create(Registries.LOOT_TABLE, id));
        for (Player joueur : level.players()) {
            if (!joueur.isAlive() || joueur.isSpectator() || joueur.distanceToSqr(boss) > RAYON * RAYON) continue;
            LootParams params = new LootParams.Builder(level)
                    .withParameter(LootContextParams.THIS_ENTITY, boss)
                    .withParameter(LootContextParams.ORIGIN, boss.position())
                    .withParameter(LootContextParams.DAMAGE_SOURCE, event.getSource())
                    .withOptionalParameter(LootContextParams.ATTACKING_ENTITY, joueur)
                    .withOptionalParameter(LootContextParams.LAST_DAMAGE_PLAYER, joueur)
                    .withLuck(joueur.getLuck())
                    .create(LootContextParamSets.ENTITY);
            for (ItemStack objet : table.getRandomItems(params)) {
                if (!joueur.getInventory().add(objet)) joueur.drop(objet, false);
            }
            joueur.displayClientMessage(Component.literal("Butin du boss ajouté à ton inventaire").withStyle(ChatFormatting.GOLD), true);
        }
    }
}
