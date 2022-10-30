import type { NextPage } from "next";

import { GobangBoard } from "../components/Board";

const Home: NextPage = () => {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center py-2">
      <GobangBoard></GobangBoard>
    </div>
  );
};

export default Home;
