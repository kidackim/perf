import { scenario, http, feeders, StringBody, status, setUp } from 'gatling';

// Feeder z dynamicznymi danymi
const endpointsFeeder = feeders([
  { method: 'GET', endpoint: '/api/resource1' },
  { method: 'POST', endpoint: '/api/resource2' },
]);

// Scenariusz
const scn = scenario('Dynamic Requests Scenario')
  .feed(endpointsFeeder) // Ładowanie danych z feeder
  .exec((session) => {
    const method = session.get('method');
    if (!method) {
      throw new Error('Method not found in session');
    }
    return session;
  })
  .doIf((session) => session.get('method') === 'GET', // Obsługa GET
    exec(
      http('GET Request')
        .get((session) => session.get('endpoint')) // Dynamiczny endpoint
        .check(status().is(200))
    )
  )
  .doIf((session) => session.get('method') === 'POST', // Obsługa POST
    exec(
      http('POST Request')
        .post((session) => session.get('endpoint')) // Dynamiczny endpoint
        .body(StringBody('{"key":"value"}')).asJson()
        .check(status().is(200))
    )
  )
  .doIfOrElse(
    (session) => session.get('method') !== 'GET' && session.get('method') !== 'POST',
    exec((session) => {
      console.error(`Unsupported HTTP method: ${session.get('method')}`);
      return session;
    }),
    exec((session) => session)
  );

// Konfiguracja uruchomienia scenariusza
setUp(
  scn.injectOpen(atOnceUsers(5)) // Uruchomienie z 5 równoczesnymi użytkownikami
).protocols(
  http.baseUrl('https://example.com') // Ustawienie bazowego URL
);