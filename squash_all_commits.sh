import { scenario, http, feeders, StringBody, status, setUp, jsonFile, group } from '@gatling.io/http';

export default simulation((setUp) => {
  // Konfiguracja protokołu HTTP
  const baseHttpProtocol = http.baseUrl('https://stlx03342.pl.ing-ad:15043');

  // Dynamiczne dane z pliku JSON
  const endpointsFeeder = jsonFile('config/endpoints.json').circular();

  // Scenariusz testowy
  const scn = scenario('Dynamic Requests Scenario')
    .feed(endpointsFeeder) // Ładowanie danych z pliku JSON
    .exec(
      group('Dynamic Request').on(
        exec((session) => {
          const method = session.get<string>('method');
          const endpoint = session.get<string>('endpoint');
          console.log(`Sending ${method} request to: ${endpoint}`);
          return session; // Zwraca sesję
        }),
        exec((session) => {
          const method = session.get<string>('method');
          const endpoint = session.get<string>('endpoint');

          // Obsługa GET i POST
          if (method === 'GET') {
            return http('GET Request')
              .get(endpoint)
              .check(status().is(200));
          } else if (method === 'POST') {
            return http('POST Request')
              .post(endpoint)
              .body(StringBody('{"key":"value"}')) // Treść żądania POST
              .asJson()
              .check(status().is(200));
          } else {
            console.error(`Unsupported HTTP method: ${method}`);
            return session; // Brak akcji dla nieobsługiwanych metod
          }
        })
      )
    );

  // Ustawienia symulacji
  setUp(scn.injectOpen(atOnceUsers(5)).protocols(baseHttpProtocol));
});