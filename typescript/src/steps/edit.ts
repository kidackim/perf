import { tryMax, pause } from "@gatling.io/core";
import { http, status } from "@gatling.io/http";

export const edit =
    // let's try at max 2 times
    tryMax(2)
      .on(
        http("Form").get("/computers/new"),
        pause(1),
        http("Post")
          .post("/computers")
          .formParam("name", "Beautiful Computer")
          .formParam("introduced", "2012-05-30")
          .formParam("discontinued", "")
          .formParam("company", "37")
          .check(
            status().is(
              // we do a check on a condition that's been customized with
              // a lambda. It will be evaluated every time a user executes
              // the request
              (session) => 200 + Math.floor(Math.random() * 2) // +0 or +1 at random
            )
          )
      )
      // if the chain didn't finally succeed, have the user exit the whole scenario
      .exitHereIfFailed();
