import fs from "fs";
import path from "path";
import { simulation, scenario, http } from "gatling-js";

const configFilePath = path.resolve(__dirname, "gatling-request-configs.json");

// Wczytanie konfiguracji z pliku JSON
const config = JSON.parse(fs.readFileSync(configFilePath, "utf-8"));
const { baseUrl, requestConfigs } = config;

export default simulation((setUp) => {
  // Scenariusz iterujący przez wszystkie żądania w konfiguracji
  const dynamicScenario = scenario("Dynamic Scenario")
    .repeat(requestConfigs.length, "index") // Iteracja przez `requestConfigs`
    .on(
      exec((session) => {
        const index = session.get("index"); // Pobierz aktualny indeks
        const { method, endpoint, body } = requestConfigs[index];

        const req = http(`${method} ${endpoint}`);
        const request =
          method === "GET"
            ? req.get(endpoint)
            : req[method.toLowerCase()](endpoint)
              .body(body ? JSON.stringify(body) : undefined)
              .asJson();

        // Wykonanie żądania z walidacją statusu
        return request.check(http.status().is(200));
      })
    );

  // Stałe ustawienia symulacji
  setUp(
    dynamicScenario.injectOpen({
      rampUsers: 20, // Stała liczba użytkowników
      during: 30,    // Stały czas trwania symulacji
    })
  ).protocols(http.baseUrl(baseUrl));
});
