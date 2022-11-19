import { useWallet } from "@mysten/wallet-adapter-react";
import { useContext } from "react";
import { SettingsContext } from "../../contexts/SettingsContext";
import styled from "styled-components";
import useBoard from "../../hooks/useBoard";
import Piece from "./Piece";

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

  const { getAccounts, signAndExecuteTransaction } = useWallet();
  const { board, winner, handlePieceClick } = useBoard();

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
