import { exec } from "@gatling.io/core";
import { http, jmesPath } from "@gatling.io/http";

export const verifyFullResponse = exec(
  http("Verify Full JSON Response")
    .get("/your-endpoint") // Podmień na swój endpoint
    .check(
      jmesPath("@") // Pobiera cały respons JSON
        .transform((response) => {
            // Dodaj swoje asercje na całym responsie
            const isValid =
              typeof response.property1 === "string" &&
              typeof response.property2 === "string" &&
              typeof response.property3 === "number" &&
              Array.isArray(response.property4); // Przykład: sprawdź, czy property4 to tablica
            return isValid;
        })
        .is(true) // Walidacja przechodzi, jeśli wszystkie warunki są spełnione
    )
);
