import { simulation, scenario, http } from "@gatling.io/core";
import * as fs from "fs";
import * as path from "path";

// Wczytujemy konfigurację endpointów z pliku JSON
const configFilePath = path.resolve("./src/config/endpoints.json");
const { baseUrl, endpoints }: { baseUrl: string; endpoints: string[] } = JSON.parse(
  fs.readFileSync(configFilePath, "utf-8")
);

export default simulation((setUp) => {
  const scenarios = endpoints.map((endpoint) =>
    scenario(`GET Request to ${endpoint}`)
      .exec(
        http(`GET ${endpoint}`)
          .get(endpoint)
          .check(http.status().is(200)) // Sprawdzenie statusu odpowiedzi
      )
      .injectOpen({
        rampUsers: 10, // Liczba użytkowników
        during: 10,    // Czas trwania symulacji
      })
  );

  setUp(scenarios).protocols(http.baseUrl(baseUrl)); // Ustawienie base URL
});
