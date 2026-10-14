package lbc.fixes.mixin;

import com.llamalad7.mixinextras.injector.wrapoperation.Operation;
import com.llamalad7.mixinextras.injector.wrapoperation.WrapOperation;
import dev.ftb.mods.ftbchunks.client.FTBChunksClient;
import dev.ftb.mods.ftbchunks.client.FTBChunksClientConfig;
import dev.ftb.mods.ftbchunks.client.map.MapDimension;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;

/**
 * FTB Chunks 2101.1.22 : renderHud met a jour la texture de la minimap (lecture des regions de carte)
 * AVANT de tester MINIMAP_ENABLED. Le pack utilise la minimap de JourneyMap : ce travail est perdu
 * et apparaissait dans les pics de lag des joueurs. On ne met a jour que si la minimap est activee.
 */
@Mixin(FTBChunksClient.class)
public abstract class FtbMinimapMixin {

    @WrapOperation(method = "renderHud",
            at = @At(value = "INVOKE",
                    target = "Ldev/ftb/mods/ftbchunks/client/FTBChunksClient;updateMinimapIfNeeded(IILdev/ftb/mods/ftbchunks/client/map/MapDimension;Z)V"))
    private void lbcfixes$skipHiddenMinimap(FTBChunksClient client, int x, int z, MapDimension dimension, boolean force, Operation<Void> original) {
        if (FTBChunksClientConfig.MINIMAP_ENABLED.get()) {
            original.call(client, x, z, dimension, force);
        }
    }
}
