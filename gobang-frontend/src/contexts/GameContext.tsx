import React, { useState } from "react";

export type GameStatus = "IN_PROGRESS" | "W_WIN" | "B_WIN" | "DRAW";
export type Turn = "b" | "w";

export type Game = {
  objectId: string | null;
  blackPlayer: string | null;
  whitePlayer: string | null;
  currentTurn: Turn;
  gameStatus: GameStatus;
  gameBoard: Array<Array<number>>;
};

export const InitialGame: Game = {
  objectId: null,
  blackPlayer: null,
  whitePlayer: null,
  currentTurn: "b",
  gameStatus: "IN_PROGRESS",
  gameBoard: Array<number>(15).map((_) => Array<number>(15).fill(0)),
};

export const GameContext = React.createContext({
  game: InitialGame,
  updateGame: (_: Game) => {},
});

export const GameContextProvider = ({ children }: { children: any }) => {
  const [game, updateGame] = useState<Game>(InitialGame);
  const initialGame = {
    game,
    updateGame: (game: Game) => {
      updateGame(game);
    },
  };
  return (
    <GameContext.Provider value={initialGame}>{children}</GameContext.Provider>
  );
};
