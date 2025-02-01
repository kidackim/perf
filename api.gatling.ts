import fs from "fs";
import path from "path";
import dotenv from "dotenv";

// Załaduj istniejące zmienne środowiskowe
dotenv.config();

// Ścieżka do pliku z danymi logowania
const SCENARIO_FILE_PATH = path.resolve(__dirname, "scenario.json");
const ENV_FILE_PATH = path.resolve(__dirname, "../.env");

// Definicja interfejsu dla danych logowania
interface AuthCredentials {
    username: string;
    password: string;
}

// Funkcja odczytująca dane logowania z `scenario.json`
function getAuthData(): AuthCredentials {
    if (!fs.existsSync(SCENARIO_FILE_PATH)) {
        console.error("❌ Brak pliku scenario.json!");
        process.exit(1);
    }

    try {
        const rawData = fs.readFileSync(SCENARIO_FILE_PATH, "utf-8");
        const jsonData: AuthCredentials = JSON.parse(rawData);

        if (!jsonData.username || !jsonData.password) {
            throw new Error("Brakuje wymaganych pól w scenario.json");
        }

        return jsonData;
    } catch (error) {
        console.error("❌ Błąd odczytu scenario.json:", error);
        process.exit(1);
    }
}

// Funkcja pobierająca token autoryzacyjny
async function fetchToken(username: string, password: string): Promise<string> {
    try {
        const response = await fetch("https://api.example.com/auth", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username, password }),
        });

        if (!response.ok) {
            throw new Error(`Błąd pobierania tokena: ${response.statusText}`);
        }

        const data: { access_token: string } = await response.json();

        if (!data.access_token) {
            throw new Error("Brak tokena w odpowiedzi serwera");
        }

        return data.access_token;
    } catch (error) {
        console.error("❌ Błąd podczas pobierania tokena:", error);
        process.exit(1);
    }
}

// Funkcja zapisująca token do `.env`
function saveTokenToEnv(token: string): void {
    try {
        const envContent = `TOKEN="${token}"\n`;
        fs.writeFileSync(ENV_FILE_PATH, envContent, { flag: "w" });

        console.log("✅ Token pobrany i zapisany do .env w formacie TOKEN=\"token\"");
    } catch (error) {
        console.error("❌ Błąd zapisu do .env:", error);
        process.exit(1);
    }
}

// Główna funkcja wykonawcza
export async function fetchAndSaveToken(): Promise<void> {
    const { username, password } = getAuthData();
    const token = await fetchToken(username, password);
    saveTokenToEnv(token);
}
