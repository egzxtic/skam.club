import { useEffect, useState } from "react";

export default function Zetka() {
    const [visible, setVisible] = useState(false);
    const [anim, setAnim] = useState("show");
    const [data, setData] = useState({
        police: "99",
        admins: "99", 
        players: "99",
        job: "Unemployed - Bezrobotny"
    });

    useEffect(() => {
        const handle = ({ data: d }) => {
            if (d.type === "nui:scoreboard:show") {
                if (d.showZetka) {
                    setVisible(true);
                    setAnim("show");
                } else {
                    setAnim("hide");
                    setTimeout(() => setVisible(false), 320);
                }
            }
            if (d.type === "nui:scoreboard:update") {
                setData(prev => ({
                    ...prev,
                    admins: typeof d.admins !== "undefined" ? d.admins : prev.admins,
                    police: typeof d.police !== "undefined" ? d.police : prev.police,
                    players: typeof d.players !== "undefined" ? d.players : prev.players,
                    job: d.job || prev.job
                }));
            }
        };

        window.addEventListener("message", handle);
        return () => window.removeEventListener("message", handle);
    }, []);

    if (!visible) return null;

    return (
        <div className={`zetka-v2 zetka-anim-${anim}`}>
            <div className="zetka-header">
                <img src="https://i.fmfile.com/PsXrY56boeeCIZWpbOkiQ/skam.png" className="zetka-logo"/>
                <div className="zetka-title">
                    <div className="zetka-skam">SKAM<span className="zetka-dot">.club</span></div>
                    <div className="zetka-dc">discord.gg/skam</div>
                </div>
                <div className="zetka-count">
                    <div className="zetka-count-label">LICZBA GRACZY</div>
                    <div className="zetka-count-num">{data.players}</div>
                </div>
            </div>
            <div className="zetka-section">
                <div className="zetka-section-title">FRAKCJE</div>
                <div className="zetka-frakcje-row">
                    <div>Administracja</div>
                    <div>{data.admins}</div>
                </div>
                <div className="zetka-frakcje-row">
                    <div>SASP</div>
                    <div>{data.police}</div>
                </div>
            </div>
            <div className="zetka-section">
                <div className="zetka-section-title">ZATRUDNIENIE</div>
                <div className="zetka-frakcje-row">
                    <div>PRACA</div>
                    <div className="zetka-praca">{data.job}</div>
                </div>
            </div>
        </div>
    );
}