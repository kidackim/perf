import { simulation, scenario, http } from "@gatling.io/core";

// Pobierz zmienne środowiskowe
const baseUrl = process.env.BASE_URL || "http://localhost:8080";
const endpoints = (process.env.ENDPOINTS || "").split(",").filter((e) => e);

if (endpoints.length === 0) {
  throw new Error("No endpoints provided! Set ENDPOINTS environment variable.");
}

export default simulation((setUp) => {
  const scenarios = endpoints.map((endpoint) =>
    scenario(`Performance Test for ${endpoint}`).exec(
      http(`GET ${endpoint}`)
        .get(endpoint)
        .check(http.status().is(200))
    ).injectOpen({
      rampUsers: 10,
      during: 10, // Czas trwania symulacji
    })
  );

  setUp(scenarios).protocols(http.baseUrl(baseUrl));
});
