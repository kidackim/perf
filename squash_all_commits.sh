import { scenario, http, feeders, StringBody, status, setUp } from 'gatling';

// Feeder z dynamicznymi danymi
const endpointsFeeder = feeders([
  { method: 'GET', endpoint: '/api/resource1' },
  { method: 'POST', endpoint: '/api/resource2' },
]);

// Scenariusz testowy
const scn = scenario('Dynamic Requests Scenario')
  .feed(endpointsFeeder) // Ładowanie danych z feedera do sesji
  .doIf((session) => session.get('method') === 'GET', // Warunek dla GET
    exec(
      http('GET Request')
        .get((session) => session.get('endpoint')) // Pobranie dynamicznego endpointu
        .check(status().is(200)) // Sprawdzenie statusu odpowiedzi
    )
  )
  .doIf((session) => session.get('method') === 'POST', // Warunek dla POST
    exec(
      http('POST Request')
        .post((session) => session.get('endpoint')) // Pobranie dynamicznego endpointu
        .body(StringBody('{"key":"value"}')) // Treść żądania POST
        .asJson() // Wskazanie typu JSON
        .check(status().is(200)) // Sprawdzenie statusu odpowiedzi
    )
  )
  .doIfOrElse( // Obsługa nieznanych metod
    (session) => !['GET', 'POST'].includes(session.get('method')),
    exec((session) => {
      console.error(`Unsupported HTTP method: ${session.get('method')}`);
      return session; // Zwrócenie sesji bez wykonania żądania
    }),
    exec((session) => session) // Wykonanie domyślnej akcji
  );

// Konfiguracja uruchomienia scenariusza
setUp(
  scn.injectOpen(atOnceUsers(5)) // 5 równoczesnych użytkowników
).protocols(
  http.baseUrl('https://example.com') // Ustawienie globalnego URL dla żądań
);