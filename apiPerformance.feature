Feature: Performance Testing with Mixed HTTP Methods
  As a tester
  I want to test multiple endpoints with different HTTP methods
  So that I can evaluate the system's performance

  Scenario: Test multiple endpoints with GET, POST, and PUT
    Given the base URL "http://localhost:8080"
    When I send a GET request to "/api/v1/resource"
    And I send a POST request to "/api/v1/resource" with body:
      """
      {
        "name": "New Resource",
        "type": "example"
      }
      """
    And I send a PUT request to "/api/v1/resource/123" with body:
      """
      {
        "name": "Updated Resource"
      }
      """
    Then I generate a performance report
