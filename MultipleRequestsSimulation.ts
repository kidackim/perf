import { simulation, scenario, http } from "@gatling.io/core";

// Pobieranie zmiennych środowiskowych
const baseUrl = process.env.BASE_URL || "http://localhost:8080";
const requestConfigs = process.env.REQUESTS
  ? JSON.parse(process.env.REQUESTS)
  : [];

if (requestConfigs.length === 0) {
  throw new Error("No requests provided! Set REQUESTS environment variable.");
}

export default simulation((setUp) => {
  // Tworzymy scenariusze na podstawie konfiguracji
  const scenarios = requestConfigs.map(({ method, endpoint, body }) =>
    scenario(`Test ${method} ${endpoint}`).exec(
      http(`${method} ${endpoint}`)
        [method.toLowerCase()](endpoint) // Wybieramy metodę HTTP
        .body(body ? JSON.stringify(body) : undefined) // Dodajemy payload, jeśli istnieje
        .asJson() // Wysyłamy jako JSON
        .check(http.status().is(200)) // Walidacja statusu odpowiedzi
    ).injectOpen({
      rampUsers: 10, // Liczba użytkowników
      during: 10, // Czas trwania symulacji
    })
  );

  setUp(scenarios).protocols(http.baseUrl(baseUrl));
});
