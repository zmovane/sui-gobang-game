import styled from "styled-components";

type SquareProps = { $row: number; $col: number };
const BOARD_SIZE = 15;

export const Square = styled.div`
  width: 40px;
  height: 40px;
  background: #c19d38;
  position: relative;

  &:before {
    content: "";
    height: 100%;
    width: 2px;
    background: black;
    position: absolute;
    top: 0;
    left: 50%;
    transform: translateX(-50%);

    ${(props: SquareProps) =>
      props.$row === 0 &&
      `
      top: 50%;
    `}

    ${(props: SquareProps) =>
      props.$row === BOARD_SIZE - 1 &&
      `
      height: 50%;
    `}
  }

  &:after {
    content: "";
    width: 100%;
    height: 2px;
    background: black;
    position: absolute;
    top: 50%;
    left: 0;
    transform: translateY(-50%);

    ${(props: SquareProps) =>
      props.$col === 0 &&
      `
      left: 50%;
    `}

    ${(props: SquareProps) =>
      props.$col === BOARD_SIZE - 1 &&
      `
      width: 50%;
    `}
  }
`;
