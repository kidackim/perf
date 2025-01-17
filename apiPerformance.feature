Feature: Performance Testing with Parametrized Simulation
  As a tester
  I want to test multiple endpoints
  So that I can evaluate the system's performance

  Scenario: Test API performance
    Given the base URL "http://localhost:8080"
    When I send a GET request to "/api/v1/resource"
    And I send a GET request to "/api/v1/status"
    Then I generate a performance report
