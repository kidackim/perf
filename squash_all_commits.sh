// Funkcja pomocnicza do dynamicznego generowania żądania
const dynamicRequest = (session) => {
  const method = session.get('method');
  const endpoint = session.get('endpoint');

  if (method === 'GET') {
    return http('Dynamic GET Request')
      .get(endpoint)
      .check(status().is(200)); // Sprawdzenie statusu odpowiedzi
  } else if (method === 'POST') {
    return http('Dynamic POST Request')
      .post(endpoint)
      .body(StringBody('{"key":"value"}')).asJson() // Treść POST
      .check(status().is(200)); // Sprawdzenie statusu odpowiedzi
  } else {
    console.error(`Unsupported HTTP method: ${method}`);
    return null; // Zwraca null w przypadku nieobsługiwanej metody
  }
};

// Scenariusz testowy
const scn = scenario('Dynamic Requests Scenario')
  .feed(endpointsFeeder) // Ładowanie danych z feedera do sesji
  .exec((session) => {
    // Generowanie dynamicznego żądania na podstawie sesji
    const request = dynamicRequest(session);
    if (request) {
      return request;
    }
    return session; // Jeśli brak requestu, zwracamy sesję bez akcji
  });

// Konfiguracja uruchomienia scenariusza
setUp(
  scn.injectOpen(atOnceUsers(5)) // 5 równoczesnych użytkowników
).protocols(
  http.baseUrl('https://example.com') // Bazowy URL API
);