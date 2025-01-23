import { scenario, http, status, feeders, StringBody } from 'gatling';

// Feeder z dynamicznymi endpointami i metodami
const endpointsFeeder = feeders([
  { method: 'GET', endpoint: '/api/resource1' },
  { method: 'POST', endpoint: '/api/resource2' },
]);

// Scenariusz
const scn = scenario('Dynamic Requests Scenario')
  .feed(endpointsFeeder) // Ładowanie danych z feeder
  .exec((session) => {
    const method = session.get('method'); // Pobierz metodę
    const endpoint = session.get('endpoint'); // Pobierz endpoint

    // Obsługa GET
    if (method === 'GET') {
      return http('GET Request')
        .get(endpoint)
        .check(status().is(200));
    }
    // Obsługa POST
    else if (method === 'POST') {
      return http('POST Request')
        .post(endpoint)
        .body(StringBody('{"key":"value"}')).asJson()
        .check(status().is(200));
    }
    // Obsługa innych metod
    else {
      console.error(`Unsupported HTTP method: ${method}`);
      return session; // Pominięcie wykonania żądania
    }
  });

// Konfiguracja uruchomienia scenariusza
setUp(
  scn.injectOpen(atOnceUsers(5)) // Wykonanie z 5 równoczesnymi użytkownikami
).protocols(
  http.baseUrl('https://example.com') // Ustawienia globalnego protokołu HTTP
);