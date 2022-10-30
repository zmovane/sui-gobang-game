import styled from "styled-components";
import useBoard from "../hooks/useBoard";
import Piece from "./Piece";

const Board = styled.div`
  display: inline-block;
  margin-top: 0;
`;
const Row = styled.div`
  display: flex;
`;

export const GobangBoard = () => {
  const { board, winner, handlePieceClick } = useBoard();

  return (
    <Board>
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
                  onClick={handlePieceClick}
                />
              );
            })}
          </Row>
        );
      })}
    </Board>
  );
};
