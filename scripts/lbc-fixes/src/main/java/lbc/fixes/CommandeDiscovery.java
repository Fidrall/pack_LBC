package lbc.fixes;

import net.neoforged.bus.api.SubscribeEvent;
import net.neoforged.fml.ModList;
import net.neoforged.fml.common.EventBusSubscriber;
import net.neoforged.neoforge.event.RegisterCommandsEvent;

/**
 * Enregistre /vaisseaux_discovery seulement si Sable et Create Aeronautics Discovery sont charges : la commande elle-meme
 * (VaisseauxDiscovery) utilise leurs classes et n'est donc chargee qu'a ce moment-la.
 */
@EventBusSubscriber(modid = LbcFixes.MOD_ID)
public final class CommandeDiscovery {

    private CommandeDiscovery() {
    }

    @SubscribeEvent
    public static void onCommandes(RegisterCommandsEvent event) {
        if (ModList.get().isLoaded("sable") && ModList.get().isLoaded("aeronauticsdiscovery")) {
            VaisseauxDiscovery.enregistrer(event.getDispatcher());
        }
    }
}
