import { simulation, scenario, rampUsers } from "@gatling.io/core";
import { http } from "@gatling.io/http";

import { search } from "./steps/search";
import { browse } from "./steps/browse";
import { edit } from "./steps/edit";

export default simulation((setUp) => {
  const httpProtocol = http
    .baseUrl("https://computer-database.gatling.io")
    .acceptHeader("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
    .acceptLanguageHeader("en-US,en;q=0.5")
    .acceptEncodingHeader("gzip, deflate")
    .userAgentHeader(
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/119.0"
    );

  const users = scenario("Users").exec(search, browse);
  const admins = scenario("Admins").exec(search, browse, edit);

  setUp(
    users.injectOpen(rampUsers(10).during(10)),
    admins.injectOpen(rampUsers(2).during(10))
  ).protocols(httpProtocol);
});
