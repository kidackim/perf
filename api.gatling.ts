const fs = require("fs").promises;
const path = require("path");
const dotenv = require("dotenv");
const fetch = require("node-fetch");

dotenv.config(); // Wczytaj zmienne środowiskowe

// Ścieżki do plików
const SCENARIO_FILE_PATH = path.resolve(__dirname, "../../resources/config/scenario.json");
const ENV_FILE_PATH = path.resolve(__dirname, "../../../.env");

// Pobieranie danych logowania
const getAuthData = async () => {
    try {
        console.log("📂 Odczyt pliku scenario.json:", SCENARIO_FILE_PATH);
        const rawData = await fs.readFile(SCENARIO_FILE_PATH, "utf-8");
        return JSON.parse(rawData);
    } catch (error) {
        console.error("❌ Błąd odczytu scenario.json:", error);
        return null;
    }
};

// Pobieranie tokena
const fetchToken = async (baseUrl: string, username: string, password: string) => {
    try {
        console.log(`🔄 Pobieranie tokena z: ${baseUrl}/auth`);
        const response = await fetch(`${baseUrl}/auth`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username, password }),
        });

        if (!response.ok) throw new Error(`Błąd pobierania tokena: ${response.statusText}`);
        const data = await response.json();
        console.log("✅ Token pobrany:", data.access_token);
        return data.access_token;
    } catch (error) {
        console.error("❌ Błąd pobierania tokena:", error);
        return null;
    }
};

// Zapisywanie tokena do `.env`
const saveTokenToEnv = async (token: string) => {
    try {
        const envContent = `TOKEN="${token}"\n`;
        console.log("📝 Zapis do pliku .env:", envContent);
        await fs.writeFile(ENV_FILE_PATH, envContent, "utf-8");
        console.log(`✅ Token zapisany do ${ENV_FILE_PATH}`);
    } catch (error) {
        console.error("❌ Błąd zapisu do .env:", error);
    }
};

// Główna funkcja wykonawcza
const fetchAndSaveToken = async () => {
    console.log("🚀 Uruchamianie `auth.ts`...");
    const authData = await getAuthData();
    if (!authData) return;

    const { baseUrl, username, password } = authData;
    const token = await fetchToken(baseUrl, username, password);
    if (!token) return;

    await saveTokenToEnv(token);
};

// Uruchamianie tylko, jeśli plik jest uruchamiany bezpośrednio
if (require.main === module) {
    fetchAndSaveToken();
}

// Eksport funkcji (dla innych plików)
module.exports = { fetchAndSaveToken };
