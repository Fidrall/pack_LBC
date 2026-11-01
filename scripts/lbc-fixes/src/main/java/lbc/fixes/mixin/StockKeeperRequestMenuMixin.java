package lbc.fixes.mixin;

import com.simibubi.create.content.logistics.stockTicker.StockKeeperRequestMenu;
import com.simibubi.create.content.logistics.stockTicker.StockTickerBlockEntity;
import net.minecraft.core.registries.BuiltInRegistries;
import net.minecraft.resources.ResourceLocation;
import net.minecraft.world.entity.player.Inventory;
import net.minecraft.world.inventory.AbstractContainerMenu;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfoReturnable;

/**
 * Create 6.0.10 : StockKeeperRequestMenu.create construit cote serveur un StockKeeperCategoryMenu (1 case de categorie
 * + 36 cases joueur) alors que le client construit un StockKeeperRequestMenu (36 cases). Si la 37e case change pendant
 * que l'ecran de commande est ouvert (derniere case de la barre d'action), le client recoit l'index 36 et se deconnecte
 * (« Network Protocol Error », IndexOutOfBoundsException dans ClientboundContainerSetSlotPacket).
 * Le serveur construit maintenant le meme menu que le client. Aucun code serveur de Create n'attend un menu de categories ici.
 */
@Mixin(value = StockKeeperRequestMenu.class, remap = false)
public abstract class StockKeeperRequestMenuMixin {

    @Inject(method = "create", at = @At("HEAD"), cancellable = true, remap = false)
    private static void lbcfixes$bonMenu(int id, Inventory inv, StockTickerBlockEntity be, CallbackInfoReturnable<AbstractContainerMenu> cir) {
        var type = BuiltInRegistries.MENU.get(ResourceLocation.fromNamespaceAndPath("create", "stock_keeper_request"));
        if (type != null) {
            cir.setReturnValue(new StockKeeperRequestMenu(type, id, inv, be));
        }
    }
}
