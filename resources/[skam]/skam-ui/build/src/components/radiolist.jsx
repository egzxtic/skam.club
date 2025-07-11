import { useEffect, useState } from "react";


/**
 * @typedef {Object} RadioUserProps
 * @property {string} name
 * @property {string} [id]
 * @property {boolean} [isTalking]
 * @property {boolean} [isDead]
 */

export const RadioUser = ({
    name,
    id,
    isTalking,
    isDead
}) => {
    return (
        <div className="radio-user">
            <div className={`user-info ${isTalking ? 'talking' : ''} ${isDead ? 'dead' : ''}`}>
                <span className="icon-wrapper">
                    {isDead ? (
                        <i  className="fa-solid fa-skull dead-icon"></i>
                    ): isTalking ? (
                        <i className="fa-solid fa-microphone"></i>
                    ): (
                        <i className="fa-solid fa-headphones"></i>
                    )}
                </span>
                {name.length > 15 ? name.substring(0, 15) + "..." : name}
            </div>
            {id && (
                <div className={`user-id ${isTalking ? 'talking' : ''} ${isDead ? 'dead' : ''}`}>
                    {"[" + id.toString().padStart(4, '0') + "]"}
                </div>
            )}
        </div>
    )
}

/**
 * @typedef {Object} RadioListData
 * @property {string} name
 * @property {RadioUserProps[]} members
 */

export default function RadioList()  {
    const [show, setShow] = useState(true);
    const [data, setData] = useState(null);

    useEffect(() => {
        /**
         * @typedef {Object} MessageData
         * @property {string} eventName - "nui:radio:update"
         * @property {boolean} [show]
         * @property {RadioListData} [data]
         */

        const onMessage = ({ data }) => {
            if (data.eventName === "nui:radio:update") {
                if (data.show !== undefined) {
                    setShow(data.show);
                }

                if (data.data) {
                    setData(data.data);
                }
            }
        }

        window.addEventListener("message", onMessage);

        return () => window.removeEventListener("message", onMessage);
    }, []);

    return (
        <>
            {data && (
                <div className={`radio-container ${!show ? 'radio-hidden' : ''}`}>
                    <header className="radio-header">
                        <div className="radio-info">
                            <i className="fa-solid fa-walkie-talkie icon-xs text-neutral"></i>
                            <p className="radio-text text-neutral">Radio: <strong className="radio-text text-white">{data.name}</strong></p>
                        </div>
                        <div className="radio-info">
                            <i className="fa-solid fa-users icon-xs text-neutral"></i>
                            <strong className="radio-text text-white">{data.members.length}</strong>
                        </div>
                    </header>
                    <div className="radio-members">
                        {data.members.sort((a, b) => {
                            if (a.isTalking && !b.isTalking) {
                                return -1;
                            }
                            if (!a.isTalking && b.isTalking) {
                                return 1;
                            }
                            return 0;
                        }).map((member, key) => (
                            <RadioUser
                                key={key}
                                {...member}
                            />
                        ))}
                    </div>
                    {data.members.length > 10 && (
                        <p className="radio-text text-neutral">
                            {data.members.length - 10} Więcej
                        </p>
                    )}
                </div>
            )}
        </>
    )
}