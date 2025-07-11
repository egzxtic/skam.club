import React, { useEffect, useState } from 'react';

const Dzordzo = ({ image, index }) => {
    return (
        <div className="bind-card">
            {image ? (
                <img src={image} alt="" />
            ) : (
                <p id="binds" style={{ 
                    display: 'flex', 
                    justifyContent: 'center', 
                    alignItems: 'center', 
                    height: '100%', 
                    margin: 0 
                }}>
                    {index + 1}
                </p>
            )}
        </div>
    );
};

export default function Binds() {
    const [binds, updateBinds] = useState([
        { image: '' },
        { image: '' },
        { image: '' },
        { image: '' },
        { image: '' },
    ]);
    const [show, setShow] = useState(true);

    useEffect(() => {
        const handleMouseDown = (event) => {
            if (event.key === 'nui:binds:cwel') {
                event.preventDefault();
                setShow((prev) => !prev);
            }
        };

        const handleWheel = () => {
            setShow(false);
        };

        const handleKeyPress = (event) => {
            if (event.key === 'nui:binds:cwel') {
                event.preventDefault();
                setShow((prev) => !prev);
            }
        };

        const handleMessage = (event) => {
            if (event.data.eventName === 'nui:binds:update') {
                updateBinds(event.data.data);
                setShow(true);
            } else if (event.data.eventName === 'nui:binds:toggle') {
                setShow((prev) => !prev);
            } else if (event.data.eventName === 'nui:binds:driving') {
                setShow(!event.data.isDriving);
            }
        };

        window.addEventListener('mousedown', handleMouseDown);
        window.addEventListener('wheel', handleWheel);
        window.addEventListener('keydown', handleKeyPress);
        window.addEventListener('message', handleMessage);

        return () => {
            window.removeEventListener('mousedown', handleMouseDown);
            window.removeEventListener('wheel', handleWheel);
            window.removeEventListener('keydown', handleKeyPress);
            window.removeEventListener('message', handleMessage);
        };
    }, []);

    return (
        <div
            className={`binds-container ${
                show ? 'visible' : 'hidden'
            }`}
        >
            {binds.map((bind, index) => (
                <Dzordzo key={index} image={bind.image} index={index} />
            ))}
        </div>
    );
}