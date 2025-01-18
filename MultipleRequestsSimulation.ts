import {
  constantUsersPerSec,
  scenario,
  simulation,
  Session,
  ScenarioBuilder,
  exec,
  jsonFile,
  group,
  pause,
  arrayFeeder,
  atOnceUsers,
  GlobalStore,
  global
} from "@gatling.io/core";
import { http } from "@gatling.io/http";

export default simulation((setUp) => {
  // Konfiguracja protokołu HTTP
  const baseHttpProtocol = http.baseUrl("https://your-api-base-url.com");

  // Dynamiczne dane z pliku JSON
  const endpointsFeeder = jsonFile("config/endpoints.json").random();

  // Scenariusz
  const scn: ScenarioBuilder = scenario("Dynamic GET Requests")
    .feed(endpointsFeeder) // Ładowanie dynamicznych endpointów
    .exec(
      group("Send GET Request").on(
        exec((session) => {
          const endpoint = session.get<string>("endpoint");
          console.log(`Sending GET request to: ${endpoint}`);
          return session;
        }),
        http("GET Request")
          .get("#{endpoint}")
          .check(http.status().is(200)),
        pause({ amount: 1, unit: "seconds" }) // Pauza między żądaniami
      )
    );

  // Ustawienia symulacji
  setUp(
    scn.injectOpen(
      constantUsersPerSec(5).during(60) // Stały ruch użytkowników przez 60 sekund
    ).andThen(
      scenario("Post execution")
        .exec((session) => {
          console.log(`Total requests sent: ${GlobalStore.get("requestsSent")}`);
          return session;
        })
        .injectOpen(atOnceUsers(1)) // Jeden użytkownik wykonuje post-processing
    )
  )
    .protocols(baseHttpProtocol)
    .assertions(
      global().responseTime().percentile(95.0).lte(500), // Weryfikacja czasu odpowiedzi
      global().successfulRequests().percent().gte(99.0) // Weryfikacja sukcesu żądań
    );
});
