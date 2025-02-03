import fs from 'fs';
import dotenv from 'dotenv';

dotenv.config(); // Załaduj istniejące zmienne z .env

async function getAccessToken() {
    // Pobierz token z API
    const accessToken = "przykładowy_token"; // tutaj Twój kod do pobierania tokena

    // Wczytaj obecne zmienne
    const envPath = '.env';
    let envContent = fs.readFileSync(envPath, 'utf8');

    // Jeśli TOKEN już istnieje, zastąp jego wartość, jeśli nie – dodaj nową linię
    if (/^TOKEN=/m.test(envContent)) {
        envContent = envContent.replace(/^TOKEN=.*/m, `TOKEN="${accessToken}"`);
    } else {
        envContent += `\nTOKEN="${accessToken}"\n`;
    }

    fs.writeFileSync(envPath, envContent, 'utf8'); // Nadpisz plik .env
}

getAccessToken();
