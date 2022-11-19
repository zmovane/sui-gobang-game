import React from "react";

export type Settings = { playing: boolean };

export const SettingsContext = React.createContext({
  settings: { playing: false },
  updateSettings: (_: Settings) => {},
});
