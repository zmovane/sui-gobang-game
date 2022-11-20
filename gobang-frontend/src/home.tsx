import { useMemo } from "react";
import { WalletProvider } from "@mysten/wallet-adapter-react";
import {
  UnsafeBurnerWalletAdapter,
  WalletStandardAdapterProvider,
} from "@mysten/wallet-adapter-all-wallets";
import { StartButton } from "./StartButton";
import { GobangBoard } from "./components/gobang/Board";
import { WalletWrapper } from "./components/modal/WalletWrapper";
import { SettingsContextProvider } from "./contexts/SettingsContext";
import { GameContextProvider } from "./contexts/GameContext";

export default function Home() {
  const adapters = useMemo(
    () => [
      new WalletStandardAdapterProvider(),
      new UnsafeBurnerWalletAdapter(),
    ],
    []
  );

  return (
    <WalletProvider adapters={adapters}>
      <div>
        <div style={{ position: "absolute", right: "20px", top: "20px" }}>
          <WalletWrapper />
        </div>
        <SettingsContextProvider>
          <GameContextProvider>
            <StartButton />
            <GobangBoard className="min-h-screen"></GobangBoard>
          </GameContextProvider>
        </SettingsContextProvider>
      </div>
    </WalletProvider>
  );
}
