export default simulation((setUp) => {
  const scenarios = requestConfigs.map(({ method, endpoint, body }) => {
    const req = http(`${method} ${endpoint}`);

    // Ręczne przypisanie metody HTTP
    let request;
    if (method === "GET") {
      request = req.get(endpoint);
    } else if (method === "POST") {
      request = req.post(endpoint).body(body ? JSON.stringify(body) : undefined).asJson();
    } else if (method === "PUT") {
      request = req.put(endpoint).body(body ? JSON.stringify(body) : undefined).asJson();
    } else {
      throw new Error(`Unsupported method: ${method}`);
    }

    return scenario(`Test ${method} ${endpoint}`)
      .exec(request.check(http.status().is(200))) // Walidacja statusu odpowiedzi
      .injectOpen({
        rampUsers: 10, // Liczba użytkowników
        during: 10, // Czas trwania symulacji
      });
  });

  setUp(scenarios).protocols(http.baseUrl(baseUrl));
});
