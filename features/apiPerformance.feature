Feature: Performance Testing with Mixed HTTP Methods
  As a tester
  I want to test multiple endpoints with different HTTP methods
  So that I can evaluate the system's performance

  Scenario: Test multiple endpoints with GET, POST, and PUT
    Given the base URL "http://localhost:8080"
    When I send a GET request to "/api/v1/resource"
    Then I generate a performance report
