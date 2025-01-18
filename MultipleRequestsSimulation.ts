import {
  simulation,
  scenario,
  exec,
  Session,
  ScenarioBuilder,
  jsonFile,
  group,
  http
} from "@gatling.io/core";

export default simulation((setUp) => {
  // Ścieżka do pliku JSON wygenerowanego przez Cucumber-JS
  const requestConfigFile = "requests.json";

  // Wczytanie konfiguracji z pliku JSON
  const requestFeeder = jsonFile(requestConfigFile).sequential(); // Zachowanie kolejności

  // Definicja scenariusza
  const scn: ScenarioBuilder = scenario("Execute Requests in Order")
    .feed(requestFeeder) // Załaduj dane w kolejności z pliku
    .exec(
      group("Send Requests").on(
        exec((session: Session) => {
          // Pobierz metodę i endpoint z pliku
          const method = session.get<string>("method");
          const endpoint = session.get<string>("endpoint");
          console.log(`Sending ${method} request to: ${endpoint}`);

          // Zbuduj żądanie HTTP na podstawie metody
          const request =
            method === "GET"
              ? http(`GET ${endpoint}`).get(endpoint)
              : http(`${method} ${endpoint}`)
                .request(method.toLowerCase(), endpoint)
                .check(http.status().is(200)); // Walidacja statusu

          // Zwróć sesję z wykonanym żądaniem
          return request;
        })
      )
    );

  // Konfiguracja symulacji
  setUp(
    scn.injectOpen(
      exec(() => console.log("Starting the simulation")).andThen(
        scn.injectOpen({ users: 1 }) // Jeden użytkownik wykonuje wszystkie żądania w kolejności
      )
    )
  ).protocols(http.baseUrl("https://your-api-base-url.com"));
});
