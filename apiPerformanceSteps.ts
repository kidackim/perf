import { Given, When, Then } from "@cucumber/cucumber";
import { exec } from "child_process";

let baseUrl: string;
const requestConfigs: { method: string; endpoint: string; body?: object }[] = [];
let gatlingOutput: string;

Given("the base URL {string}", (url: string) => {
  baseUrl = url; // Ustawienie bazowego URL
});

When("I send a {string} request to {string}", (method: string, endpoint: string) => {
  requestConfigs.push({ method, endpoint }); // Dodanie konfiguracji żądania
});

When("I send a {string} request to {string} with body:", (method: string, endpoint: string, body: string) => {
  requestConfigs.push({ method, endpoint, body: JSON.parse(body) }); // Dodanie żądania z ciałem
});

Then("I generate a performance report", async function () {
  console.log("Base URL:", baseUrl);
  console.log("Request Configs:", requestConfigs);

  // Budowanie zmiennych środowiskowych
  const envVariables = {
    BASE_URL: baseUrl,
    REQUESTS: JSON.stringify(requestConfigs), // Przekazujemy konfigurację jako JSON
  };

  // Uruchamianie symulacji Gatling.js
  return new Promise<void>((resolve, reject) => {
    exec(
      `npx gatling-js-cli run ./src/simulations/ParametrizedSimulation.ts`,
      { env: { ...process.env, ...envVariables } },
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
