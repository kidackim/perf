import { exec, pause, csv, css, feed } from "@gatling.io/core";
import { http, status } from "@gatling.io/http";

const feeder = csv("search.csv").random();

export const search = exec(
  http("Home").get("/"),
  pause(1),
  feed(feeder),
  http("Search")
    .get("/computers?f=#{searchCriterion}")
    .check(css("a:contains('#{searchComputerName}')", "href").saveAs("computerUrl")),
  pause(1),
  http("Select").get("#{computerUrl}").check(status().is(200)),
  pause(1)
)

