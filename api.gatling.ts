import { scenario, http, constantConcurrentUsers, during, exec } from "gatling/ts/core";
import { StringBody } from "gatling/ts/http";
import { DurationHelper } from "gatling/ts/core/dsl";

// 🔹 GLOBALNA zmienna na token (będzie dostępna dla wszystkich użytkowników)
let globalToken: string | null = null;

// 🔹 Jednorazowe pobranie tokena przed rozpoczęciem symulacji
const getToken = exec(
    http("Get Auth Token")
        .post("/auth/login")
        .body(StringBody(JSON.stringify({ username: "testUser", password: "superSecret" })))
        .header("Content-Type", "application/json")
        .check((response) => {
            globalToken = response.json("access_token"); // 📌 Zapisz token do globalnej zmiennej
            console.log(`✅ Globalny token pobrany: ${globalToken}`); // Debug
        })
);

// 🔹 Zapytanie autoryzowane używające **globalnego tokena**
const makeAuthenticatedRequest = exec(
    http("Protected Request")
        .get("/api/protected")
        .header("Authorization", () => `Bearer ${globalToken}`) // 📌 Globalny token
);

// 🔹 Scenariusz pobierania tokena (tylko raz)
const initTokenScenario = scenario("Init Token").exec(getToken);

// 🔹 Scenariusz testowy dla użytkowników
const testScenario = scenario("Test API")
    .exec(makeAuthenticatedRequest) // 🔥 Każdy użytkownik używa gotowego tokena
    .during(DurationHelper.hours(2), "repeat-request", exec(makeAuthenticatedRequest)); // 🔥 2 godziny testów

// 🔹 Symulacja (pobranie tokena przed testami)
export const testSimulation = {
    scenarios: [initTokenScenario, testScenario], // 🔥 Pobranie tokena przed uruchomieniem użytkowników
    inject: [
        constantConcurrentUsers(1).during(DurationHelper.seconds(1)), // 🔥 Pobierz token (1 użytkownik, raz)
        constantConcurrentUsers(50).during(DurationHelper.hours(2)), // 🔥 50 użytkowników przez 2 godziny
    ],
};
