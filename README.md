
# Performance Testing with Gatling and TypeScript

This project provides a performance testing framework using **Gatling** with **TypeScript**. It allows for the definition of test scenarios and steps, as well as the generation of comprehensive HTML reports after test execution.

---

## Getting Started

### Prerequisites

Before running the tests, ensure that the following tools are installed:
- **Node.js** (version 16 or higher recommended)
- **NPM** (Node Package Manager)

### Installation

Clone the repository and install the dependencies:

```bash
git clone <repository_url>
cd <project_directory>
npm install
```

---

## Running Tests

To execute a test scenario, use the following command:

```bash
npx gatling run --typescript --simulation <simulation_name>
```

### Example

```bash
npx gatling run --typescript --simulation sym
```

This command:
1. Runs the simulation defined in files containing `gatling-sym` in their names, located in the `src` folder.
2. Generates test reports in the `target` folder in HTML format.

---

## Project Structure

The project is organized as follows:

```
src/
├── steps/
│   └── *.ts         # Step definitions for test scenarios, including request models
├── gatling-sym*.ts  # Simulation files defining test behavior and user flows
target/
└── results/         # HTML reports generated after each test execution
```

### Key Components

#### `src/steps/`
This folder contains step definitions for test scenarios. Each file includes:
- Request models (e.g., headers, payloads, endpoints).
- Definitions of actions such as sending requests or validating responses.

#### `src/gatling-sym*.ts`
Files in this folder define the structure and flow of the tests, including:
- Steps to be executed in the simulation.
- User behavior models (e.g., number of users, ramp-up time, and load patterns).

---

## Test Reports

After running a test, an HTML report is generated in the `target` folder. The report includes:
- Detailed metrics such as response times, throughput, and error rates.
- Visualization of user behavior during the test.

To view the report, open the generated HTML file in any web browser.

---

## Documentation and References

For more details on Gatling, visit the [official Gatling documentation](https://gatling.io/docs/).

For TypeScript-specific usage with Gatling, refer to [Gatling TypeScript documentation](https://gatling.io/docs/gatling/reference/current/extensions/typescript/).

---

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any feature additions or bug fixes.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

If you have any questions or issues, feel free to open an issue in the repository or reach out to the project maintainers.
