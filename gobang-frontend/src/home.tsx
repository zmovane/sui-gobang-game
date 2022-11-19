import { useContext, useMemo, useState } from "react";
import { WalletProvider } from "@mysten/wallet-adapter-react";
import {
  UnsafeBurnerWalletAdapter,
  WalletStandardAdapterProvider,
} from "@mysten/wallet-adapter-all-wallets";
import { StartButton } from "./StartButton";
import { GobangBoard } from "./components/gobang/Board";
import { WalletWrapper } from "./components/modal/WalletWrapper";
import { Settings, SettingsContext } from "./contexts/SettingsContext";

export default function Home() {
  const [settings, updateSettings] = useState<Settings>({ playing: false });
  const adapters = useMemo(
    () => [
      new WalletStandardAdapterProvider(),
      new UnsafeBurnerWalletAdapter(),
    ],
    []
  );

  const settingsProvider = useMemo(
    () => ({
      settings,
      updateSettings: (settings: Settings) => {
        updateSettings(settings);
      },
    }),
    [settings]
  );
  return (
    <WalletProvider adapters={adapters}>
      <div>
        <div style={{ position: "absolute", right: "20px", top: "20px" }}>
          <WalletWrapper />
        </div>
        <SettingsContext.Provider value={settingsProvider}>
          <StartButton />
          <GobangBoard className="min-h-screen"></GobangBoard>
        </SettingsContext.Provider>
      </div>
    </WalletProvider>
  );
}
