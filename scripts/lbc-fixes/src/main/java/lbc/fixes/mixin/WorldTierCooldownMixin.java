package lbc.fixes.mixin;

import dev.shadowsoffire.apotheosis.net.WorldTierPayload;
import dev.shadowsoffire.apotheosis.tiers.WorldTier;
import net.minecraft.ChatFormatting;
import net.minecraft.nbt.CompoundTag;
import net.minecraft.network.chat.Component;
import net.minecraft.network.protocol.PacketFlow;
import net.minecraft.server.level.ServerPlayer;
import net.neoforged.neoforge.network.PacketDistributor;
import net.neoforged.neoforge.network.handling.IPayloadContext;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

/**
 * Apotheosis 8.9 : le palier (World Tier) se change a volonte dans les deux sens (Ctrl+T). Abus possible :
 * farmer les monstres en Havre puis remonter juste pour ouvrir un coffre (Lootr tire le butin au palier de
 * celui qui ouvre), ou piller en haut et combattre en bas. Baisser reste toujours permis, mais apres une
 * baisse il faut attendre une heure de jeu (temps du serveur) avant de remonter. Monter sans avoir baisse
 * reste libre. La date de la derniere baisse est gardee a la mort (PlayerRestoreMixin).
 */
@Mixin(targets = "dev.shadowsoffire.apotheosis.net.WorldTierPayload$Provider", remap = false)
public abstract class WorldTierCooldownMixin {

    private static final String LBCFIXES_CLE = "lbcfixes_baisse_palier"; // meme cle dans PlayerRestoreMixin
    private static final long LBCFIXES_DELAI = 72000L; // 1 h de jeu

    @Inject(method = "handle(Ldev/shadowsoffire/apotheosis/net/WorldTierPayload;Lnet/neoforged/neoforge/network/handling/IPayloadContext;)V",
            at = @At("HEAD"), cancellable = true, remap = false)
    private void lbcfixes$delaiApresBaisse(WorldTierPayload msg, IPayloadContext ctx, CallbackInfo ci) {
        if (ctx.flow() != PacketFlow.SERVERBOUND || !(ctx.player() instanceof ServerPlayer player)) return;
        WorldTier actuel = WorldTier.getTier(player);
        WorldTier voulu = msg.tier();
        CompoundTag data = player.getPersistentData();
        long maintenant = player.server.overworld().getGameTime();
        if (voulu.ordinal() < actuel.ordinal()) {
            data.putLong(LBCFIXES_CLE, maintenant);
            return;
        }
        if (voulu.ordinal() > actuel.ordinal() && data.contains(LBCFIXES_CLE)) {
            long reste = data.getLong(LBCFIXES_CLE) + LBCFIXES_DELAI - maintenant;
            if (reste > 0) {
                ci.cancel();
                long minutes = (reste + 1199) / 1200;
                player.sendSystemMessage(Component.literal("Tu as baissé ton palier récemment : tu pourras remonter dans " + minutes + " min.")
                        .withStyle(ChatFormatting.GOLD));
                PacketDistributor.sendToPlayer(player, new WorldTierPayload(actuel));
            }
        }
    }
}
