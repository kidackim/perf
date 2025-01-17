import { Given, When, Then } from "@cucumber/cucumber";
import { exec } from "child_process";

let baseUrl: string;
const endpoints: string[] = [];
let gatlingOutput: string;

Given("the base URL {string}", (url: string) => {
  baseUrl = url; // Ustawienie bazowego URL
});

When("I send a GET request to {string}", (endpoint: string) => {
  endpoints.push(endpoint); // Dodanie endpointu do listy
});

Then("I generate a performance report", async function () {
  console.log("Base URL:", baseUrl);
  console.log("Endpoints:", endpoints);

  // Budowanie zmiennych środowiskowych
  const envVariables = {
    BASE_URL: baseUrl,
    ENDPOINTS: endpoints.join(","), // Łączymy endpointy w jeden ciąg znaków
  };

  // Uruchamianie symulacji Gatling.js
  return new Promise<void>((resolve, reject) => {
    exec(
      `npx gatling-js-cli run ./src/simulations/ParametrizedSimulation.ts`,
      { env: { ...process.env, ...envVariables } }, // Dodanie zmiennych środowiskowych
      (error, stdout, stderr) => {
        if (error) {
          console.error("Error during Gatling execution:", stderr);
          reject(error);
          return;
        }

        gatlingOutput = stdout;
        console.log("Gatling Output:\n", gatlingOutput);
        resolve();
      }
    );
  });
});
