@regression
Feature: Sample API Testing

  Background:
    * url 'https://jsonplaceholder.typicode.com'

  Scenario: Get all posts
    Given path '/posts'
    When method GET
    Then status 200
    And match response == '#[100]'
    And match response[0].id == 1
    And match response[0].title == '#string'

  Scenario: Get a specific post
    Given path '/posts/1'
    When method GET
    Then status 200
    And match response.id == 1
    And match response.userId == 1
    And match response.title == '#string'
    And match response.body == '#string'

  Scenario: Create a new post
    Given path '/posts'
    And request
      """
      {
        "title": "Test Post",
        "body": "This is a test post created by Karate",
        "userId": 1
      }
      """
    When method POST
    Then status 201
    And match response.id == '#number'
    And match response.title == 'Test Post'
    And match response.body == 'This is a test post created by Karate'
    And match response.userId == 1

  Scenario: Update a post
    Given path '/posts/1'
    And request
      """
      {
        "id": 1,
        "title": "Updated Test Post",
        "body": "This post has been updated",
        "userId": 1
      }
      """
    When method PUT
    Then status 200
    And match response.id == 1
    And match response.title == 'Updated Test Post'
    And match response.body == 'This post has been updated'

  Scenario: Delete a post
    Given path '/posts/1'
    When method DELETE
    Then status 200