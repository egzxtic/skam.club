import { useState, useEffect, useRef, useCallback, useMemo } from "react";

export const nui = {
  on: (action, callback) => {
    const handler = (event) => {
      if (event.data && event.data.action === action) {
        callback(event.data);
      }
    };
    
    window.addEventListener('message', handler);
    return () => window.removeEventListener('message', handler);
  },
  
  emit: (action, data = {}) => {
    fetch(`https://${window.location.hostname}/${action}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify(data),
    }).catch(err => console.error('Error sending NUI message', err));
  },
  
  close: () => {
    nui.emit('hideFrame');
  }
};

const debounce = (func, delay) => {
  let timeoutId;
  return (...args) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => func(...args), delay);
  };
};

const useLocalStorage = (key, defaultValue) => {
  const [value, setValue] = useState(() => {
    try {
      const saved = localStorage.getItem(key);
      return saved ? JSON.parse(saved) : defaultValue;
    } catch {
      return defaultValue;
    }
  });

  const saveValue = useCallback((newValue) => {
    try {
      localStorage.setItem(key, JSON.stringify(newValue));
      setValue(newValue);
    } catch (error) {
      console.error("Błąd podczas zapisywania ustawień:", error);
    }
  }, [key]);

  return [value, saveValue];
};

const createDebouncedDispatch = () => {
  const debouncedMap = {};
  return (type, detail) => {
    if (!debouncedMap[type]) {
      debouncedMap[type] = debounce((latestDetail) => {
        window.dispatchEvent(
          new CustomEvent("settings:update", {
            detail: { type, ...latestDetail },
          })
        );
      }, 16);
    }
    debouncedMap[type](detail);
  };
};

const debouncedDispatch = createDebouncedDispatch();

const Settings = () => {
  const defaultSettings = {
    hudVisible: true,
    hudColor: "#fff",
    hudStyle: "Klasyczny",
    hudPosition: "Klasyczny",
    watermarkId: true,
    watermarkKD: true,
    carHudVisible: true,
    carHudStyle: "BASIC",
    watermarkId2: true,
  };

  const [settings, setSettings] = useLocalStorage("grzch-ui-settings", defaultSettings);
  const [tempColor, setTempColor] = useState(settings.hudColor);
  const [openDropdown, setOpenDropdown] = useState(null);
  const [visible, setVisible] = useState(false);

  const dropdownRefs = useRef({
    hudStyle: null,
    hudPosition: null,
    carHudStyle: null,
  });

  const debouncedUpdateEvents = useMemo(
    () =>
      debounce((color) => {
        window.dispatchEvent(
          new CustomEvent("settings:update", {
            detail: { type: "hud", color },
          })
        );
        window.dispatchEvent(
          new CustomEvent("settings:update", {
            detail: { type: "carhud", color },
          })
        );
      }, 16), 
    []
  );

  useEffect(() => {
    const unsubscribe = nui.on("nui:settings", () => {
      setVisible(true);
    });
    return unsubscribe;
  }, []);

  useEffect(() => {
    const handleMessage = (event) => {
      if (event.data && event.data.type === "OPEN_SETTINGS") {
        setVisible(true);
      }
    };
    window.addEventListener("message", handleMessage);
    return () => window.removeEventListener("message", handleMessage);
  }, []);

  const saveAndClose = useCallback(() => {
    const updatedSettings = { ...settings, hudColor: tempColor };
    setSettings(updatedSettings);
    window.dispatchEvent(
      new CustomEvent("settings:saved", {
        detail: { settings: updatedSettings },
      })
    );
    setVisible(false);
    nui.emit("settings:closed", { saved: true });
    nui.close();
  }, [settings, tempColor, setSettings]);

  useEffect(() => {
    const handleKeyDown = (event) => {
      if (event.key === "Escape" && visible) {
        saveAndClose();
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [visible, saveAndClose]);

  const updateSetting = useCallback(
    (key, value, eventType, eventData) => {
      const newSettings = { ...settings, [key]: value };
      setSettings(newSettings);
      if (eventType && eventData) {
        debouncedDispatch(eventType, eventData);
      }
    },
    [settings, setSettings]
  );

  const handleColorChange = useCallback(
    (e) => {
      const color = e.target.value;
      setTempColor(color);
      debouncedUpdateEvents(color);
    },
    [debouncedUpdateEvents]
  );

  useEffect(() => {
    setTempColor(settings.hudColor);
  }, [settings.hudColor]);

  useEffect(() => {
    const timer = setTimeout(() => {
      window.dispatchEvent(
        new CustomEvent("settings:update", {
          detail: {
            type: "hud",
            visible: settings.hudVisible,
            color: settings.hudColor,
            style: settings.hudStyle,
            position: settings.hudPosition,
          },
        })
      );
      window.dispatchEvent(
        new CustomEvent("settings:update", {
          detail: {
            type: "watermark",
            showId: settings.watermarkId,
            showKD: settings.watermarkKD,
            showId2: settings.watermarkId2,
          },
        })
      );
      window.dispatchEvent(
        new CustomEvent("settings:update", {
          detail: {
            type: "carhud",
            visible: settings.carHudVisible,
            style: settings.carHudStyle,
            color: settings.hudColor,
          },
        })
      );
    }, 0);

    return () => clearTimeout(timer);
  }, [settings]);

  useEffect(() => {
    const handleClickOutside = (event) => {
      if (
        openDropdown &&
        !Object.values(dropdownRefs.current).some((ref) => ref?.contains(event.target))
      ) {
        setOpenDropdown(null);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, [openDropdown]);

  const toggleSetting = useCallback(
    (key, eventType, eventKey) => {
      const newValue = !settings[key];
      updateSetting(key, newValue, eventType, { [eventKey]: newValue });
    },
    [settings, updateSetting]
  );

  const handleDropdownSelect = useCallback(
    (value, key, eventType, eventKey) => {
      updateSetting(key, value, eventType, { [eventKey]: value });
      setOpenDropdown(null);
    },
    [updateSetting]
  );

  const ToggleButton = ({ isOn, onClick, label }) => (
    <div className="flex items-center justify-between">
      <span className="font-bold text-lg">{label}</span>
      <button
        className={`rounded transition-all w-[8vh] h-[2.6vh] duration-300 text-sm font-bold ${
          isOn
            ? "bg-white text-black"
            : "bg-neutral-800 text-neutral-400 border border-neutral-600 hover:bg-neutral-700"
        }`}
        onClick={onClick}
      >
        {isOn ? "WŁ" : "WYŁ"}
      </button>
    </div>
  );

  const Dropdown = ({ name, value, options, onSelect, label }) => (
    <div className="flex items-center justify-between">
      <span className="font-bold text-lg">{label}</span>
      <div className="relative min-w-[120px]" ref={(el) => (dropdownRefs.current[name] = el)}>
        <button
          className="w-full px-4 py-1.5 rounded bg-neutral-800 text-white text-sm font-bold border border-neutral-600 flex justify-between items-center hover:bg-neutral-700 transition-colors duration-200 min-w-[120px] h-[32px]"
          onClick={() => setOpenDropdown(openDropdown === name ? null : name)}
        >
          {value}
          <svg className="w-4 h-4 ml-2 fill-current" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
            <path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z" />
          </svg>
        </button>
        {openDropdown === name && (
          <div className="absolute top-full left-0 w-full mt-1 rounded bg-neutral-800 border border-neutral-700 shadow-lg overflow-hidden z-10">
            {options.map((option) => (
              <div
                key={option}
                className={`px-4 py-1.5 cursor-pointer font-bold text-sm ${
                  value === option ? "bg-white text-black" : "hover:bg-neutral-700 text-neutral-300"
                }`}
                onClick={() => onSelect(option)}
              >
                {option}
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );

  if (!visible) return null;

  return (
    <div
      className="fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-black/90 rounded-2xl shadow-lg p-10 w-[700px] max-w-[98vw] z-50 border border-neutral-700 flex flex-col justify-center items-center"
      style={{ height: "660px", overflowY: "auto" }}
    >
      <button
        className="absolute top-4 right-5 text-neutral-400 hover:text-white transition-colors"
        onClick={saveAndClose}
        aria-label="Zamknij"
      >
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
          <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z" />
        </svg>
      </button>

      <div className="mb-2 w-full">
        <h2 className="text-3xl font-bold leading-tight">USTAWIENIA</h2>
        <p className="text-neutral-300 text-base mt-1">Dostosuj ustawienia wyświetlanego hudu pod swoje upodobania!</p>
        <small className="text-neutral-500">Naciśnij ESC lub przycisk X aby zamknąć i zapisać</small>
      </div>

      <div className="flex items-center justify-between my-4 w-full">
        <div className="flex-1 h-px bg-neutral-700" />
        <span className="mx-4 text-neutral-500 font-bold tracking-widest select-none" style={{ letterSpacing: "0.15em" }}>
          OGÓLNE
        </span>
        <div className="flex-1 h-px bg-neutral-700" />
      </div>

      <div className="flex flex-col gap-4 w-full">
        <ToggleButton
          isOn={settings.hudVisible}
          onClick={() => toggleSetting("hudVisible", "hud", "visible")}
          label="WIDOCZNOŚĆ HUD'U"
        />

        <div className="flex items-center justify-between">
          <span className="font-bold text-lg">KOLOR HUD'U</span>
          <input
            type="color"
            value={tempColor}
            onChange={handleColorChange}
            className="w-10 h-7 rounded border border-neutral-600 bg-neutral-800 cursor-pointer"
            style={{ padding: 0 }}
          />
        </div>

        <Dropdown
          name="hudStyle"
          value={settings.hudStyle}
          options={["BASIC", "Klasyczny"]}
          onSelect={(value) => handleDropdownSelect(value, "hudStyle", "hud", "style")}
          label="STYL HUD'U"
        />

        <Dropdown
          name="hudPosition"
          value={settings.hudPosition}
          options={["Klasyczny", "Góra", "Lewy", "Prawy"]}
          onSelect={(value) => handleDropdownSelect(value, "hudPosition", "hud", "position")}
          label="POZYCJA HUD'U"
        />

        <ToggleButton
          isOn={settings.watermarkId}
          onClick={() => toggleSetting("watermarkId", "watermark", "showId")}
          label="WIDOCZNOŚĆ ID (WATERMARK)"
        />

        <ToggleButton
          isOn={settings.watermarkKD}
          onClick={() => toggleSetting("watermarkKD", "watermark", "showKD")}
          label="WIDOCZNOŚĆ K/D (WATERMARK)"
        />

        <ToggleButton
          isOn={settings.carHudVisible}
          onClick={() => toggleSetting("carHudVisible", "carhud", "visible")}
          label="WIDOCZNOŚĆ CAR HUD'U"
        />

        <Dropdown
          name="carHudStyle"
          value={settings.carHudStyle}
          options={["BASIC", "Klasyczny"]}
          onSelect={(value) => handleDropdownSelect(value, "carHudStyle", "carhud", "style")}
          label="STYL CAR HUD'U"
        />

        <ToggleButton
          isOn={settings.watermarkId2}
          onClick={() => toggleSetting("watermarkId2", "watermark", "showId2")}
          label="WIDOCZNOŚĆ ID (WATERMARK)"
        />
      </div>
    </div>
  );
};

export default Settings;