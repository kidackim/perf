import { repeat, pause } from "@gatling.io/core";
import { http } from "@gatling.io/http";

// New constant for the number of pages to browse
const numberOfPages = 4;

// New helper function to generate a browsing scenario
function generateBrowseScenario(pages: number) {
  return repeat(pages, "i").on(
    http("Page #{i}").get("/computers?p=#{i}"),
    pause(1)
  );
}

export const browse = generateBrowseScenario(numberOfPages);
