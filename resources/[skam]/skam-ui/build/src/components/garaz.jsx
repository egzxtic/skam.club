import React, { useState, useEffect, useCallback } from 'react';

export default function Garaz() {
  const [cars, setCars] = useState([]);
  const [activeSection, setActiveSection] = useState("garage");
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedCar, setSelectedCar] = useState(null);
  const [visible, setVisible] = useState(false);
  const [SubCoOwner, setSubCoOwner] = useState(1);

  useEffect(() => {
    const favoritesFromStorage = localStorage.getItem('egzotoskamerbezkapy');
    if (favoritesFromStorage) {
      try {
        const favPlates = JSON.parse(favoritesFromStorage);
        setCars(prev =>
          prev.map(car =>
            favPlates.includes(car.plate)
              ? { ...car, favorite: true }
              : { ...car, favorite: false }
          )
        );
      } catch (e) {}
    }
  }, []);

  useEffect(() => {
    if (!cars.length) return;
    const favPlates = cars.filter(car => car.favorite).map(car => car.plate);
    localStorage.setItem('egzotoskamerbezkapy', JSON.stringify(favPlates));
  }, [cars]);

  const getVehiclesData = useCallback(() => {
    fetch(`https://${GetParentResourceName()}/getVehiclesData`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify({ section: "all" })
    })
      .then(res => res.json())
      .then(data => {
        const favoritesFromStorage = localStorage.getItem('egzotoskamerbezkapy');
        let favPlates = [];
        if (favoritesFromStorage) {
          try {
            favPlates = JSON.parse(favoritesFromStorage);
          } catch (e) {}
        }
        const mapped = Array.isArray(data)
          ? data.map(car =>
              favPlates.includes(car.plate)
                ? { ...car, favorite: true }
                : { ...car, favorite: false }
            )
          : [];
        setCars(mapped);
      })
      .catch(() => setCars([]));
  }, [activeSection]);

  useEffect(() => {
    const onNuiMessage = (e) => {
      if (e.data?.action === "openGarage") {
        setVisible(true);
        getVehiclesData();
        setSelectedCar(null);
      }
      if (e.data?.action === "closeGarage") {
        setVisible(false);
        setSelectedCar(null);
      }
      if (e.data?.action === "refreshVehicles") {
        getVehiclesData();
        setSelectedCar(null);
      }
    };
    window.addEventListener("message", onNuiMessage);
    return () => window.removeEventListener("message", onNuiMessage);
  }, [getVehiclesData]);

  useEffect(() => {
    const handleEscape = (e) => {
      if (e.key === "Escape" && visible) {
        fetch(`https://${GetParentResourceName()}/nuiclose`, { method: "POST" });
        setVisible(false);
        setSelectedCar(null);
      }
    };
    window.addEventListener("keydown", handleEscape);
    return () => window.removeEventListener("keydown", handleEscape);
  }, [visible]);

  const filteredCars = cars.filter(car => {
    if (!car) return false;
    const matchesType = (car.type || "").trim().toLowerCase() === activeSection.toLowerCase();
    const matchesSearch = searchQuery === "" ||
      (car.name && car.name.toLowerCase().includes(searchQuery.toLowerCase())) ||
      (car.plate && car.plate.toLowerCase().includes(searchQuery.toLowerCase())) ||
      (car.model && car.model.toLowerCase().includes(searchQuery.toLowerCase()));
    return matchesType && matchesSearch;
  });

  const favoriteCars = filteredCars.filter(car => car && car.favorite);
  const otherCars = filteredCars.filter(car => car && !car.favorite);

  const toggleFavorite = (plate) => {
    fetch(`https://${GetParentResourceName()}/toggleFavorite`, {
      method: 'POST',
      body: JSON.stringify({ plate })
    });
    setCars(prevCars =>
      prevCars.map(car =>
        car.plate === plate ? { ...car, favorite: !car.favorite } : car
      )
    );
    if (selectedCar && selectedCar.plate === plate) {
      setSelectedCar(prev => ({ ...prev, favorite: !prev.favorite }));
    }
  };

  const handleVehicleAction = (car) => {
    if (activeSection === "towing") {
      fetch(`https://${GetParentResourceName()}/unchlowVehicle`, {
        method: 'POST',
        body: JSON.stringify({ plate: car.plate })
      });
    } else {
      fetch(`https://${GetParentResourceName()}/spawnVehicle`, {
        method: 'POST',
        body: JSON.stringify({ plate: car.plate })
      });
    }
  };

  const handleUnchlowAll = () => {
    fetch(`https://${GetParentResourceName()}/unchlowAllVehicles`, {
      method: 'POST'
    });
  };

  const handleCarClick = (car) => setSelectedCar(car === selectedCar ? null : car);

  const truncateName = (name) => (name && name.length > 13 ? name.slice(0, 13) + '...' : name || '');

  if (!visible) return null;

  return (
    <>
      <div className="garaz">
        <div className="header">
          <input
            type="text"
            placeholder="Wyszukaj pojazd..."
            className="search-input"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
          <div className="clickbro">
            <button
              className={`btn ${activeSection === "garage" ? "active" : ""}`}
              onClick={() => { setActiveSection("garage"); setSelectedCar(null); }}
            >
              GARAŻ
            </button>
            <button
              className={`btn ${activeSection === "towing" ? "active" : ""}`}
              onClick={() => { setActiveSection("towing"); setSelectedCar(null); }}
            >
              ODHOLOWNIK
            </button>
            <button
              className={`btn ${activeSection === "organization" ? "active" : ""}`}
              onClick={() => { setActiveSection("organization"); setSelectedCar(null); }}
            >
              ORGANIZACJA
            </button>
          </div>
          <div className="titlebro">
            <i className={
              activeSection === "garage" ? "fa-solid fa-garage" :
                activeSection === "towing" ? "fa-solid fa-truck-pickup" :
                  "fa-solid fa-building"
            }></i>
            {activeSection === "garage" ? "GARAŻ" :
              activeSection === "towing" ? "ODHOLOWNIK" :
                "ORGANIZACJA"}
          </div>
        </div>

        <div className="garage-content">
          <div className="car-section favorites-section">
            <div className="section-title">ULUBIONE</div>
            {favoriteCars.length > 0 ? (
              <div className="car-list">
                {favoriteCars.map(car => car && car.plate && (
                  <div
                    key={car.plate}
                    className={`car-item favorite-car ${selectedCar?.plate === car.plate ? 'selected' : ''}`}
                    onClick={() => handleCarClick(car)}
                  >
                    <div className="car-info">
                      <div className="car-name-action">
                        <span className="car-name"><i className={car.icon || ""}></i> {truncateName(car.name)}</span>
                        <span className="car-action" onClick={(e) => {
                          e.stopPropagation();
                          toggleFavorite(car.plate);
                        }}>
                          Usuń z ulubionych
                        </span>
                      </div>
                    </div>
                    <div className="car-plate-container">
                      {car.plate || "BRAK TABLICY"}
                      <span className="car-plate-indicator"></span>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="a"></div>
            )}
          </div>

          <div className="car-section others-section">
            <div className="section-title">INNE</div>
            {otherCars.length > 0 ? (
              <div className="car-list">
                {otherCars.map(car => car && car.plate && (
                  <div
                    key={car.plate}
                    className={`car-item ${selectedCar?.plate === car.plate ? 'selected' : ''}`}
                    onClick={() => handleCarClick(car)}
                  >
                    <div className="car-info">
                      <div className="car-name-action">
                        <span className="car-name"><i className={(car.icon || "") + " car-icon"}></i> {truncateName(car.name)}</span>
                        <span
                          className="car-action add-favorite"
                          onClick={(e) => {
                            e.stopPropagation();
                            toggleFavorite(car.plate);
                          }}
                        >
                          Dodaj do ulubionych
                        </span>
                      </div>
                    </div>
                    <div className="car-plate-container">
                      {car.plate || "BRAK TABLICY"}
                      <span className="car-plate-indicator"></span>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="empty-list">Brak pojazdów w tej sekcji</div>
            )}
          </div>
        </div>

        <div className={`selected-car-display ${selectedCar ? 'visible' : ''}`}>
          {selectedCar && (
            <div className="selected-car-bottom-bar">
              <div className="car-bar-left">
                <div className="car-bar-main-row">
                  <i className={`${selectedCar.icon || ""} car-bar-icon`}></i>
                  <span className="car-bar-name">{selectedCar.name || "Nieznany pojazd"}</span>
                  <div className="car-bar-plate">{selectedCar.plate || "brak"}</div>
                </div>
                <div
                  className={selectedCar.favorite ? "car-bar-fav gray-button" : "car-bar-fav gold-button"}
                  onClick={() => toggleFavorite(selectedCar.plate)}
                >
                  {selectedCar.favorite ? 'Usuń z ulubionych' : 'Dodaj do ulubionych'}
                </div>
              </div>
              <div className="car-bar-right">
                <div className="car-bar-group">
                  <i className="fa-solid fa-users"></i>
                  <span className="car-bar-group-count">{SubCoOwner}/3</span>
                </div>
                {activeSection === "towing" ? (
                  <>
                    <button className="car-bar-btn" onClick={() => handleVehicleAction(selectedCar)}>ODHOLUJ</button>
                    <button className="car-bar-btn" onClick={handleUnchlowAll}>ODHOLUJ WSZYSTKIE</button>
                  </>
                ) : (
                  <>
                    <button className="car-bar-btn" onClick={() => {
                      fetch(`https://${GetParentResourceName()}/addSubOwner`, {
                        method: 'POST',
                        body: JSON.stringify({ plate: selectedCar.plate })
                      });
                    }}>DODAJ</button>
                    <button className="car-bar-btn" onClick={() => {
                      fetch(`https://${GetParentResourceName()}/delSubOwner`, {
                        method: 'POST',
                        body: JSON.stringify({ plate: selectedCar.plate })
                      });
                    }}>USUŃ</button>
                    <button className="car-bar-btn" onClick={() => handleVehicleAction(selectedCar)}>WYCIĄGNIJ</button>
                  </>
                )}
              </div>
            </div>
          )}
        </div>
      </div>
    </>
  );
}