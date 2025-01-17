Feature: API Performance Testing with Multiple Requests
  As a tester
  I want to test the performance of multiple GET requests
  So that I can ensure the API handles load efficiently

  Scenario: Test multiple GET requests
    Given the base URL "http://localhost:8080"
    When I send GET requests to the following endpoints:
      | /endpoint1 |
      | /endpoint2 |
      | /endpoint3 |
      | /endpoint4 |
      | /endpoint5 |
      | /endpoint6 |
      | /endpoint7 |
      | /endpoint8 |
      | /endpoint9 |
      | /endpoint10 |
    Then I generate a performance report
