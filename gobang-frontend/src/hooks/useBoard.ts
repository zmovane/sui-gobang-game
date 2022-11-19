import { useState, useCallback } from "react";

const SIZE = 15;

export default function useBoard() {
  const [board, setBoard] = useState<Array<Array<any>>>(
    Array(SIZE).fill(Array(SIZE).fill(null))
  );
  const [winner, _] = useState();

  let turn = 0;
  const currentTurn = () => {
    return turn % 2 == 0 ? "b" : "w";
  };

  const updateBoard = useCallback((y: number, x: number, newVal: string) => {
    if (board[y][x]) {
      return false;
    }
    setBoard((board) =>
      board.map((row, Y) => {
        if (Y !== y) return row;
        return row.map((value: number, X: number) => {
          if (X !== x) return value;
          return newVal;
        });
      })
    );

    return true;
  }, []);

  const handlePieceClick = useCallback(
    (row: number, col: number, value: string) => {
      if (value) return;
      if (updateBoard(row, col, currentTurn())) {
        turn += 1;
      }
    },
    [updateBoard]
  );

  return {
    board,
    winner,
    handlePieceClick,
  };
}
