import { useEffect, useState } from "react";

export default function Hud() {
    const [zycie, setZycie] = useState(100);
    const [armor, setArmor] = useState(100);
    const [voice, setVoice] = useState(50);
    const [active, setActive] = useState(false);

    const [visible, setVisible] = useState(true);
    const [hudColor, setHudColor] = useState("#fff");
    const [hudStyle, setHudStyle] = useState("Klasyczny");
    const [hudPosition, setHudPosition] = useState("Klasyczny");

    useEffect(() => {
        const cos = (event) => {
            if (event.data.type === "loadhud") {
                setZycie(Math.max(0, Number(event.data.zycie) || 0));
                setArmor(Math.max(0, Number(event.data.armor) || 0));
                const voiceValue = Math.max(5, Math.min(Number(event.data.voice) || 0, 100));
                setVoice(voiceValue);
            }

            if (event.data.type === "hud:active") {
                setActive(Boolean(event.data.active));
            }
        };

        window.addEventListener("message", cos);
        return () => window.removeEventListener("message", cos);
    }, []);

    useEffect(() => {
        const handleSettingsUpdate = (event) => {
            const { type, ...data } = event.detail;

            if (type === 'hud') {
                if (data.visible !== undefined) setVisible(data.visible);
                if (data.color) setHudColor(data.color);
                if (data.style) setHudStyle(data.style);
                if (data.position) setHudPosition(data.position);
            }
        };

        window.addEventListener('settings:update', handleSettingsUpdate);
        return () => {
            window.removeEventListener('settings:update', handleSettingsUpdate);
        };
    }, []);

    useEffect(() => {
        if (hudStyle === 'BASIC') {
            const resourceName = window.GetResourceName ? window.GetResourceName() : 'skam-ui';
            fetch(`https://${resourceName}/hud:basic`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({})
            });
        } else if (hudStyle === 'Klasyczny') {
            fetch(`https://${window.GetResourceName ? window.GetResourceName() : 'skam-ui'}/hud:klasyczny`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({})
            });
        }

    }, [hudStyle]);

    const getPositionClass = () => {
        switch (hudPosition) {
            case 'Góra': return 'hud-top';
            case 'Lewy': return 'hud-left';
            case 'Prawy': return 'hud-right';
            default: return '';
        }
    };

    const getStyleClass = () => {
        switch (hudStyle) {
            case 'BASIC': return 'hud-basic';
            default: return '';
        }
    };

    if (!visible) return null;

    return (
        <div className={`hud ${getPositionClass()} ${getStyleClass()}`}>
            <div className="armor x">
                <i
                    className="fa-solid fa-shield-halved"
                    style={{
                        backgroundImage: `linear-gradient(to top, ${hudColor} ${armor}%, #504f4f ${armor}%)`,
                        WebkitBackgroundClip: "text",
                        backgroundClip: "text",
                        WebkitTextFillColor: "transparent",
                    }}
                ></i>
            </div>
            <div className="zycie x">
                <i
                    className="fa-solid fa-heart-pulse"
                    style={{
                        backgroundImage: `linear-gradient(to top, ${hudColor} ${zycie}%, #504f4f ${zycie}%)`,
                        WebkitBackgroundClip: "text",
                        backgroundClip: "text",
                        WebkitTextFillColor: "transparent",
                    }}
                ></i>
            </div>
            <div className="voice x">
                <i
                    className="fa-solid fa-microphone"
                    style={{
                        backgroundImage: `linear-gradient(to top, ${active ? "var(--color-active,rgb(119, 0, 255))" : hudColor} ${voice}%, #504f4f ${voice}%)`,
                        WebkitBackgroundClip: "text",
                        backgroundClip: "text",
                        WebkitTextFillColor: "transparent",
                        transition: "all 0.2s ease-in-out",
                    }}
                ></i>
            </div>
        </div>
    );
}