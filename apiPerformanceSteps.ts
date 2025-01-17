import { Given, When, Then } from "@cucumber/cucumber";
import { exec } from "child_process";
import * as fs from "fs";
import * as path from "path";

let baseUrl: string;
let endpoints: string[] = [];
let gatlingOutput: string;

Given("the base URL {string}", (url: string) => {
  baseUrl = url; // Ustawiamy base URL
});

When("I send GET requests to the following endpoints:", (dataTable) => {
  // Pobieramy listę endpointów z tabeli
  endpoints = dataTable.rawTable.map((row) => row[0]); // Każdy wiersz to jeden endpoint
});

Then("I generate a performance report", async () => {
  const simulationFilePath = path.resolve(
    "./src/simulations/MultipleRequestsSimulation.ts"
  );

  if (!fs.existsSync(simulationFilePath)) {
    throw new Error(`Simulation file not found at ${simulationFilePath}`);
  }

  // Tworzymy plik JSON z dynamicznymi endpointami
  const configFilePath = path.resolve("./src/config/endpoints.json");
  fs.writeFileSync(
    configFilePath,
    JSON.stringify({ baseUrl, endpoints }, null, 2)
  );

  // Uruchamiamy symulację Gatling
  await new Promise<void>((resolve, reject) => {
    exec(
      `npx gatling-js-cli run ${simulationFilePath}`,
      (error, stdout) => {
        if (error) {
          reject(error);
        }
        gatlingOutput = stdout;
        resolve();
      }
    );
  });

  // Weryfikacja raportu Gatling
  if (!gatlingOutput.includes("Simulation finished")) {
    throw new Error("Gatling simulation did not complete successfully!");
  }

  console.log("Gatling Output:\n", gatlingOutput);
});
