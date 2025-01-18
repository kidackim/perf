import fs from "fs";
import path from "path";
import { simulation, scenario, http } from "gatling-js";

const configFilePath = path.resolve(__dirname, "gatling-request-configs.json");

// Wczytanie konfiguracji z pliku
const config = JSON.parse(fs.readFileSync(configFilePath, "utf-8"));
const { baseUrl, requestConfigs } = config;

export default simulation((setUp) => {
  const scenarios = requestConfigs.map(({ method, endpoint, body }) => {
    const req = http(`${method} ${endpoint}`);
    const request = method === "GET"
      ? req.get(endpoint)
      : req[method.toLowerCase()](endpoint).body(body ? JSON.stringify(body) : undefined).asJson();

    return scenario(`${method} ${endpoint}`)
      .exec(request.check(http.status().is(200)))
      .injectOpen({ rampUsers: 10, during: 10 });
  });

  setUp(scenarios).protocols(http.baseUrl(baseUrl));
});
