
# Gatling Performance Testing for Web Applications

A performance testing project using Gatling to simulate realistic user scenarios (`search`, `browse`, `edit`) for web applications.

## Wymagania wstępne

Projekt wymaga [Node.js](https://nodejs.org/en/download) w wersji co najmniej 18 (tylko wersje LTS) oraz npm w wersji co najmniej 8 (dostarczony z Node.js).

## Instalacja

1. Pobrać repozytorium projektu.
2. Zainstalować wymagane zależności za pomocą poniższych poleceń:

```shell
cd <ścieżka-projektu>
npm install  # Zainstaluj zależności
```

## Struktura projektu

Projekt opiera się na trzech głównych krokach symulacji:
- `search`: symulacja wyszukiwania danych w aplikacji.
- `browse`: przeglądanie dostępnych zasobów.
- `edit`: edytowanie elementów aplikacji.
```

## Konfiguracja

Konfiguracja symulacji odbywa się w plikach projektu Gatling. Poniższe sekcje definiują:
- Strona docelowa: **url serwera testowego**.
- Liczba użytkowników: **np. symulacja 100 równoczesnych użytkowników**.
- Przykład konfiguracji kroków symulacji:

```typescript
const search = scenario('Search').exec(
  http('Search Request').get('/search?q=item')
);

const browse = scenario('Browse').exec(
  http('Browse Request').get('/browse')
);

const edit = scenario('Edit').exec(
  http('Edit Request').put('/edit/1')
);
```
```

## Uruchamianie testów

Aby uruchomić testy wydajnościowe, wykonaj następujące kroki:

```shell
npx gatling run --simulation search
npx gatling run --simulation browse
npx gatling run --simulation edit
```

Po uruchomieniu testu wyniki zostaną zapisane w katalogu `results`, gdzie znajdziesz raporty z testów.
```

## Autorzy

Projekt został przygotowany przez Zespół Wydajności Aplikacji. W razie pytań prosimy o kontakt.

```shell
npm run clean # Delete Gatling bundled code and generated reports
npm run format # Format code with prettier
npm run check # TypeScript project only, type check but don't build or run
npm run build # Build project but don't run
npm run computerdatabase # Run the included computerdatabase simulation
npm run recorder # Starts the Gatling Recorder
## Licencja

Projekt jest objęty licencją MIT. Więcej szczegółów znajdziesz w pliku `LICENSE`.
```
