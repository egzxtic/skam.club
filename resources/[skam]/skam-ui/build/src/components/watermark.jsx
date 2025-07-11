import { useEffect, useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Logo } from "./../utils/nui.jsx";

export default function WaterMark() {
  const [graczy, setGraczy] = useState("0");
  const [kd, setKd] = useState("0.00");
  const [scoreboard, setScoreboard] = useState(false);
  const [players, setPlayers] = useState("0");
  
  const [showId, setShowId] = useState(true);
  const [showKD, setShowKD] = useState(true);
  const [showId2, setShowId2] = useState(true);

  useEffect(() => {
    const handleNuiMessage = (event) => {
      const data = event.data;

      switch (data.type) {
        case "nui:watermark":
          setGraczy(data.playerid || "0");
          setKd(data.kd || "0.0");
          break;
        // case "nui:scoreboard:show":
        //   setScoreboard(data.state === true);
        //   setPlayers(data.players || "0");
        //   break;
      }
    };

    window.addEventListener("message", handleNuiMessage);
    return () => window.removeEventListener("message", handleNuiMessage);
  }, []);
  
  useEffect(() => {
    const handleSettingsUpdate = (event) => {
      const { type, ...data } = event.detail;
      
      if (type === 'watermark') {
        if (data.showId !== undefined) setShowId(data.showId);
        if (data.showKD !== undefined) setShowKD(data.showKD);
        if (data.showId2 !== undefined) setShowId2(data.showId2);
      }
    };

    window.addEventListener('settings:update', handleSettingsUpdate);
    return () => {
      window.removeEventListener('settings:update', handleSettingsUpdate);
    };
  }, []);

  if (!showId && !showKD && !showId2) {
    return null;
  }

  return (
    <div className="watermark">
      <div className="watermark-row">
        <div className="watermark-pierwszytentego">
          {showId && (
            <>
              <i className="fa-solid fa-users"></i> {graczy}
              <div className="linia"></div>
            </>
          )}
          {showKD && (
            <>
              <i className="fa-solid fa-swords"></i> {kd}
              <div className="linia"></div>
            </>
          )}
          {showId2 && (
            <div className="watermark-tytul">
              <Logo className="watermark-logo" />
            </div>
          )}

          <AnimatePresence>
            {scoreboard && (
              <motion.div
                key="players"
                className="players"
                initial={{
                  opacity: 0,
                  y: 22,
                  scale: 0.97,
                  filter: "blur(10px)",
                }}
                animate={{
                  opacity: 1,
                  y: 0,
                  scale: 1,
                  filter: "blur(0px)",
                }}
                exit={{
                  opacity: 0,
                  y: -18,
                  scale: 0.96,
                  filter: "blur(12px)",
                }}
                transition={{
                  duration: 0.18,
                  ease: [0.7, 0, 0.25, 1],
                }}
                style={{
                  willChange: "opacity, transform, filter",
                }}
              >
                <motion.span
                  initial={{ opacity: 0, y: 10, scale: 0.98 }}
                  animate={{ opacity: 1, y: 0, scale: 1 }}
                  exit={{ opacity: 0, y: -8, scale: 0.98 }}
                  transition={{
                    duration: 0.14,
                    ease: [0.7, 0, 0.25, 1],
                  }}
                  style={{
                    display: "inline-block",
                    willChange: "opacity, transform",
                  }}
                >
                  {players} GRACZY
                </motion.span>
              </motion.div>
            )}
          </AnimatePresence>
        </div>
      </div>
    </div>
  );
}