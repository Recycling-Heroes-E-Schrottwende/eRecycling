CREATE TABLE Produkte(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    preis VARCHAR(255) NOT NULL,
    beschreibung VARCHAR(255) NOT NULL,
    bild bytea NOT NULL
)
