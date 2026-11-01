package lbc.fixes;

import com.mojang.serialization.Codec;
import com.mojang.serialization.codecs.RecordCodecBuilder;
import io.netty.buffer.ByteBuf;
import net.minecraft.core.UUIDUtil;
import net.minecraft.core.component.DataComponentType;
import net.minecraft.core.registries.Registries;
import net.minecraft.network.codec.ByteBufCodecs;
import net.minecraft.network.codec.StreamCodec;
import net.minecraft.world.entity.player.Inventory;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.inventory.Slot;
import net.minecraft.world.item.ItemStack;
import net.neoforged.bus.api.SubscribeEvent;
import net.neoforged.fml.common.EventBusSubscriber;
import net.neoforged.neoforge.event.entity.player.PlayerContainerEvent;
import net.neoforged.neoforge.event.entity.player.PlayerEvent;
import net.neoforged.neoforge.registries.DeferredHolder;
import net.neoforged.neoforge.registries.DeferredRegister;

import java.util.UUID;

/**
 * Better Inventory (retire en 1.2.6) marquait les objets ranges par ses loadouts avec le composant
 * betterinventory:loadout_origin. Sans ce type enregistre, le jeu refuse de charger ces objets (« Tried to load invalid item »)
 * et les remplace par du vide : 212 objets de Craukint le 01/11/2026. Le type est recree a l'identique (meme codec) pour que
 * les objets se rechargent, puis le composant est retire des objets du joueur a la connexion et de tout conteneur ouvert.
 */
@EventBusSubscriber(modid = LbcFixes.MOD_ID)
public final class AnciensComposants {

    record LoadoutOrigin(UUID owner, String section, int slot) {
        static final Codec<LoadoutOrigin> CODEC = RecordCodecBuilder.create(i -> i.group(
                UUIDUtil.CODEC.fieldOf("owner").forGetter(LoadoutOrigin::owner),
                Codec.STRING.fieldOf("section").forGetter(LoadoutOrigin::section),
                Codec.INT.fieldOf("slot").forGetter(LoadoutOrigin::slot)).apply(i, LoadoutOrigin::new));
        static final StreamCodec<ByteBuf, LoadoutOrigin> STREAM_CODEC = StreamCodec.composite(
                UUIDUtil.STREAM_CODEC, LoadoutOrigin::owner,
                ByteBufCodecs.STRING_UTF8, LoadoutOrigin::section,
                ByteBufCodecs.VAR_INT, LoadoutOrigin::slot,
                LoadoutOrigin::new);
    }

    static final DeferredRegister<DataComponentType<?>> COMPOSANTS = DeferredRegister.create(Registries.DATA_COMPONENT_TYPE, "betterinventory");
    static final DeferredHolder<DataComponentType<?>, DataComponentType<LoadoutOrigin>> LOADOUT_ORIGIN = COMPOSANTS.register("loadout_origin",
            () -> DataComponentType.<LoadoutOrigin>builder().persistent(LoadoutOrigin.CODEC).networkSynchronized(LoadoutOrigin.STREAM_CODEC).build());

    private AnciensComposants() {
    }

    private static boolean nettoyer(ItemStack objet) {
        if (objet.isEmpty() || !LOADOUT_ORIGIN.isBound() || !objet.has(LOADOUT_ORIGIN.get())) return false;
        objet.remove(LOADOUT_ORIGIN.get());
        return true;
    }

    @SubscribeEvent
    public static void onConnexion(PlayerEvent.PlayerLoggedInEvent event) {
        Player joueur = event.getEntity();
        Inventory inv = joueur.getInventory();
        boolean change = false;
        for (int i = 0; i < inv.getContainerSize(); i++) change |= nettoyer(inv.getItem(i));
        for (int i = 0; i < joueur.getEnderChestInventory().getContainerSize(); i++) change |= nettoyer(joueur.getEnderChestInventory().getItem(i));
        if (change) inv.setChanged();
    }

    @SubscribeEvent
    public static void onOuverture(PlayerContainerEvent.Open event) {
        for (Slot slot : event.getContainer().slots) {
            if (nettoyer(slot.getItem())) slot.setChanged();
        }
    }
}
