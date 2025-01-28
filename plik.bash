import { Allure, AllureStep, AllureTest, AllureRuntime } from "allure-js-commons";

export class AllureReporter {
    private allure: Allure;

    constructor() {
        this.allure = new Allure(new AllureRuntime({ resultsDir: "allure-results" }));
    }

    startTest(name: string) {
        const test: AllureTest = this.allure.startCase(name);
        return test;
    }

    endTest(status: "passed" | "failed" | "skipped") {
        this.allure.endCase(status);
    }

    addStep(name: string, status: "passed" | "failed") {
        const step: AllureStep = this.allure.startStep(name);
        step.status = status;
        this.allure.endStep();
    }
}
