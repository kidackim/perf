import { Given, When, Then } from "@cucumber/cucumber";
import { exec } from "child_process";
import fs from "fs";
import path from "path";

let baseUrl: string;
const requestConfigs: { method: string; endpoint: string; body?: object }[] = [];
let gatlingOutput: string;

// Ustawienie bazowego URL
Given("the base URL {string}", (url: string) => {
  baseUrl = url;
});

// Dodanie konfiguracji żądania bez ciała
When("I send a {string} request to {string}", (method: string, endpoint: string) => {
  requestConfigs.push({ method, endpoint });
});

// Dodanie konfiguracji żądania z ciałem
When("I send a {string} request to {string} with body:", (method: string, endpoint: string, body: string) => {
  requestConfigs.push({ method, endpoint, body: JSON.parse(body) });
});

// Generowanie raportu wydajnościowego
Then("I generate a performance report", async function () {
  console.log("Base URL:", baseUrl);
  console.log("Request Configs:", requestConfigs);

  // Ścieżka do pliku JSON
  const configFilePath = path.resolve(__dirname, "gatling-request-configs.json");

  // Zapisanie konfiguracji do pliku JSON
  try {
    fs.writeFileSync(
      configFilePath,
      JSON.stringify({ baseUrl, requestConfigs }, null, 2)
    );
    console.log(`Configuration file saved at: ${configFilePath}`);
  } catch (error) {
    console.error("Error writing configuration file:", error);
    throw error;
  }

  // Uruchamianie Gatling z plikiem JSON
  return new Promise<void>((resolve, reject) => {
    exec(
      `npx gatling-js-cli run ./src/simulations/ParametrizedSimulation.ts --config ${configFilePath}`,
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
