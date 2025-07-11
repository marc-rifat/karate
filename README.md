# Karate Automated API Testing

A comprehensive API testing framework using Karate DSL for automated REST API testing. This project provides a robust foundation for testing APIs with features like environment configuration, tagging, parallel execution, and detailed reporting.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running Tests](#running-tests)
- [Test Tags and Organization](#test-tags-and-organization)
- [Environment Management](#environment-management)
- [Writing Tests](#writing-tests)
- [Reporting](#reporting)
- [Advanced Features](#advanced-features)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Overview

This project uses Karate DSL, a powerful testing framework that combines API test automation, mocking, and performance testing. It's built on top of Cucumber and provides a simple syntax for writing API tests.

## Prerequisites

Before you can run this project, ensure you have the following installed:

- **Java 17 or higher**
- **Gradle 7.0+** - Will be downloaded automatically via Gradle wrapper
- **Git** - For version control
- **IDE** (Optional but recommended) - IntelliJ IDEA, Eclipse, or VS Code

### Verify Installation

```bash
# Check Java version
java -version

# Check if Gradle wrapper is working
./gradlew --version
```

## Project Structure

```
karate-automated-api-testing/
├── src/
│   └── test/
│       ├── java/
│       │   └── com/
│       │       └── example/
│       │           └── karate/
│       │               └── TestRunner.java      # Main test runner
│       └── resources/
│           ├── karate-config.js                 # Global configuration
│           └── sample-api-test.feature          # Sample test scenarios
├── build.gradle                                 # Build configuration
├── gradlew                                      # Gradle wrapper (Unix)
├── gradlew.bat                                  # Gradle wrapper (Windows)
└── README.md                                    # This file
```

## Installation

1. **Make gradlew executable (Unix/Mac only):**
   ```bash
   chmod +x gradlew
   ```

2. **Download dependencies:**
   ```bash
   ./gradlew build
   ```

## Configuration

### Environment Configuration

The project uses `karate-config.js` for environment-specific configuration:

```javascript
function fn() {
  var env = karate.env; // get system property 'karate.env'
  var config = {
    env: env,
    myVarName: 'someValue'
  }
  if (env == 'dev') {
    config.baseUrl = 'https://jsonplaceholder.typicode.com';
  } else if (env == 'staging') {
    config.baseUrl = 'https://staging-api.example.com';
  } else if (env == 'prod') {
    config.baseUrl = 'https://api.example.com';
  }
  return config;
}
```

### Supported Environments

- **dev** (default) - Development environment
- **staging** - Staging environment  
- **prod** - Production environment

## Running Tests

### Run All Tests

```bash
# Using Gradle wrapper (recommended)
./gradlew test

# Or using the custom karateTest task
./gradlew karateTest
```

### Run Tests with Specific Environment

```bash
# Run tests against staging environment
./gradlew test -Dkarate.env=staging

# Run tests against production environment
./gradlew test -Dkarate.env=prod
```

### Run Tests with Tags

Tags allow you to organize and run specific subsets of tests:

```bash
# Run only tests tagged with @regression
./gradlew test -Dkarate.options="--tags @regression"

# Run tests tagged with @smoke
./gradlew test -Dkarate.options="--tags @smoke"

# Run tests with multiple tags (AND condition)
./gradlew test -Dkarate.options="--tags @regression,@api"

# Run tests with OR condition
./gradlew test -Dkarate.options="--tags @regression or @smoke"

# Exclude specific tags
./gradlew test -Dkarate.options="--tags ~@ignore"
```

### Run Specific Test Files

```bash
# Run specific feature file
./gradlew test -Dkarate.options="classpath:sample-api-test.feature"

# Run tests in specific folder
./gradlew test -Dkarate.options="classpath:api/users"
```

### Run Tests in Parallel

Karate supports parallel execution to speed up test execution significantly:

```bash
# Run all tests in parallel with 4 threads
./gradlew test -Dkarate.options="--threads 4"

# Run specific tags in parallel
./gradlew test -Dkarate.options="--threads 4 --tags @regression"

# Run tests in parallel with custom thread count (adjust based on your system)
./gradlew test -Dkarate.options="--threads 8"

# Run parallel tests with environment specification
./gradlew test -Dkarate.env=staging -Dkarate.options="--threads 4"

# Run parallel tests with output directory
./gradlew test -Dkarate.options="--threads 4 --output build/parallel-reports"

# Run parallel tests excluding certain tags
./gradlew test -Dkarate.options="--threads 4 --tags ~@slow"
```

**Performance Tips:**
- Use 2-4 threads for most systems
- Higher thread counts may not always improve performance
- Consider your API's rate limiting when setting thread count
- Monitor system resources during parallel execution

### Debug Mode

```bash
# Run tests in debug mode with detailed output
./gradlew test -Dkarate.options="--debug"

# Run with custom output directory
./gradlew test -Dkarate.options="--output build/karate-reports"
```

## Test Tags and Organization

### Feature Files

Feature files contain your test scenarios written in Gherkin syntax:

```gherkin
@regression
Feature: Sample API Testing

  Background:
    * url 'https://jsonplaceholder.typicode.com'

  @smoke
  Scenario: Get all posts
    Given path '/posts'
    When method GET
    Then status 200
    And match response == '#[100]'
```

### Common Tags

- `@regression` - Full regression test suite
- `@smoke` - Quick smoke tests for basic functionality
- `@api` - API-specific tests
- `@ignore` - Tests to be ignored/skipped
- `@slow` - Long-running tests
- `@critical` - Critical path tests
- `@integration` - Integration tests
- `@unit` - Unit-level tests

### Test Runner

The `TestRunner.java` class defines how tests are executed:

```java
@Karate.Test
Karate testSample() {
    return Karate.run("classpath:sample-api-test.feature");
}

@Karate.Test
Karate testAll() {
    return Karate.run("classpath:").relativeTo(getClass());
}
```

## Writing Tests

### Basic Test Structure

```gherkin
Feature: API Test Description

  Background:
    * url baseUrl
    * configure headers = { 'Content-Type': 'application/json' }

  Scenario: Test scenario description
    Given path '/api/endpoint'
    And request { "key": "value" }
    When method POST
    Then status 201
    And match response.id == '#number'
```

### Karate Keywords and Assertions

#### Common Keywords
- `Given` - Setup preconditions
- `When` - Execute the action
- `Then` - Verify the results
- `And` - Additional steps
- `But` - Negative assertions
- `*` - Generic step (can be used anywhere)

#### Data Validation Examples

```gherkin
# Exact match
And match response.name == 'John Doe'

# Type validation
And match response.id == '#number'
And match response.name == '#string'
And match response.active == '#boolean'
And match response.email == '#? _.length > 0'

# Array validation
And match response == '#[100]'  # Array with exactly 100 elements
And match response == '#[_]'    # Array with any number of elements
And match response[0].id == '#number'

# Optional fields
And match response.optionalField == '#? _ == null || _ == "expected"'

# Regex validation
And match response.email == '#? _.match(/^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$/) != null'

# Array contains
And match response[*].status contains only ['active', 'inactive']
```

#### HTTP Methods and Status Codes

```gherkin
# Different HTTP methods
When method GET
When method POST
When method PUT
When method DELETE
When method PATCH

# Status code validation
Then status 200
Then status 201
Then status 400
Then status 404
Then status 500
```

### Data-Driven Testing

```gherkin
Feature: Data-driven testing

  Scenario Outline: Test multiple users
    Given path '/users'
    And request { "name": "<name>", "email": "<email>" }
    When method POST
    Then status 201
    And match response.name == '<name>'
    And match response.email == '<email>'

    Examples:
      | name | email |
      | John | john@example.com |
      | Jane | jane@example.com |
      | Bob  | bob@example.com |
```

### Using External Data Files

```gherkin
Feature: Using external data

  Scenario: Load test data from file
    * def testData = read('classpath:data/test-users.json')
    * def user = testData[0]
    
    Given path '/users'
    And request user
    When method POST
    Then status 201
```

## Advanced Features

### Parallel Test Execution

```bash
# Run tests in parallel with 4 threads
./gradlew test -Dkarate.options="--threads 4"

# Run specific tags in parallel
./gradlew test -Dkarate.options="--threads 4 --tags @regression"
```

### Custom Configuration

Add custom configuration in `karate-config.js`:

```javascript
function fn() {
  var env = karate.env;
  var config = {
    env: env,
    apiKey: 'your-api-key',
    timeout: 30000,
    retryCount: 3,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    }
  }
  
  if (env == 'dev') {
    config.baseUrl = 'https://jsonplaceholder.typicode.com';
    config.dbUrl = 'jdbc:h2:mem:testdb';
  } else if (env == 'staging') {
    config.baseUrl = 'https://staging-api.example.com';
    config.dbUrl = 'jdbc:postgresql://staging-db:5432/testdb';
  }
  
  return config;
}
```

### Database Testing

```gherkin
Feature: Database integration

  Background:
    * def DbUtils = Java.type('com.example.utils.DbUtils')
    * def db = new DbUtils(dbUrl)

  Scenario: Verify data in database
    * def users = db.readRows('SELECT * FROM users WHERE status = ?', 'active')
    * match users == '#[10]'
    * match users[0].name == '#string'
```

### API Mocking

```gherkin
Feature: API mocking

  Background:
    * def mockPort = karate.start('mock.feature').port
    * url 'http://localhost:' + mockPort

  Scenario: Test with mocked API
    Given path '/mock-endpoint'
    When method GET
    Then status 200
    And match response == { message: 'mocked response' }
```

## Environment Management

### Setting Environment Variables

```bash
# Set environment via system property
export KARATE_ENV=staging
./gradlew test

# Or inline
./gradlew test -Dkarate.env=staging
```

### Custom Configuration

Add custom configuration in `karate-config.js`:

```javascript
var config = {
  env: env,
  apiKey: 'your-api-key',
  timeout: 30000,
  retryCount: 3
}
```

## Reporting

### Test Reports

After running tests, reports are generated in:

- **HTML Report**: `build/reports/tests/test/index.html`
- **Karate Report**: `build/karate-reports/` (if specified)
- **JUnit XML**: `build/test-results/test/`

### View Reports

```bash
# Open HTML report (Mac)
open build/reports/tests/test/index.html

# Open HTML report (Linux)
xdg-open build/reports/tests/test/index.html

# Open HTML report (Windows)
start build/reports/tests/test/index.html
```

### Generate Custom Reports

```bash
# Generate reports in specific directory
./gradlew test -Dkarate.options="--output build/my-reports"
```

## Best Practices

### 1. File Organization

- Group related tests in feature files
- Use descriptive feature and scenario names
- Keep feature files focused on a single API endpoint or functionality

### 2. Test Design

- Use the Background section for common setup
- Write independent, atomic tests
- Use appropriate assertions (`match`, `status`, etc.)
- Implement proper error handling

### 3. Data Management

- Use external data files for test data
- Implement data-driven testing where appropriate
- Don't hard-code sensitive data

### 4. Tagging Strategy

- Use consistent tagging conventions
- Tag tests by functionality, priority, and execution speed
- Use tags to create test suites for different purposes

### 5. Environment Configuration

- Keep environment-specific data in `karate-config.js`
- Use environment variables for sensitive information
- Maintain separate configurations for each environment