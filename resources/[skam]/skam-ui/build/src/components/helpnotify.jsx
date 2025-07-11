import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

export default function HelpNotify() {
  const [show, setShow] = useState(false);
  const [data, setData] = useState({});

  useEffect(() => {
    const onMessage = (event) => {
      const eventData = event.data;

      if (eventData.action === "nui:helpnotify:show") {
        if (eventData.show !== undefined) {
          setShow(true);
        }

        if (eventData.data) {
          setData(eventData.data);
        }
      }

      if (eventData.action === "nui:helpnotify:hide") {
        setShow(false);
      }
    };

    window.addEventListener("message", onMessage);
    return () => window.removeEventListener("message", onMessage);
  }, []);

  const parsedDesc = data.desc
    ? data.desc.replace(/<club>(.*?)<\/club>/g, '<span class="key-hint">$1</span>')
    : '';

  return (
    <AnimatePresence>
      {show && (
        <motion.div
          className="helpnotify"
          initial={{ x: '-100%', opacity: 0 }}
          animate={{ x: 0, opacity: 1 }}
          exit={{ x: '-100%', opacity: 0 }}
          transition={{ type: 'spring', stiffness: 300, damping: 30 }}
        >
          <div className="helpnotify-header">
            <img
              className="logohelpnotify"
              src="https://images-ext-1.discordapp.net/external/Wlf1yRLdZ_R5e0l1O4NNne_oOn0XI2fQPP044KdxvHY/https/r2.fivemanage.com/PsXrY56boeeCIZWpbOkiQ/skam.png?format=webp&quality=lossless&width=1409&height=1079"
            />
            {data.title}
          </div>
          <div
            className="helpnotify-desc"
            dangerouslySetInnerHTML={{ __html: parsedDesc }}
          />
        </motion.div>
      )}
    </AnimatePresence>
  );
}