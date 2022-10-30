import React, { memo, useCallback } from "react";
import styled from "styled-components";
import { Square } from "./Square";

type ElementProps = { $value: string };

const Element = styled.div`
  width: 100%;
  height: 100%;
  border-radius: 50%;
  position: absolute;
  transform: scale(0.85);
  top: 0;
  left: 0;
  z-index: 1;

  ${(props: ElementProps) =>
    props.$value === "black" &&
    `
   background: black;
  `}

  ${(props: ElementProps) =>
    props.$value === "white" &&
    `
   background: white;
  `}
`;

type PieceProps = {
  row: number;
  col: number;
  value: string;
  onClick: any;
};

const Piece = ({ row, col, value, onClick }: PieceProps) => {
  const handleClick = useCallback(() => {
    onClick(row, col, value);
  }, [row, col, value, onClick]);

  return (
    <Square $row={row} $col={col} onClick={handleClick}>
      <Element $value={value} />
    </Square>
  );
};

export default memo(Piece);
