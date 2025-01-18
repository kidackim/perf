import fs from "fs";
import path from "path";
import { simulation, scenario, http } from "gatling-js";

const configFilePath = path.resolve(__dirname, "gatling-request-configs.json");

// Wczytanie konfiguracji z pliku JSON
const config = JSON.parse(fs.readFileSync(configFilePath, "utf-8"));
const { baseUrl, requestConfigs } = config;

export default simulation((setUp) => {
  const scenarios = requestConfigs.map(({ method, endpoint, body }, index) => {
    const req = http(`${method} ${endpoint}`);
    const request = method === "GET"
      ? req.get(endpoint)
      : req[method.toLowerCase()](endpoint)
        .body(body ? JSON.stringify(body) : undefined)
        .asJson();

    return scenario(`Scenario ${index + 1}: ${method} ${endpoint}`)
      .repeat(1) // Powtórzenie dla każdego wpisu w tablicy (możesz zmodyfikować liczbę)
      .on(request.check(http.status().is(200)));
  });

  // Dostosowanie liczby użytkowników i czasu trwania do liczby wpisów
  setUp(
    scenarios.map((s) =>
      s.injectOpen({
        rampUsers: 10 * requestConfigs.length, // Liczba użytkowników proporcjonalna do liczby żądań
        during: 10 * requestConfigs.length,   // Czas trwania proporcjonalny do liczby żądań
      })
    )
  ).protocols(http.baseUrl(baseUrl));
});
