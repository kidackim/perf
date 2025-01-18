import fs from "fs";
import path from "path";
import { simulation, scenario, http } from "gatling-js";

const configFilePath = path.resolve(__dirname, "gatling-config.json");

// Wczytanie konfiguracji z pliku JSON
const config = JSON.parse(fs.readFileSync(configFilePath, "utf-8"));
const { baseUrl, endpoints } = config;

export default simulation((setUp) => {
  // Scenariusz dla wszystkich endpointów
  const dynamicScenario = scenario("Dynamic GET Requests")
    .foreach(endpoints, "endpoint")
    .on(
      exec((session) => {
        const endpoint = session.get("endpoint");
        return http(`GET ${endpoint}`)
          .get(endpoint)
          .check(http.status().is(200));
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
