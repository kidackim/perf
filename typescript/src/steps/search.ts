export const verifyTypedJsonResponse = exec(
  http("Verify JSON Response")
    .get("/computers") // Twój endpoint
    .check(
      jsonPath("$.property1").is((value) => typeof value === "string"), // Sprawdź, czy property1 to string
      jsonPath("$.property2").is((value) => typeof value === "string"), // Sprawdź, czy property2 to string
      jsonPath("$.property3").is((value) => typeof value === "number"), // Sprawdź, czy property3 to liczba
      jsonPath("$.property4").is((value) => typeof value === "number")  // Sprawdź, czy property4 to liczba
    )
);