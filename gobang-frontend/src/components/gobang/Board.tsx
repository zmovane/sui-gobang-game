import { useWallet } from "@mysten/wallet-adapter-react";
import { useContext } from "react";
import { SettingsContext } from "../../contexts/SettingsContext";
import styled from "styled-components";
import useBoard from "../../hooks/useBoard";
import Piece from "./Piece";
import {
  CertifiedTransaction,
  SuiCertifiedTransactionEffects,
  SuiTransactionResponse,
} from "@mysten/sui.js";
import { GameContext, Turn } from "../../contexts/GameContext";
import { fromSecretKey } from "../../utils/wallet";

const Board = styled.div`
  display: inline-block;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  margin-top: 0;
`;
const Row = styled.div`
  display: flex;
`;

type boardProps = { className: string };
export const GobangBoard = (props: boardProps) => {
  const { settings } = useContext(SettingsContext);
  const { game, updateGame } = useContext(GameContext);

  const { signAndExecuteTransaction } = useWallet();
  const { board, updateBoard } = useBoard();

  const botSigner = fromSecretKey(import.meta.env.VITE_WALLET_SECRET_KEY!);

  const userTry = async (row: number, col: number) => {
    const data = {
      packageObjectId: import.meta.env.VITE_GAME_ADDRESS,
      module: "gobang",
      function: "place_mark",
      typeArguments: [],
      arguments: [game.objectId!, row, col],
      gasBudget: 10000,
    };
    const result = (await signAndExecuteTransaction({
      kind: "moveCall",
      data: data,
    })) as SuiTransactionResponse;
    console.log("Mutated: ", result);
  };

  const botTry = async (row: number, col: number) => {
    const data = {
      packageObjectId: import.meta.env.VITE_GAME_ADDRESS,
      module: "gobang",
      function: "place_mark",
      typeArguments: [],
      arguments: [game.objectId!, row, col],
      gasBudget: 10000,
    };
    const result = (await botSigner.executeMoveCallWithRequestType(
      data,
      "WaitForEffectsCert"
    )) as {
      EffectsCert: {
        certificate: CertifiedTransaction;
        effects: SuiCertifiedTransactionEffects;
      };
    };
    console.log("Mutated: ", result);
  };

  const play = async (row: number, col: number, turn: Turn) => {
    console.log("play", game.objectId);
    console.log("playing", settings.playing);
    console.log("turn", game.currentTurn);
    if (game.currentTurn == "b") {
      await userTry(row, col);
    } else {
      await botTry(row, col);
    }
  };

  const handlePieceClick = async (row: number, col: number, value: string) => {
    if (value) return;
    await play(row, col, game.currentTurn);
    if (updateBoard(row, col, game.currentTurn)) {
      updateGame({
        ...game,
        currentTurn: game.currentTurn === "b" ? "w" : "b",
      });
    }
  };
  return (
    <Board className={props.className}>
      {board.map((row, rowIndex) => {
        return (
          <Row key={rowIndex}>
            {row.map((col: number, colIndex: number) => {
              return (
                <Piece
                  key={colIndex}
                  row={rowIndex}
                  col={colIndex}
                  value={board[rowIndex][colIndex]}
                  onClick={settings.playing ? handlePieceClick : undefined}
                />
              );
            })}
          </Row>
        );
      })}
    </Board>
  );
};
