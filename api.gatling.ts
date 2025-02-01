import { promises as fs } from "fs";
import path from "path";
import dotenv from "dotenv";

dotenv.config(); // Wczytaj zmienne środowiskowe

// Ścieżki do plików
const SCENARIO_FILE_PATH = path.resolve(__dirname, "../../resources/config/scenario.json");
const ENV_FILE_PATH = path.resolve(__dirname, "../../../.env");

// Definicja interfejsu dla danych logowania
interface AuthCredentials {
    baseUrl: string;
    username: string;
    password: string;
}

// Funkcja asynchroniczna do odczytu danych logowania z `scenario.json`
const getAuthData = async (): Promise<AuthCredentials> => {
    console.log("📂 Odczyt pliku scenario.json:", SCENARIO_FILE_PATH);

    try {
        const rawData = await fs.readFile(SCENARIO_FILE_PATH, "utf-8");
        const jsonData: AuthCredentials = JSON.parse(rawData);

        if (!jsonData.baseUrl || !jsonData.username || !jsonData.password) {
            throw new Error("Brakuje wymaganych pól (`baseUrl`, `username`, `password`) w scenario.json");
        }

        return jsonData;
    } catch (error) {
        console.error("❌ Błąd odczytu scenario.json:", error);
        throw new Error("Nie można wczytać pliku scenario.json");
    }
};

// Funkcja do pobrania tokena z API
const fetchToken = async (baseUrl: string, username: string, password: string): Promise<string> => {
    console.log(`🔄 Pobieranie tokena z: ${baseUrl}/auth`);
    console.log(`👤 Użytkownik: ${username}`);

    try {
        const response = await fetch(`${baseUrl}/auth`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username, password }),
        });

        if (!response.ok) {
            throw new Error(`Błąd pobierania tokena: ${response.statusText}`);
        }

        const data = await response.json();
        console.log("✅ Token pobrany:", data.access_token);

        return data.access_token;
    } catch (error) {
        console.error("❌ Błąd podczas pobierania tokena:", error);
        throw new Error("Nie udało się pobrać tokena");
    }
};

// Funkcja zapisująca token do `.env`
const saveTokenToEnv = async (token: string): Promise<void> => {
    try {
        const envContent = `TOKEN="${token}"\n`;
        console.log("📝 Zapis do pliku .env:", envContent);
        await fs.writeFile(ENV_FILE_PATH, envContent, "utf-8");

        console.log(`✅ Token zapisany do ${ENV_FILE_PATH}`);

        // Dodatkowa walidacja – odczytaj plik po zapisie
        const checkContent = await fs.readFile(ENV_FILE_PATH, "utf-8");
        console.log("🔍 Zawartość pliku .env po zapisie:", checkContent);
    } catch (error) {
        console.error("❌ Błąd zapisu do .env:", error);
        throw new Error("Nie udało się zapisać tokena do .env");
    }
};

// Główna funkcja wykonawcza
export const fetchAndSaveToken = async (): Promise<void> => {
    console.log("🚀 Uruchamianie `auth.ts`...");

    try {
        const { baseUrl, username, password } = await getAuthData();
        const token = await fetchToken(baseUrl, username, password);
        await saveTokenToEnv(token);
    } catch (error) {
        console.error("⚠️ Błąd: ", error.message);
    }
};
