import React, { useMemo, useState } from "react";

export type Settings = { playing: boolean };

export const InitialSettings = { playing: false };

export const SettingsContext = React.createContext({
  settings: InitialSettings,
  updateSettings: (_: Settings) => {},
});

export const SettingsContextProvider = ({ children }: { children: any }) => {
  const [settings, updateSettings] = useState<Settings>(InitialSettings);
  const initialSettings = useMemo(
    () => ({
      settings,
      updateSettings: (settings: Settings) => {
        updateSettings(settings);
      },
    }),
    [settings]
  );
  return (
    <SettingsContext.Provider value={initialSettings}>
      {children}
    </SettingsContext.Provider>
  );
};
