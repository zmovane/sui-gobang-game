import { useWallet } from "@mysten/wallet-adapter-react";
import { useContext } from "react";
import { Button } from "./components/Button";
import { fromB64 } from "@mysten/bcs";

import { SettingsContext } from "./contexts/SettingsContext";
import {
  CertifiedTransaction,
  Ed25519Keypair,
  JsonRpcProvider,
  RawSigner,
  SuiCertifiedTransactionEffects,
} from "@mysten/sui.js";
export function StartButton() {
  const { settings, updateSettings } = useContext(SettingsContext);
  const { getAccounts, signAndExecuteTransaction } = useWallet();
  const decoded_array_buffer = fromB64(import.meta.env.VITE_WALLET_SECRET_KEY!);
  const decoded_array = Array.from(decoded_array_buffer);
  // shift the scheme flag byte which should be 0 since it is ed25519
  decoded_array.shift();
  const privkey = Uint8Array.from(decoded_array.slice(32, 64));
  const keypair = Ed25519Keypair.fromSeed(privkey);
  const provider = new JsonRpcProvider();
  const signer = new RawSigner(keypair, provider);

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
    const objectId =
      result.EffectsCert.effects.effects.created!![0].reference.objectId;
    console.log("New object id:", objectId);
  };

  return settings.playing ? (
    <></>
  ) : (
    <Button onClick={handleClick}>Start</Button>
  );
}
