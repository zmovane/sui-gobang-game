import styled from "styled-components";

export const Button = styled.button`
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: #312e2e;
  font-family: Impact, Haettenschweiler, "Arial Narrow Bold", sans-serif;
  padding: 10px 60px;
  background: #ebe8e8;
  border-radius: 10px;
  border-width: 0px;
  z-index: 1000;
  &:hover {
    background: #d7d5d5;
  }
`;
