import { useState, useRef, useCallback } from "react";

const SIZE = 15;

export default function useBoard() {
  const [board, setBoard] = useState(Array(SIZE).fill(Array(SIZE).fill(null)));
  const [winner, setWinner] = useState();

  const isBlackMoving = useRef(true);

  const lastRow = useRef<number>();
  const lastCol = useRef<number>();

  const updateBoard = useCallback((y: number, x: number, newValue: string) => {
    setBoard((board) =>
      board.map((row, currentY) => {
        if (currentY !== y) return row;
        return row.map((col: number, currentX: number) => {
          if (currentX !== x) return col;
          return newValue;
        });
      })
    );
  }, []);

  const handlePieceClick = useCallback(
    (row: number, col: number, value: string) => {
      if (value) return;
      lastRow.current = row;
      lastCol.current = col;
      updateBoard(row, col, isBlackMoving.current ? "black" : "white");
      isBlackMoving.current = !isBlackMoving.current;
    },
    [updateBoard]
  );

  return {
    board,
    winner,
    handlePieceClick,
  };
}
