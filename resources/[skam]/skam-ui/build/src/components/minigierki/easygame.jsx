import React, { useState, useEffect } from "react";

export default function EasyGame() {
  const [squares, setSquares] = useState(Array.from({ length: 36 }, () => ({
    isPurple: false,
    isRed: false,
    isCorrect: false,
  })));
  const [targetIndices, setTargetIndices] = useState([]);
  const [mistakeCount, setMistakeCount] = useState(0);
  const [timer, setTimer] = useState(null);
  const [gameState, setGameState] = useState({
    started: false,
    over: false,
    won: false,
    uiHidden: false,
    canClick: false,
  });

  const maxMistakes = 3;

  const resetGame = () => {
    setSquares(Array.from({ length: 36 }, () => ({
      isPurple: false,
      isRed: false,
      isCorrect: false,
    })));
    setTargetIndices([]);
    setMistakeCount(0);
    setTimer(null);
    setGameState({
      started: false,
      over: false,
      won: false,
      uiHidden: false,
      canClick: false,
    });
  };

  const startGame = (difficulty = "easy") => {
    resetGame();

    const targetCount = difficulty === "hard" ? 12 : 8;

    const newTargetIndices = Array.from({ length: targetCount }, () =>
      Math.floor(Math.random() * 36)
    );
    setTargetIndices(newTargetIndices);

    setSquares(prev => prev.map((square, index) => ({
      ...square,
      isPurple: newTargetIndices.includes(index),
    })));

    setGameState(prev => ({ ...prev, started: true }));

    setTimeout(() => {
      setSquares(prev => prev.map(square => ({
        ...square,
        isPurple: false,
      })));
      setGameState(prev => ({ ...prev, canClick: true }));
      setTimer(15);
    }, 3000);
  };

  const selectSquare = (index) => {
    if (!gameState.canClick || !gameState.started) return;

    const isTarget = targetIndices.includes(index);

    setSquares(prev => {
      const newSquares = prev.map((square, i) =>
        i === index ? {
          ...square,
          isCorrect: isTarget,
          isRed: !isTarget,
        } : square
      );

      if (isTarget && targetIndices.every(i =>
        i === index ? true : newSquares[i].isCorrect
      )) {
        setTimeout(() => endGame(true), 100);
      }

      return newSquares;
    });

    if (!isTarget) {
      setMistakeCount(prev => {
        const newMistakeCount = prev + 1;
        if (newMistakeCount >= maxMistakes) {
          endGame(false);
        }
        return newMistakeCount;
      });
    }
  };

  const endGame = (() => {
    let hasEnded = false;
    return (won) => {
      if (hasEnded) return;
      hasEnded = true;
  
      setGameState(prev => ({
        ...prev,
        over: true,
        won: won,
      }));
  
      // console.log("endGame wywołane z wynikiem:", won);
  
      setTimeout(() => {
        setGameState(prev => ({ ...prev, uiHidden: true }));
  
        if (window.GetParentResourceName) {
          window.postMessage({ type: "closeGame" });
        }
      }, 3000);
  
      if (window.GetParentResourceName) {
        // console.log("isFiveMEnvironment: true, wysyłam fetch...");
        fetch(`https://${GetParentResourceName()}/endGame`, {
          method: "POST",
          headers: { "Content-Type": "application/json; charset=UTF-8" },
          body: JSON.stringify({ result: won }),
        }).then(() => {
          // console.log("fetch do Lua zakończony!");
        }).catch(err => console.error("Błąd fetch do Lua:", err));
      } else {
        console.log("isFiveMEnvironment: false");
      }
    };
  })();

  useEffect(() => {
    if (gameState.canClick && timer > 0) {
      const interval = setInterval(() => {
        setTimer(prev => prev - 1);
      }, 1000);

      return () => clearInterval(interval);
    } else if (timer === 0 && gameState.canClick && !gameState.over) {
      endGame(false);
    }
  }, [timer, gameState.canClick, gameState.over]);

  useEffect(() => {
    const handleMessage = (event) => {
      const { type, game, difficulty } = event.data || {};

      if (type === "openGame" && game === "easy") {
        startGame(difficulty || "easy");
      } else if (type === "startGame") {
        startGame(difficulty || "easy");
      } else if (type === "resetGame") {
        resetGame();
      }
    };

    window.addEventListener("message", handleMessage);
    return () => window.removeEventListener("message", handleMessage);
  }, []);

  useEffect(() => {
    const handleCloseGame = (event) => {
      if (event.data && event.data.type === "closeGame") {
        setGameState(prev => ({ ...prev, uiHidden: true }));
      }
    };
    window.addEventListener("message", handleCloseGame);
    return () => window.removeEventListener("message", handleCloseGame);
  }, []);

  return (
    <div>
      {gameState.started && !gameState.over && (
        <div className="game-container">
          <input
            className="input-box"
            type="text"
            value={`>_hacking.system | ${timer !== null ? `${timer}s` : "..."}`}
            readOnly
          />
          <div className="grid">
            {squares.map((square, index) => (
              <div
                key={index}
                className={`square ${square.isPurple ? "purple" : ""} ${square.isRed ? "red" : ""} ${square.isCorrect ? "correct" : ""}`}
                onClick={() => selectSquare(index)}
              />
            ))}
          </div>
          <div className="instruction">PPM aby zaznaczyć.</div>
        </div>
      )}
      {gameState.over && !gameState.uiHidden && (
        <div className="end-screen">
          {gameState.won ? (
            <div className="result success">
              <img src="https://r2.fivemanage.com/PsXrY56boeeCIZWpbOkiQ/cwel.svg" />
              <p>access accept.</p>
            </div>
          ) : (
            <div className="result denied">
              <img src="https://r2.fivemanage.com/PsXrY56boeeCIZWpbOkiQ/chuj.svg" />
              <p>access denied.</p>
            </div>
          )}
        </div>
      )}
    </div>
  );
}