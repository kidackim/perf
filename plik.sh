const fs = require('fs');
const path = require('path');

function loadEnv() {
    const envPath = path.resolve(__dirname, '.env');
    if (!fs.existsSync(envPath)) {
        console.error('.env file not found!');
        process.exit(1);
    }

    const envData = fs.readFileSync(envPath, 'utf-8');
    envData.split('\n').forEach(line => {
        const [key, value] = line.split('=');
        if (key && value) {
            process.env[key.trim()] = value.trim();
        }
    });
}

// Wczytaj zmienne do systemu
loadEnv();
