package lbc.fixes;

import net.minecraft.core.registries.Registries;
import net.minecraft.nbt.CompoundTag;
import net.minecraft.nbt.ListTag;
import net.minecraft.nbt.Tag;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.tags.TagKey;
import net.minecraft.world.entity.player.Inventory;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.item.Item;
import net.minecraft.world.item.ItemStack;
import net.neoforged.bus.api.EventPriority;
import net.neoforged.bus.api.SubscribeEvent;
import net.neoforged.fml.common.EventBusSubscriber;
import net.neoforged.neoforge.event.entity.living.LivingDeathEvent;
import net.neoforged.neoforge.event.entity.player.PlayerEvent;

/**
 * Objets gardes a la mort : ceux du tag d'objets pack_lbc:garde_a_la_mort (datapack, build-datapack section 29) sont retires
 * de l'inventaire juste avant la mort (donc hors du cadavre Corpse) et rendus a la reapparition. Ils sont gardes dans les
 * donnees persistantes du joueur, ce qui survit a une deconnexion pendant l'ecran de mort.
 */
@EventBusSubscriber(modid = LbcFixes.MOD_ID)
public final class GardeALaMort {

    private static final TagKey<Item> GARDE = TagKey.create(Registries.ITEM, ResourceLocation.fromNamespaceAndPath("pack_lbc", "garde_a_la_mort"));
    private static final String CLE = "lbcfixes_garde_a_la_mort";

    private GardeALaMort() {
    }

    @SubscribeEvent(priority = EventPriority.LOWEST)
    public static void onMort(LivingDeathEvent event) {
        if (!(event.getEntity() instanceof Player joueur) || joueur.level().isClientSide()) return;
        Inventory inv = joueur.getInventory();
        ListTag gardes = joueur.getPersistentData().getList(CLE, Tag.TAG_COMPOUND);
        for (int i = 0; i < inv.getContainerSize(); i++) {
            ItemStack objet = inv.getItem(i);
            if (objet.isEmpty() || !objet.is(GARDE)) continue;
            gardes.add(objet.save(joueur.registryAccess()));
            inv.setItem(i, ItemStack.EMPTY);
        }
        if (!gardes.isEmpty()) joueur.getPersistentData().put(CLE, gardes);
    }

    @SubscribeEvent
    public static void onReapparition(PlayerEvent.Clone event) {
        if (!event.isWasDeath()) return;
        CompoundTag donnees = event.getOriginal().getPersistentData();
        if (!donnees.contains(CLE)) return;
        Player joueur = event.getEntity();
        for (Tag t : donnees.getList(CLE, Tag.TAG_COMPOUND)) {
            ItemStack objet = ItemStack.parse(joueur.registryAccess(), t).orElse(ItemStack.EMPTY);
            if (!objet.isEmpty() && !joueur.getInventory().add(objet)) joueur.drop(objet, false);
        }
        donnees.remove(CLE);
        joueur.getPersistentData().remove(CLE);
    }
}
