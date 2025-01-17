import { exec } from "@gatling.io/core";
import { http, jsonPath } from "@gatling.io/http";

export const verifyJsonResponse = exec(
  http("Verify JSON Response")
    .get("/computers") // Twój endpoint API
    .check(
      jsonPath("$.property1").is("value1"), // Sprawdź, czy `property1` ma wartość "value1"
      jsonPath("$.property2").exists(),     // Sprawdź, czy `property2` istnieje
      jsonPath("$.property3").ofType("NUMBER"), // Sprawdź, czy `property3` to liczba
      jsonPath("$.property4").is("456")     // Sprawdź, czy `property4` ma wartość "456"
    )
);
