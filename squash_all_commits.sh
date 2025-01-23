import { scenario, http, feeders, StringBody, status, setUp } from 'gatling';

// Feeder z danymi wejściowymi
const endpointsFeeder = feeders([
  { method: 'GET', endpoint: '/api/resource1' },
  { method: 'POST', endpoint: '/api/resource2' },
]);

// Scenariusz testowy
const scn = scenario('Dynamic Requests Scenario')
  .feed(endpointsFeeder) // Ładowanie danych do sesji
  .exec((session) => {
    const method = session.get('method'); // Pobierz metodę
    const endpoint = session.get('endpoint'); // Pobierz endpoint

    console.log(`Executing request with Method: ${method}, Endpoint: ${endpoint}`);

    // Zapamiętaj szczegóły w sesji
    return session.set('httpRequestDetails', { method, endpoint });
  })
  .exec((session) => {
    const { method, endpoint } = session.get('httpRequestDetails'); // Pobierz szczegóły żądania

    // Obsługa GET
    if (method === 'GET') {
      return http('GET Request')
        .get(endpoint)
        .check(status().is(200)); // Sprawdzenie statusu
    }

    // Obsługa POST
    if (method === 'POST') {
      return http('POST Request')
        .post(endpoint)
        .body(StringBody('{"key":"value"}')).asJson()
        .check(status().is(200)); // Sprawdzenie statusu
    }

    // Log dla nieobsługiwanych metod
    console.error(`Unsupported HTTP method: ${method}`);
    return session; // Pominięcie wykonania
  });

// Konfiguracja uruchomienia scenariusza
setUp(
  scn.injectOpen(atOnceUsers(5)) // 5 równoczesnych użytkowników
).protocols(
  http.baseUrl('https://example.com') // Bazowy URL API
);