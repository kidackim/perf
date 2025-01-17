import { exec } from "@gatling.io/core";
import { http } from "@gatling.io/http";

export interface ApiResponse {
  property1: string;
  property2: string;
  property3: number;
  property4: number;
}


export const verifyTypedJsonResponse = exec(
  http("Verify JSON Response with Mixed Types")
    .get("/computers") // Endpoint do testowania
    .check(
      http.body().string().transform((body) => {
        // Parsujemy odpowiedź jako ApiResponse
        const json: ApiResponse = JSON.parse(body);

        // Sprawdzamy typy każdej właściwości
        const isValid =
          typeof json.property1 === "string" &&
          typeof json.property2 === "string" &&
          typeof json.property3 === "number" &&
          typeof json.property4 === "number";

        return isValid; // Zwracamy true, jeśli wszystkie typy są poprawne
      }).is(true) // Sprawdzamy, czy weryfikacja przeszła pomyślnie
    )
);
