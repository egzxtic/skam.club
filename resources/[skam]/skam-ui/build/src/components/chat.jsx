import { useEffect, useMemo, useRef, useState } from "react";
import { clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs) {
    return twMerge(clsx(inputs));
}

export function getApiEndpoint() {
    return `https://${GetParentResourceName()}`;
}

export const ChatMessage = ({
    badge,
    type,
    title,
    id,
    subtitle,
    content,
}) => {
    return (
        <div className="w-full bg-custom-black/80 rounded-md p-2 flex flex-col gap-1 animate-message">
            <div className="w-full flex items-center gap-2 justify-between">
                <div className="flex items-center gap-1 font-medium text-xs">
                    {badge && (
                        <div
                            className="px-1 py-[1px] rounded-sm font-bold break-keep text-xs uppercase text-white"
                            style={{
                                backgroundColor: badge.color
                            }}
                        >
                         {(badge.label.length > 12 ? badge.label.substring(0, 12) + "..." : badge.label)}
                        </div>
                    )}
                    {subtitle && (
                        <p className="text-neutral-400">
                            [{subtitle.length > 4 ? subtitle.substring(0, 4) : subtitle}]
                        </p>
                    )}
                    {title && (
                        <p className="text-white">
                            {(title.length > 17 ? title.substring(0, 17) + "..." : title)}
                        </p>
                    )}
                    {id && (
                        <p className="text-neutral-400">
                            ({id})
                        </p>
                    )}
                </div>
                {type && (
                    <p className="text-xs font-medium text-white/50 mr-1">
                        {type}
                    </p>
                )}
            </div>
            <p className="text-xs font-medium text-neutral-400 break-all">
                {content}
            </p>
        </div>
    )
}

export const Suggestion = ({
    command,
    onClick
}) => {
    return (
        <button
            onClick={onClick}
            className="text-xs text-neutral-400 font-medium bg-custom-black/80 hover:bg-custom-black/90 transition px-2 py-1 rounded-md animate-suggestions"
        >
            /{command}
        </button>
    )
}

export const Chat = () => {
    const [isTyping, setIsTyping] = useState(false);

    const [messages, setMessages] = useState([]);
    const [suggestions, setSuggestions] = useState([]);

    const [historyIndex, setHistoryIndex] = useState(-1);
    const [history, setHistory] = useState([]);

    const [opacity, setOpacity] = useState(0.0);

    const messagesEndRef = useRef(null);

    const inputRef = useRef(null);
    const timeoutIds = useRef([]);

    useEffect(() => {
        if (isTyping) {
            inputRef.current?.focus();
        }
    }, [isTyping]);

    useEffect(() => {
        const onMessage = ({ data }) => {
            if (data.eventName === "nui:chat:updateSuggestions" && data.suggestions) {
                setSuggestions(data.suggestions);
            }

            if (data.eventName === "nui:chat:newMessage") {
                setMessages((prev) => {
                    if (data.newMessage) {
                        return [...prev, data.newMessage];
                    } else {
                        return [...prev];
                    }
                });
                if (messagesEndRef.current) {
                    messagesEndRef.current.scrollTop = messagesEndRef.current.scrollHeight;
                }
                setOpacity(1);
                timeoutIds.current.forEach((id) => clearTimeout(id));
                timeoutIds.current = [];
                timeoutIds.current.push(setTimeout(() => setOpacity(0), 7 * 1000));
            }

            if (data.eventName === "nui:chat:focus") {
                setIsTyping(true);
                setOpacity(1);
                timeoutIds.current.forEach((id) => clearTimeout(id));
                timeoutIds.current = [];
            }

            if (data.eventName === "nui:chat:defocus") {
                setIsTyping(false);
                timeoutIds.current.push(setTimeout(() => setOpacity(0), 7 * 1000));
            }
        }

        window.addEventListener("message", onMessage);

        return () => window.removeEventListener("message", onMessage);
    }, []);

    useEffect(() => {
        if (messagesEndRef.current) {
            messagesEndRef.current.scrollTop = messagesEndRef.current.scrollHeight;
        }
    }, [messages]);

    useEffect(() => {
        const onKeyDown = (e) => {
            if (!isTyping) return;
            if (e.key === 'Escape') {
                fetch(`${getApiEndpoint()}/chat/off`, { method: 'POST' });
                setIsTyping(false);
            }
            if (isTyping) {
                if (e.key === 'ArrowUp') {
                    setHistoryIndex((prevIndex) => {
                        const newIndex = Math.min(prevIndex + 1, history.length - 1);
                        const newValue = history[newIndex] || '';
                        setValue(newValue);
                        setTimeout(() => {
                            if (inputRef.current) {
                                inputRef.current.setSelectionRange(newValue.length, newValue.length);
                            }
                        }, 0);
                        return newIndex;
                    });
                } else if (e.key === 'ArrowDown') {
                    setHistoryIndex((prevIndex) => {
                        const newIndex = Math.max(prevIndex - 1, -1);
                        const newValue = history[newIndex] || '';
                        setValue(newValue);
                        setTimeout(() => {
                            if (inputRef.current) {
                                inputRef.current.setSelectionRange(newValue.length, newValue.length);
                            }
                        }, 0);
                        return newIndex;
                    });
                } else if (e.key === 'PageUp' && messagesEndRef.current) {
                    messagesEndRef.current.scrollTop -= 100;
                } else if (e.key === 'PageDown' && messagesEndRef.current) {
                    messagesEndRef.current.scrollTop += 100;
                    if (historyIndex === 10000000) return;
                }
            }
        };

        window.addEventListener("keydown", onKeyDown);

        return () => {
            window.removeEventListener("keydown", onKeyDown);
        }
    }, [isTyping, history]);

    const [value, setValue] = useState("");

    const onSend = (e) => {
        e.preventDefault();

        fetch(`${getApiEndpoint()}/chat/send`, {
            method: "POST",
            body: JSON.stringify({
                message: value
            })
        })
        setHistory((prev) => [value, ...prev]);
        setHistoryIndex(-1);
        setValue("");
    }

    const filteredSuggetions = useMemo(() => {
        if (value === "") return [];

        return suggestions.filter((suggestion) => `/${suggestion}`.toLowerCase().startsWith(value.toLowerCase())).slice(0, 20);
    }, [value, suggestions]);

    return (
        <div className={cn("w-[400px] flex flex-col gap-2 fixed left-0 top-0 m-3 transition")}>
            <div className="w-full flex flex-col gap-1 max-h-[262.5px] overflow-y-auto no-scroll transition" ref={messagesEndRef} style={{ opacity: opacity }}>
                {messages.map((message, key) => (
                    <ChatMessage
                        key={key}
                        {...message}
                    />
                ))}
            </div>
            {(isTyping) && (
                <div className="absolute top-[265px] w-full gap-2 transition">
                    <form onSubmit={onSend}>
                        <input
                            ref={inputRef}
                            value={value}
                            onChange={(e) => setValue(e.target.value)}
                            className="w-full p-2 rounded-md bg-custom-black/80 font-medium placeholder:text-neutral-400 text-white text-xs outline-none y-0 transition"
                            placeholder="Czat..."
                        />
                    </form>
                    {filteredSuggetions.length > 0 && (
                        <div className="w-full flex gap-0.5 flex-wrap mt-[2.5px] transition">
                            {filteredSuggetions.map((suggestion, key) => (
                                <Suggestion
                                    key={key}
                                    command={suggestion}
                                    onClick={() => setValue(`/${suggestion}`)}
                                />
                            ))}
                        </div>
                    )}
                </div>
            )}
        </div>
    )
}