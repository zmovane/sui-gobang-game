import { useState, useCallback } from "react";

const SIZE = 15;

export default function useBoard() {
  const [board, setBoard] = useState<Array<Array<any>>>(
    Array(SIZE).fill(Array(SIZE).fill(null))
  );
  const [winner, _] = useState();
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

  return {
    board,
    winner,
    updateBoard,
  };
}
