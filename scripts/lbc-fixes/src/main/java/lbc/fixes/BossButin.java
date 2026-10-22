package lbc.fixes;

import net.minecraft.ChatFormatting;
import net.minecraft.core.registries.Registries;
import net.minecraft.network.chat.Component;
import net.minecraft.resources.ResourceKey;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.tags.TagKey;
import net.minecraft.world.damagesource.DamageSource;
import net.minecraft.world.entity.EntityType;
import net.minecraft.world.entity.LivingEntity;
import net.minecraft.world.entity.item.ItemEntity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.ItemStack;
import net.minecraft.world.level.storage.loot.LootParams;
import net.minecraft.world.level.storage.loot.LootTable;
import net.minecraft.world.level.storage.loot.parameters.LootContextParamSets;
import net.minecraft.world.level.storage.loot.parameters.LootContextParams;
import net.neoforged.bus.api.SubscribeEvent;
import net.neoforged.fml.common.EventBusSubscriber;
import net.neoforged.neoforge.event.entity.living.LivingDeathEvent;
import net.neoforged.neoforge.event.entity.living.LivingDropsEvent;

import java.util.Optional;

/**
 * Butin de boss individuel, pour un boss du tag pack_lbc:butin_boss/<famille>_t<palier> (datapack, build-datapack section 14)
 * tue par un joueur. Chaque joueur vivant a 300 blocs (meme dimension) recoit dans son inventaire (au sol a ses pieds s'il
 * est plein) :
 * - le sac de la famille : table pack_lbc:boss/<famille>_t<palier> (sac + chance de carte), a la mort ;
 * - le butin du boss : le tueur prend le vrai butin (avec les objets que le mod donne par code), les autres un tirage
 *   personnel de la table de butin du boss. Plus rien ne tombe au sol.
 */
@EventBusSubscriber(modid = LbcFixes.MOD_ID)
public final class BossButin {

    private static final String PREFIXE = "butin_boss/";
    private static final double RAYON = 300.0;

    private BossButin() {
    }

    private static Optional<String> famille(LivingEntity boss) {
        return boss.getType().builtInRegistryHolder().tags()
                .filter(t -> t.location().getNamespace().equals("pack_lbc") && t.location().getPath().startsWith(PREFIXE))
                .findFirst().map(t -> t.location().getPath().substring(PREFIXE.length()));
    }

    private static boolean present(Player joueur, LivingEntity boss) {
        return joueur.isAlive() && !joueur.isSpectator() && joueur.distanceToSqr(boss) <= RAYON * RAYON;
    }

    private static LootParams contexte(ServerLevel level, LivingEntity boss, DamageSource source, Player joueur) {
        return new LootParams.Builder(level)
                .withParameter(LootContextParams.THIS_ENTITY, boss)
                .withParameter(LootContextParams.ORIGIN, boss.position())
                .withParameter(LootContextParams.DAMAGE_SOURCE, source)
                .withOptionalParameter(LootContextParams.ATTACKING_ENTITY, joueur)
                .withOptionalParameter(LootContextParams.LAST_DAMAGE_PLAYER, joueur)
                .withLuck(joueur.getLuck())
                .create(LootContextParamSets.ENTITY);
    }

    private static void donne(Player joueur, ItemStack objet) {
        if (!joueur.getInventory().add(objet)) joueur.drop(objet, false);
    }

    @SubscribeEvent
    public static void onMort(LivingDeathEvent event) {
        LivingEntity boss = event.getEntity();
        if (!(boss.level() instanceof ServerLevel level) || !(boss.getKillCredit() instanceof Player)) return;
        Optional<String> famille = famille(boss);
        if (famille.isEmpty()) return;
        ResourceLocation id = ResourceLocation.fromNamespaceAndPath("pack_lbc", "boss/" + famille.get());
        LootTable table = level.getServer().reloadableRegistries().getLootTable(ResourceKey.create(Registries.LOOT_TABLE, id));
        for (Player joueur : level.players()) {
            if (!present(joueur, boss)) continue;
            for (ItemStack objet : table.getRandomItems(contexte(level, boss, event.getSource(), joueur))) donne(joueur, objet);
            joueur.displayClientMessage(Component.literal("Butin du boss ajouté à ton inventaire").withStyle(ChatFormatting.GOLD), true);
        }
    }

    @SubscribeEvent
    public static void onButin(LivingDropsEvent event) {
        LivingEntity boss = event.getEntity();
        if (!(boss.level() instanceof ServerLevel level) || !(boss.getKillCredit() instanceof Player tueur) || !tueur.isAlive()) return;
        if (famille(boss).isEmpty()) return;
        for (ItemEntity drop : event.getDrops()) donne(tueur, drop.getItem().copy());
        event.setCanceled(true);
        LootTable table = level.getServer().reloadableRegistries().getLootTable(boss.getLootTable());
        for (Player joueur : level.players()) {
            if (joueur == tueur || !present(joueur, boss)) continue;
            for (ItemStack objet : table.getRandomItems(contexte(level, boss, event.getSource(), joueur))) donne(joueur, objet);
        }
    }
}
