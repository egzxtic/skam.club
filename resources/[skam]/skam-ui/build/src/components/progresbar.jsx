import { useEffect, useState, useRef } from "react";

export default function ProgressBarManager() {
  const [progressBars, setProgressBars] = useState([]);

  useEffect(() => {
    const handleMessage = (event) => {
      const data = event.data;

      if (data.type === "start:progress") {
        const id = `${Date.now()}-${Math.random()}`;
        setProgressBars((prev) => [
          ...prev,
          {
            id,
            title: data.title || "Progress...",
            duration: data.duration || 5000,
            startTime: performance.now(),
            canceled: false,
          },
        ]);
      }

      if (data.type === "stop:progress") {
        setProgressBars((prev) =>
          prev.map((bar) => ({
            ...bar,
            canceled: true,
          }))
        );
      }
    };

    window.addEventListener("message", handleMessage);
    return () => window.removeEventListener("message", handleMessage);
  }, []);

  return (
    <div className="progress-bar-container">
      {progressBars.map((bar, index) => (
        <SingleProgressBar
          key={bar.id}
          index={index}
          total={progressBars.length}
          {...bar}
          onFinish={() =>
            setProgressBars((prev) => prev.filter((b) => b.id !== bar.id))
          }
        />
      ))}
    </div>
  );
}

function SingleProgressBar({
  title,
  duration,
  startTime,
  onFinish,
  index,
  canceled,
}) {
  const [progress, setProgress] = useState(0);
  const [timeLeft, setTimeLeft] = useState((duration / 1000).toFixed(2));
  const [visible, setVisible] = useState(true);
  const [completed, setCompleted] = useState(false);
  const animationRef = useRef(null);
  const isCanceledRef = useRef(canceled);

  useEffect(() => {
    if (completed && !canceled) {
      fetch(`https://${GetParentResourceName()}/progressbarFinished`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ success: true, title }),
      });
    }
  }, [completed, canceled, title]);

  useEffect(() => {
    if (canceled) {
      fetch(`https://${GetParentResourceName()}/progressbarFinished`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ success: false, title }),
      });
    }
  }, [canceled, title]);

  const animate = (timestamp) => {
    if (isCanceledRef.current) {
      return;
    }

    const elapsed = timestamp - startTime;
    const percent = Math.min((elapsed / duration) * 100, 100);
    setProgress(percent);
    setTimeLeft(Math.max((duration - elapsed) / 1000, 0).toFixed(2));

    if (percent < 100) {
      animationRef.current = requestAnimationFrame(animate);
    } else {
      setCompleted(true);
      setTimeout(() => {
        setVisible(false);
        setTimeout(onFinish, 400);
      }, 500);
    }
  };

  useEffect(() => {
    animationRef.current = requestAnimationFrame(animate);
    return () => {
      if (animationRef.current) {
        cancelAnimationFrame(animationRef.current);
      }
    };
  }, []);

  useEffect(() => {
    if (canceled) {
      isCanceledRef.current = true;

      if (animationRef.current) {
        cancelAnimationFrame(animationRef.current);
        animationRef.current = null;
      }

      setTimeout(() => {
        setVisible(false);
        setTimeout(onFinish, 400);
      }, 1000);
    }
  }, [canceled, onFinish]);

  const offset = (index % 2 === 0 ? 1 : -1) * Math.floor(index / 2) * 24;
  const directionClass = visible ? "fade-in-up" : "fade-out-down";

  const fillClass = canceled
    ? "progress-bar-fill-canceled"
    : completed
    ? "progress-bar-fill-completed"
    : "progress-bar-fill";

  const displayTitle = canceled ? "Anulowane" : title;

  return (
    <div
      className={`progress-bar ${directionClass}`}
      style={{
        transform: `translateX(${offset}vh) translateY(0)`,
      }}
    >
      <div className="progress-bar-header">
        <span>{displayTitle}</span>
        {!canceled && <span className="timer">{timeLeft}s</span>}
      </div>
      <div className="progress-bar-fill-container">
        <div
          className={fillClass}
          style={{ transform: `scaleX(${progress / 100})` }}
        ></div>
      </div>
    </div>
  );
}