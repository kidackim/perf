feat: Integrate cucumber-js and automate performance test configuration generation

- Added cucumber-js library to the project for behavior-driven test definitions.
- Implemented methods in cucumber-js to automatically generate a standardized JSON configuration file.
  - The JSON file captures all defined GET and POST methods in the scenarios.
  - Ensures consistent formatting for interoperability with Gatling feeders.
- Updated Gatling-js configuration to utilize the generated JSON file as a feeder.
  - Automates the creation of performance testing models based on the JSON configuration.
  - Simplifies the process of defining and maintaining performance test scenarios.
- Enhanced workflow:
  1. Cucumber-js executes all steps and generates a standardized JSON file.
  2. Gatling-js reads the JSON file via a feeder.
  3. Automatically prepares a performance test model for execution.

This integration streamlines the transition from scenario definitions to performance tests, reducing manual effort and enhancing reproducibility.