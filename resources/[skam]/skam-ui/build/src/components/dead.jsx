import React, { useState, useEffect, useRef } from 'react';

export default function DeathScreen() {
    const [display, setDisplay] = useState(false);
    const [killer, setKiller] = useState("Nieznany");
    const [weapon, setWeapon] = useState("Nieznana broń");
    const [distance, setDistance] = useState(0);
    const [timer, setTimer] = useState(10);
    const [initialTimer, setInitialTimer] = useState(10);
    const timerRef = useRef(null);

    useEffect(() => {
        const handleMessage = (event) => {
            if (event.data?.type === "nui:deathscreen:show") {
                setKiller(event.data.killer || "Nieznany");
                setWeapon(event.data.weapon || "Nieznana broń");
                setDistance(event.data.distance || 0);
                setTimer(event.data.timer || 10);
                setInitialTimer(event.data.timer || 10);
                setDisplay(true);
            }
            if (event.data?.type === "nui:deathscreen:hide") {
                setDisplay(false);
                if (timerRef.current) {
                    clearInterval(timerRef.current);
                    timerRef.current = null;
                }
            }
        };
        window.addEventListener("message", handleMessage);
        return () => window.removeEventListener("message", handleMessage);
    }, []);

    useEffect(() => {
        if (!display) {
            if (timerRef.current) {
                clearInterval(timerRef.current);
                timerRef.current = null;
            }
            return;
        }

        if (timerRef.current) {
            clearInterval(timerRef.current);
            timerRef.current = null;
        }

        timerRef.current = setInterval(() => {
            setTimer(prev => {
                if (prev <= 1) {
                    clearInterval(timerRef.current);
                    timerRef.current = null;
                    fetch(`https://${GetParentResourceName()}/endbro`, {
                        method: "POST",
                        headers: { "Content-Type": "application/json" },
                        body: JSON.stringify({})
                    }).catch(() => {});
                    return 0;
                }
                return prev - 1;
            });
        }, 1000);

        return () => {
            if (timerRef.current) {
                clearInterval(timerRef.current);
                timerRef.current = null;
            }
        };
    }, [display, initialTimer]);

    useEffect(() => {
        const handleKeyDown = (e) => {
            if ((e.key === "e" || e.key === "E") && display && timer === 0) {
                handleRespawn();
            }
        };
        window.addEventListener("keydown", handleKeyDown);
        return () => window.removeEventListener("keydown", handleKeyDown);
    }, [display, timer]);

    const handleRespawn = () => {
        setDisplay(false);
        setTimer(initialTimer);
        fetch(`https://${GetParentResourceName()}/endbro`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({})
        }).catch(() => {});
    };

    if (!display) return null;

    return (
        <div className="bg-black/30 fixed inset-0 flex items-end justify-center z-50 pb-16">
            <div className="bg-black/90 text-white rounded-lg shadow-lg px-5 py-3 flex flex-col md:flex-row justify-between items-start w-[40vh] border border-white/10">
                <div className="space-y-1">
                    <p className="text-[1.2vh] tracking-wide uppercase font-bold">Nie żyjesz</p>
                    <p className="text-[2.5vh] font-bold leading-tight">{`00:${timer.toString().padStart(2, '0')}`}</p>
                    <p className="text-[1.2vh] font-semibold tracking-wide mt-1">
                        {timer > 0
                            ? <>Odrodzisz się za <span className="font-bold text-gray-400">{timer}s</span></>
                            : <>Naciśnij <span className="font-bold text-gray-400">E</span>, aby się odrodzić</>
                        }
                    </p>
                </div>
                <div className="text-right text-[1.2vh] font-medium text-white/80 space-y-1 mt-1">
                    <p>Zabito przez: <span className="italic font-semibold text-gray-400">{killer}</span></p>
                    <p>Broń: <span className="italic font-semibold text-gray-400">{weapon}</span></p>
                    <p>Dystans: <span className="italic font-semibold text-gray-400">{distance}m</span></p>
                </div>
            </div>
        </div>
    );
}
