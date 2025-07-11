import React, { useState, useEffect } from "react";

export default function CarHud() {
    const [jadymy, setjadymy] = useState(false);
    const [predkosc, setPredkosc] = useState(0);
    const [progres, setProgres] = useState(50);
    const [visible, setVisible] = useState(true);
    const [style, setStyle] = useState("BASIC");
    const [hudColor, setHudColor] = useState("#fff");

    useEffect(() => {
        const aleoptixdd = (event) => {
            switch (event.data.type) {
                case 'loadcarhud':
                    setjadymy(true);
                    setPredkosc(0);
                    break;
                case 'stopcarhud':
                    setjadymy(false);
                    break;
                case 'carhud:update':
                    setPredkosc(event.data.predkosc || 0);
                    if (typeof event.data.progres === "number") {
                        setProgres(event.data.progres);
                    }
                    break;
                default:
                    break;
            }
        };

        window.addEventListener("message", aleoptixdd);

        return () => {
            window.removeEventListener("message", aleoptixdd);
        };
    }, []);

    useEffect(() => {
        const handleSettingsUpdate = (event) => {
            const { type, ...data } = event.detail;
            
            if (type === 'carhud') {
                if (data.visible !== undefined) setVisible(data.visible);
                if (data.style) setStyle(data.style);
                if (data.color) setHudColor(data.color);
            }
        };

        window.addEventListener('settings:update', handleSettingsUpdate);
        return () => {
            window.removeEventListener('settings:update', handleSettingsUpdate);
        };
    }, []);

    useEffect(() => {
        window.dispatchEvent(
            new MessageEvent("message", {
                data: {
                    eventName: "nui:binds:drivin",
                    isDriving: jadymy
                }
            })
        );
    }, [jadymy]);

    useEffect(() => {
        const fetchCarHudStyle = async () => {
            try {
                if (style === 'BASIC') {
                    const resourceName = window.GetResourceName ? window.GetResourceName() : 'skam-ui';
                    await fetch(`https://${resourceName}/hud:basic`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({})
                    });
                } else if (style === 'Klasyczny') {
                }
            } catch (error) {
            }
            if (style === 'KLASYCZNY') {
                await fetch(`https://${GetParentResourceName()}/hud:klasyczny`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({})
                });
            }
        };

        fetchCarHudStyle();
    }, [style]);

    if (!jadymy || !visible) return null;

    return (
        <div className={`carhud ${visible ? '' : 'hidden'} ${style}`}>
            <div className="predkosc">
                {predkosc}
                <div className="km">KMH</div>
            </div>
            <div className="progresss">
            <div className="progres">
                <div className="progres-fill" style={{ width: `${progres}%`, backgroundColor: hudColor }}></div>
            </div>
            </div>
        </div>
    );
}