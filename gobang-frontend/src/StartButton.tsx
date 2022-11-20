import { useWallet } from "@mysten/wallet-adapter-react";
import { useContext } from "react";
import { Button } from "./components/Button";
import { SettingsContext } from "./contexts/SettingsContext";
import {
  CertifiedTransaction,
  SuiCertifiedTransactionEffects,
} from "@mysten/sui.js";
import { GameContext } from "./contexts/GameContext";
import { fromSecretKey } from "./utils/wallet";

export function StartButton() {
  const { game, updateGame } = useContext(GameContext);
  const { settings, updateSettings } = useContext(SettingsContext);
  const { getAccounts } = useWallet();
  const signer = fromSecretKey(import.meta.env.VITE_WALLET_SECRET_KEY!);

  const handleClick = async () => {
    updateSettings({ ...settings, playing: true });
    const player = (await getAccounts())[0];
    const data = {
      packageObjectId: import.meta.env.VITE_GAME_ADDRESS,
      module: "gobang",
      function: "create_game",
      typeArguments: [],
      arguments: [player, import.meta.env.VITE_GAME_GRANTER],
      gasBudget: 10000,
    };

    const result = (await signer.executeMoveCallWithRequestType(
      data,
      "WaitForEffectsCert"
    )) as {
      EffectsCert: {
        certificate: CertifiedTransaction;
        effects: SuiCertifiedTransactionEffects;
      };
    };
    console.log("Tx Result: ", result);
    const created = result.EffectsCert.effects.effects.created ?? [];
    if (created.length == 0) {
      console.log("Failed to create game");
      return;
    }
    const objectId = created[0].reference.objectId;
    updateGame({ ...game, objectId: objectId });
  };

  return settings.playing ? (
    <></>
  ) : (
    <Button onClick={handleClick}>Start</Button>
  );
}
