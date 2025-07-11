import { useEffect, useState } from 'react';

const colorText = (txt) => txt ? Object.entries({
  r: 'red', g: 'green', b: 'blue', y: 'yellow', o: 'orange', p: 'purple', w: 'white', s: 'gray'
}).reduce((s, [k, c]) => s.replace(new RegExp(`~${k}~(.*?)(?=~|$)`, 'g'), `<span style="color:${c}">$1</span>`), txt)
  .replace(/\\n|n\//g, '<br />') : '';

const styles = {
  success: { icon: 'fas fa-check-circle', color: '#24DB3A' },
  error: { icon: 'fas fa-times-circle', color: '#F32C2C' },
  kill: { icon: 'fa-solid fa-skull', color: '#F32C2C' },
  teparki: { icon: 'fa-solid fa-swords', color: '#FAFAFA' },
  strefy: { icon: 'fa-solid fa-flag-swallowtail', color: '#FAFAFA' },
  bug: { icon: 'fa-solid fa-bug', color: '#F32C2C' },
  bank: { icon: 'fa-solid fa-message-dollar', color: '#FAFAFA' },
  info: { icon: 'fa-solid fa-siren-on', color: '#FAFAFA' }
};

export default function Notify() {
  const [notifications, setNotifications] = useState([]);
  const [restart, setRestart] = useState(null);

  const remove = (id) => {
    setNotifications((prev) => prev.filter((n) => n.id !== id));
  };

  const exit = (id) => {
    setNotifications((prev) =>
      prev.map((n) => (n.id === id ? { ...n, exiting: true } : n))
    );

    const timeoutId = setTimeout(() => {
      remove(id);
    }, 500);

    return timeoutId;
  };

  useEffect(() => {
    const handle = ({ data: d }) => {
      if (d.type === 'notify') {
        const id = Date.now() + Math.random();
        const newNotification = {
          id,
          title: d.title,
          description: d.description,
          variant: d.variant || 'info',
          exiting: false
        };

        setNotifications((prev) => [...prev, newNotification]);

        const timeoutId = setTimeout(() => {
          exit(id);
        }, 3500);

        newNotification.timeoutId = timeoutId;
      }

      if (d.type === 'restart') {
        setRestart(d.message);
        setTimeout(() => setRestart(null), 6000);
      }
    };

    window.addEventListener('message', handle);
    return () => {
      window.removeEventListener('message', handle);
      setNotifications((prev) => {
        prev.forEach((n) => {
          if (n.timeoutId) clearTimeout(n.timeoutId);
        });
        return [];
      });
    };
  }, []);

  return (
    <>
      {restart && (
        <div className="restart-banner">
          <div className="restart-banner-text" style={{ marginRight: '1vh', fontWeight: 'bold' }}>UWAGA!</div>
          <div style={{ fontWeight: 'medium' }}>{restart}</div>
        </div>
      )}
      <div className="notify-container">
        {notifications.map(n => {
          const s = styles[n.variant] || styles.info;
          return (
            <div key={n.id} className={`notification ${n.variant} ${n.exiting ? 'slide-out' : 'slide-in'}`}
              style={{ borderColor: s.color }} onClick={() => exit(n.id)}>
              <i className={`icon ${s.icon}`} style={{ color: s.color }}></i>
              <div className="text">
                <div className="title">{n.title}</div>
                <div className="description" dangerouslySetInnerHTML={{ __html: colorText(n.description) }} />
              </div>
              <div className="notify-progress-bar">
                <div className="notify-progress-bar-fill" style={{ backgroundColor: s.color }}></div>
              </div>
            </div>
          );
        })}
      </div>
    </>
  );
}