---
layout: post
title: "How to Convert Manual Test Cases into Automated Tests"
categories: ["Automation"]
tags: [Manual Testing, Test Automation, Selenium, Java, TestNG, QA, Automated Testing]
description: "A beginner-friendly step-by-step guide to converting manual test cases into maintainable automated tests using Selenium, Java, and TestNG."
image: "https://res.cloudinary.com/dig9gupue/image/upload/v1788970199/how-to-convert-manual-test-cases-into-automated-tests_qzyuve.png" 
---
        

<img 
  src="https://res.cloudinary.com/dig9gupue/image/upload/v1788970199/how-to-convert-manual-test-cases-into-automated-tests_qzyuve.png"
  srcset="
    https://res.cloudinary.com/dig9gupue/image/upload/f_auto,q_auto,w_350/v1788970199/how-to-convert-manual-test-cases-into-automated-tests_qzyuve.png 350w,
    https://res.cloudinary.com/dig9gupue/image/upload/f_auto,q_auto,w_500/v1788970199/how-to-convert-manual-test-cases-into-automated-tests_qzyuve.png 500w,
    https://res.cloudinary.com/dig9gupue/image/upload/f_auto,q_auto,w_700/v1788970199/how-to-convert-manual-test-cases-into-automated-tests_qzyuve.png 700w
  "
  sizes="(max-width: 768px) 100vw, 700px"
  width="700"
  height="500"
  loading="lazy"
  alt="How to Convert Manual Test Cases into Automated Tests"
  fetchpriority="high">
  


Manual testing and automated testing are not competing approaches. In a mature software testing process, they complement each other.

Manual testing is excellent for exploratory testing, usability testing, investigating new features, and situations where human judgment is important. Automation is especially useful when the same predictable test needs to be executed repeatedly.

But moving from manual testing to automation involves more than copying the steps from a test case and turning each one into a line of code.

A good automated test should be:

* Repeatable
* Reliable
* Independent
* Maintainable
* Easy to understand
* Able to determine automatically whether the test passed or failed
* Suitable for repeated execution
* Resistant to reasonable changes in the application

This guide explains how to take a traditional manual test case and systematically transform it into an automated test.

This tutorial uses tools and concepts such as **Java, Selenium WebDriver, TestNG, Maven, Selenium Manager, Page Objects, GitHub Actions, and CI/CD**.

If any of these terms are unfamiliar, don't worry. They are explained as they are introduced throughout the tutorial. You can also refer to the [Appendix: Tools and Concepts Used in This Tutorial](#appendix-tools-and-concepts-used-in-this-tutorial) for quick beginner-friendly definitions.

---

## Table of Contents

1.   *What Does It Mean to Automate a Manual Test Case?*
2.   *Manual Testing vs. Automated Testing*
3.   *Should Every Manual Test Be Automated?*
4.   *Step  1: Understand the Manual Test Case*
5.   *Step  2: Decide Whether the Test Is a Good Automation Candidate*
6.   *Step  3: Separate Preconditions, Actions, and Expected Results*
7.   *Step  4: Prepare the Test Data*
8.   *Step  5: Identify the Application Elements*
9.   *Step  6: Translate Manual Actions into Automation Commands*
10.  *Step  7: Convert Expected Results into Assertions*
11.  *Step  8: Add Synchronization and Explicit Waits*
12.  *Step  9: Add Setup and Cleanup*
13.  *Step 10: Refactor the Test Using Page Objects*
14.  *Step 11: Make the Test Data-Driven*
15.  *Step 12: Add Negative Test Scenarios*
16.  *Step 13: Run the Test Independently*
17.  *Step 14: Add the Test to Continuous Integration*
18.  *Complete Selenium and TestNG Example*
19.  *Manual Test vs. Final Automated Test*
20.  *Common Mistakes When Converting Manual Tests*
21.  *What Should Remain Manual?*
22.  *How to Prioritize a Manual Regression Suite*
23.  *One Manual Test Case May Become Several Automated Tests*
24.  *One Automated Test May Also Replace Many Manual Tests*
25.  *Think in Terms of Test Layers*
26.  *What Changes With Modern Automation Tools?*
27.  *A Practical Conversion Template*
28.  *Automation Conversion Checklist*
29.  *From Manual Tester to Automation Tester*
30.  *Final Example: The Entire Thought Process*
31.  *Final Thoughts*
32.  *[Appendix: Tools and Concepts Used in This Tutorial](#appendix-tools-and-concepts-used-in-this-tutorial)*

---

## 1. What Does It Mean to Automate a Manual Test Case?

Consider the following manual test:

> **Test:** Verify that a registered user can successfully log in.

A manual tester might perform these steps:

1. Open the website.
2. Navigate to the Login page.
3. Enter a valid username.
4. Enter a valid password.
5. Click **Login**.
6. Verify that the dashboard appears.
7. Verify that the user's name is displayed.

At first glance, automation appears simple.

You might translate those steps directly into:
        
1. Open browser
2. Navigate to website
3. Find username field
4. Enter username
5. Find password field
6. Enter password
7. Click Login
8. Verify dashboard
9. Close browser
    
That is the basic idea, but a production-quality automated test must answer several additional questions.

For example:

* Where does the username come from?
* Should a new browser be created for every test?
* How should the test locate the Login button?
* What happens if the dashboard takes three seconds to appear?
* What proves that login actually succeeded?
* How should passwords be stored?
* What happens when the HTML structure changes?
* Can the same login test run with several accounts?
* Can it run unattended in GitHub Actions or another CI system?
* Can another tester understand the test six months from now?

Automating a test case therefore means converting the **intent** of the manual test into reliable executable logic, not simply translating every manual step literally.

---

## 2. Manual Testing vs. Automated Testing

Manual test instructions are written for humans.

Automated tests are written for software.

That distinction is important.

Consider this manual step:

> Verify that the Login page looks correct.

A human tester can interpret "looks correct."

Automation cannot.

The requirement must become measurable.

**For example:**

Verify that:
- the page title is "Login" 
- the username field is visible 
- the password field is visible 
- the Login button is enabled 

These conditions can be evaluated programmatically.

A major part of converting manual tests into automation is therefore converting **subjective instructions into objective conditions**.

---

## 3. Should Every Manual Test Be Automated?

No.

One of the biggest mistakes new automation teams make is assuming that every manual test case should eventually become an automated test.

Automation has development and maintenance costs.

Before automating a test, consider:

| Question                                                  | Good Candidate |
| :-------------------------------------------------------- | :------------: |
| Is the test executed frequently?                          |       Yes      |
| Is the workflow stable?                                   |       Yes      |
| Are the expected results objective?                       |       Yes      |
| Does the test require repetitive steps?                   |       Yes      |
| Is it part of regression testing?                         |       Yes      |
| Does it use predictable test data?                        |       Yes      |
| Must it run across several browsers or data combinations? |       Yes      |
| Does it require human visual judgment?                    |   Usually No   |
| Is the feature changing every few days?                   |   Usually No   |
| Will the test be executed only once?                      |   Usually No   |

### Strong Automation Candidates

Typical examples include:

* Login
* Logout
* Registration
* Search
* Form validation
* Checkout
* CRUD operations
* User permissions
* Navigation
* Regression tests
* Smoke tests
* Repetitive calculations
* Data-driven tests

### Weaker Automation Candidates

Examples may include:

* Exploratory testing
* Early prototypes
* One-time tests
* Subjective usability evaluation
* Visual design review
* CAPTCHA
* Workflows requiring unpredictable third-party interaction

Automation should provide value, not simply increase the number of automated tests.

---

## 4. Step 1 : Understand the Manual Test Case

Never automate a test case you do not understand.

Before writing code, review:

* Purpose
* Preconditions
* Test data
* Test steps
* Expected results
* Business rules
* Cleanup requirements
* Dependencies
* Alternate paths
* Failure scenarios

Consider this example.

### Manual Test Case

**Test Case ID:** LOGIN-001

**Title:** Verify successful login with valid credentials

**Preconditions:**

* User account exists.
* User account is active.
* User is logged out.

**Test Data:**

Username: automation.user@example.com 
Password: valid test password 

**Steps:**

| Step | Action               | Expected Result               |
| ---: | -------------------- | ----------------------------- |
|    1 | Open the application | Home page appears             |
|    2 | Click Login          | Login page appears            |
|    3 | Enter valid username | Username appears in field     |
|    4 | Enter valid password | Password is accepted          |
|    5 | Click Login          | User is authenticated         |
|    6 | View dashboard       | Dashboard appears             |
|    7 | Check account name   | Correct username is displayed |

Before automation begins, confirm that these steps still reflect the actual application.

Automating obsolete manual tests only creates obsolete automated tests.

---

## 5. Step 2 : Decide Whether the Test Is a Good Automation Candidate

Our login test is a strong candidate because it is:

* Repetitive
* Predictable
* Business-critical
* Easy to verify
* Frequently used
* Likely to be included in regression testing

It also has objective pass/fail criteria.

That makes it much more suitable for automation than something such as:

> Verify that the new dashboard is easy to use.

---

## 6. Step 3 : Separate Preconditions, Actions, and Expected Results

Manual tests often mix several types of information together.

For automation, separate them.

### Preconditions

Things that must already be true:

- User account exists
- User account is active
- User is logged out
- Application is available


### Actions

Things the automation performs:

- Open Login page
- Enter username
- Enter password
- Click Login


### Assertions

Things the automation verifies:

- Dashboard URL is displayed
- Dashboard heading is visible
- Correct account name appears

This creates a useful pattern:

**ARRANGE**
Prepare the environment and data

**ACT**
Perform the user actions

**ASSERT**
Verify the result


You may also see this described as:

Given
When
Then

For example:

Given an active registered user
When the user enters valid credentials
Then the dashboard should be displayed

Thinking this way makes automation substantially easier.

---

## 7. Step 4 : Prepare the Test Data

Manual testers frequently type whatever data is convenient during execution.

Automation requires more discipline.

Avoid embedding production credentials directly in the test:

```java
driver.findElement(By.id("email"))
      .sendKeys("realperson@company.com");

driver.findElement(By.id("password"))
      .sendKeys("MyRealPassword123");
```

This creates security and maintenance problems.

Instead, test data can come from:

* Environment variables
* Configuration files
* Test-data factories
* Databases
* APIs
* TestNG DataProviders
* CI/CD secrets
* Dedicated test accounts

For example:

```java
String username = System.getenv("TEST_USERNAME");
String password = System.getenv("TEST_PASSWORD");
```

Sensitive credentials should not normally be committed directly to GitHub.

For a public GitHub repository, this is particularly important.

---

## 8. Step 5 : Identify the Application Elements

A human tester sees:

> Username

Automation sees an HTML element.

For Selenium to interact with the element, it needs a locator.

For example:

```html
<input id="username" name="username" type="email">
```

Selenium could locate it using:

```java
By.id("username")
```

Common Selenium locator strategies include:

```java
By.id()
By.name()
By.className()
By.tagName()
By.linkText()
By.partialLinkText()
By.cssSelector()
By.xpath()
```

For example:

```java
driver.findElement(By.id("username"));
```

or:

```java
driver.findElement(By.cssSelector("[data-testid='username']"));
```

### Prefer Stable Locators

Suppose this button exists:

```html
<button id="login-button" data-testid="login-submit">
    Login
</button>
```

A strong locator might be:

```java
By.id("login-button")
```

or:

```java
By.cssSelector("[data-testid='login-submit']")
```

A fragile locator might look like:

```java
By.xpath("/html/body/div[2]/div/form/div[4]/button")
```

The second locator depends heavily on page structure.

If a developer inserts another `<div>`, the test might fail even though the Login button itself has not changed.

#### Locator Preference

A reasonable general priority is:

<table class="single-box-tools">
<tr>
<td markdown="1">

**Stable unique ID**
↓
**Dedicated test attribute**
↓
**Stable semantic attribute**
↓
**CSS selector**
↓
**Carefully designed XPath**
↓
**Absolute XPath**

</td>
</tr>
</table>

The exact choice depends on the application.

Automation engineers should also work with developers whenever possible to create test-friendly attributes such as:

```html
data-testid="login-submit"
```

---

## 9. Step 6 : Translate Manual Actions into Automation Commands

Now we can begin translating actions.

Manual:

> Open the login page.

Automation:

```java
driver.get("https://example.com/login");
```

Manual:

> Enter username.

Automation:

```java
driver.findElement(By.id("username"))
      .sendKeys(username);
```

Manual:

> Enter password.

Automation:

```java
driver.findElement(By.id("password"))
      .sendKeys(password);
```

Manual:

> Click Login.

Automation:

```java
driver.findElement(By.id("login-button"))
      .click();
```

Combined:

```java
driver.get("https://example.com/login");

driver.findElement(By.id("username"))
      .sendKeys(username);

driver.findElement(By.id("password"))
      .sendKeys(password);

driver.findElement(By.id("login-button"))
      .click();
```

We have automated the actions.

But we do **not yet have a complete test**.

Why?

Because the script has not verified anything.

---

## 10. Step 7 : Convert Expected Results into Assertions

Assertions are one of the most important differences between an automation script and an automated test.

Without assertions, the automation may perform actions without determining whether the application behaved correctly.

Suppose the manual test says:

> Verify that the Dashboard heading appears.

With TestNG:

```java
Assert.assertTrue(
    driver.findElement(By.id("dashboard-heading")).isDisplayed(),
    "Dashboard heading should be displayed"
);
```

If the expected username is displayed:

```java
String actualUsername =
    driver.findElement(By.id("account-name")).getText();

Assert.assertEquals(
    actualUsername,
    "Automation User",
    "Incorrect account name displayed"
);
```

You could also verify the URL:

```java
Assert.assertTrue(
    driver.getCurrentUrl().contains("/dashboard"),
    "User was not redirected to the dashboard"
);
```

### Convert Every Important Expected Result

Manual expected result:

Login page appears.


Possible automation assertion:

```java
Assert.assertEquals(
    driver.getTitle(),
    "Login"
);
```

Manual expected result:

Login button is enabled.

Automation:

```java
Assert.assertTrue(
    driver.findElement(By.id("login-button")).isEnabled()
);
```

Manual expected result:

Error message appears.

Automation:

```java
Assert.assertEquals(
    driver.findElement(By.id("login-error")).getText(),
    "Invalid username or password"
);
```

Whenever you read an expected result in a manual test, ask:

> How can my automation prove that this happened?

---

## 11. Step 8 : Add Synchronization and Explicit Waits

Web applications are asynchronous.

Elements do not always appear immediately.

A beginner may try:

```java
Thread.sleep(5000);
```

This tells the test:

> Wait exactly five seconds whether necessary or not.

That creates several problems.

If the application responds in half a second, four and a half seconds are wasted.

If it takes six seconds, the test still fails.

A better Selenium approach is an explicit wait.

```java
WebDriverWait wait =
    new WebDriverWait(driver, Duration.ofSeconds(10));
```

Then:

```java
WebElement dashboardHeading = wait.until(
    ExpectedConditions.visibilityOfElementLocated(
        By.id("dashboard-heading")
    )
);
```

Now Selenium waits **up to** ten seconds.

If the element appears sooner, execution continues immediately.

### Example

Instead of:

```java
driver.findElement(By.id("login-button")).click();

Thread.sleep(5000);

Assert.assertTrue(
    driver.findElement(By.id("dashboard-heading"))
          .isDisplayed()
);
```

use:

```java
driver.findElement(By.id("login-button")).click();

WebElement dashboardHeading = wait.until(
    ExpectedConditions.visibilityOfElementLocated(
        By.id("dashboard-heading")
    )
);

Assert.assertTrue(dashboardHeading.isDisplayed());
```

This produces faster and generally more reliable tests.

---

## 12. Step 9 : Add Setup and Cleanup

Tests need predictable starting and ending conditions.

TestNG provides annotations for lifecycle management.

For example:

```java
@BeforeMethod
public void setUp() {
    driver = new ChromeDriver();
}
```

and:

```java
@AfterMethod
public void tearDown() {
    if (driver != null) {
        driver.quit();
    }
}
```

A basic test class becomes:

```java
public class LoginTest {

    private WebDriver driver;

    @BeforeMethod
    public void setUp() {
        driver = new ChromeDriver();
    }

    @Test
    public void validUserCanLogin() {

        driver.get("https://example.com/login");

        // Test steps
    }

    @AfterMethod
    public void tearDown() {

        if (driver != null) {
            driver.quit();
        }
    }
}
```

Modern Selenium installations normally use **Selenium Manager** automatically when a driver is required, so typical Selenium projects no longer need the old tutorials that instruct testers to manually download `chromedriver.exe` and hard-code its location.

For example, this is normally sufficient:

```java
WebDriver driver = new ChromeDriver();
```

---

## 13. Step 10 : Refactor the Test Using Page Objects

Our test currently contains all of its Selenium commands directly inside the test method.

That works for a small demonstration.

It becomes difficult to maintain when the automation suite grows.

Suppose you have 50 tests containing:

```java
driver.findElement(By.id("username"));
driver.findElement(By.id("password"));
driver.findElement(By.id("login-button"));
```

Then the development team changes:

```html
id="login-button"
```

to:

```html
id="submit-login"
```

Potentially dozens of tests now require modification.

The **Page Object Model** helps solve this problem.

### Create a LoginPage Class

```java
package pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class LoginPage {

    private final WebDriver driver;

    private final By username =
        By.id("username");

    private final By password =
        By.id("password");

    private final By loginButton =
        By.id("login-button");

    public LoginPage(WebDriver driver) {
        this.driver = driver;
    }

    public void enterUsername(String value) {
        driver.findElement(username).sendKeys(value);
    }

    public void enterPassword(String value) {
        driver.findElement(password).sendKeys(value);
    }

    public void clickLogin() {
        driver.findElement(loginButton).click();
    }

    public void login(String username, String password) {
        enterUsername(username);
        enterPassword(password);
        clickLogin();
    }
}
```

Now the test becomes much easier to read:

```java
LoginPage loginPage = new LoginPage(driver);

loginPage.login(username, password);
```

This reads more like the business workflow than the HTML implementation.

### Create a DashboardPage

```java
package pages;

import java.time.Duration;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class DashboardPage {

    private final WebDriver driver;
    private final WebDriverWait wait;

    private final By dashboardHeading =
        By.id("dashboard-heading");

    private final By accountName =
        By.id("account-name");

    public DashboardPage(WebDriver driver) {

        this.driver = driver;

        this.wait =
            new WebDriverWait(
                driver,
                Duration.ofSeconds(10)
            );
    }

    public boolean isDashboardDisplayed() {

        return wait.until(
            ExpectedConditions
                .visibilityOfElementLocated(
                    dashboardHeading
                )
        ).isDisplayed();
    }

    public String getAccountName() {

        return wait.until(
            ExpectedConditions
                .visibilityOfElementLocated(
                    accountName
                )
        ).getText();
    }
}
```

The test can now focus on **what the user is doing**, while the page classes handle **how Selenium interacts with the page**.

That separation becomes increasingly valuable as the test suite grows.

---

## 14. Step 11 : Make the Test Data-Driven

A manual test suite often contains several nearly identical tests:

1. Login with User A
2. Login with User B
3. Login with User C
4. Login with Administrator


Writing a separate automation method for each data combination creates duplication.

TestNG provides `@DataProvider` for data-driven testing.

Example:

```java
@DataProvider(name = "validUsers")
public Object[][] validUsers() {

    return new Object[][] {

        {"user1@example.com", "password1", "User One"},
        {"user2@example.com", "password2", "User Two"},
        {"admin@example.com", "adminPassword", "Administrator"}

    };
}
```

Then:

```java
@Test(dataProvider = "validUsers")
public void validUsersCanLogin(
        String username,
        String password,
        String expectedName) {

    LoginPage loginPage =
        new LoginPage(driver);

    DashboardPage dashboardPage =
        new DashboardPage(driver);

    driver.get("https://example.com/login");

    loginPage.login(username, password);

    Assert.assertTrue(
        dashboardPage.isDashboardDisplayed()
    );

    Assert.assertEquals(
        dashboardPage.getAccountName(),
        expectedName
    );
}
```

TestNG runs the same test logic using each dataset.

This is often an excellent way to convert repetitive manual test cases.

---

## 15. Step 12 : Add Negative Test Scenarios

Automation should not test only the happy path.

Suppose the manual regression suite contains:

| Scenario       | Username | Password | Expected Result    |
| -------------- | -------- | -------- | ------------------ |
| Valid login    | Valid    | Valid    | Dashboard          |
| Wrong password | Valid    | Invalid  | Error              |
| Unknown user   | Invalid  | Valid    | Error              |
| Empty username | Empty    | Valid    | Validation message |
| Empty password | Valid    | Empty    | Validation message |
| Both empty     | Empty    | Empty    | Validation message |

These can also become automated tests.

Example:

```java
@Test
public void invalidPasswordShowsError() {

    LoginPage loginPage =
        new LoginPage(driver);

    driver.get("https://example.com/login");

    loginPage.login(
        "user@example.com",
        "incorrect-password"
    );

    String errorMessage =
        driver.findElement(
            By.id("login-error")
        ).getText();

    Assert.assertEquals(
        errorMessage,
        "Invalid username or password"
    );
}
```

A larger suite could move these combinations into a DataProvider as well.

---

## 16. Step 13 : Run the Test Independently

Automated tests should generally be independent.

Avoid designs such as:

Test 1: Create account
Test 2: Login using account created by Test 1
Test 3: Edit account used by Test 2
Test 4: Delete account used by Test 3

What happens if Test 1 fails?

Tests 2, 3, and 4 probably fail as well.

You may end up with four failures caused by one problem.

Instead, each test should establish the state it requires whenever reasonably possible.

Conceptually:

**Test A:**
1. Create required data
2. Perform test
3. Verify result
4. Clean up

**Test B**
1. Create required data
2. Perform test
3. Verify result
4. Clean up

Test independence improves:

* Reliability
* Debugging
* Parallel execution
* CI/CD execution
* Reproducibility

For large test suites, application state can sometimes be created more efficiently through an API or database fixture rather than through the user interface.

For example, if you are testing order cancellation, you may not need Selenium to perform a complete 15-screen order-creation process before every cancellation test.

Instead:

**API** → create test order
**Selenium** → cancel order
**Assertion** → verify cancellation
**API** → remove test data

Use UI automation primarily for the behaviour you actually want the UI test to validate.

---

## 17. Step 14 : Add the Test to Continuous Integration

One of the major advantages of automated testing is unattended execution.

Instead of someone manually clicking:

*Run Tests*

every morning, the tests can run automatically when:

* Code is committed
* A pull request is created
* A build is deployed
* A release candidate is created
* A scheduled regression suite runs

For a GitHub project, this can be accomplished with **GitHub Actions**.

A basic Maven workflow might be stored at:

*.github/workflows/test.yml*

Example:

```yaml
name: Automated Tests

on:
  push:
    branches:
      - main

  pull_request:
    branches:
      - main

jobs:

  test:

    runs-on: ubuntu-latest

    steps:

      - name: Checkout repository
        uses: actions/checkout@v6

      - name: Set up Java
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: '17'
          cache: maven

      - name: Run tests
        run: mvn --batch-mode test
```

Now the basic flow becomes:

<table class="single-box">
<tr>
<td markdown="1">

**Developer pushes code**<br>
        ↓<br>
**GitHub Actions starts**<br>
        ↓<br>
**Project is built**<br>
        ↓<br>
**Automated tests execute**<br>
        ↓<br>
**Pass or failure is reported**<br>

</td>
</tr>
</table> 


This is where automation begins delivering much more value than simply replacing repetitive manual clicking.

---

## 18. Complete Selenium and TestNG Example

Let's combine the important pieces.

### BaseTest.java

```java
package tests;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;

public class BaseTest {

    protected WebDriver driver;

    @BeforeMethod
    public void setUp() {

        driver = new ChromeDriver();

        driver.manage().window().maximize();
    }

    @AfterMethod
    public void tearDown() {

        if (driver != null) {
            driver.quit();
        }
    }
}
```

### LoginPage.java

```java
package pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class LoginPage {

    private final WebDriver driver;

    private final By username =
        By.id("username");

    private final By password =
        By.id("password");

    private final By loginButton =
        By.id("login-button");

    public LoginPage(WebDriver driver) {

        this.driver = driver;
    }

    public void enterUsername(String value) {

        driver.findElement(username)
              .sendKeys(value);
    }

    public void enterPassword(String value) {

        driver.findElement(password)
              .sendKeys(value);
    }

    public void clickLogin() {

        driver.findElement(loginButton)
              .click();
    }

    public void login(
            String username,
            String password) {

        enterUsername(username);

        enterPassword(password);

        clickLogin();
    }
}
```

### DashboardPage.java

```java
package pages;

import java.time.Duration;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class DashboardPage {

    private final WebDriver driver;

    private final WebDriverWait wait;

    private final By heading =
        By.id("dashboard-heading");

    private final By accountName =
        By.id("account-name");

    public DashboardPage(WebDriver driver) {

        this.driver = driver;

        this.wait =
            new WebDriverWait(
                driver,
                Duration.ofSeconds(10)
            );
    }

    public boolean isDisplayed() {

        return wait.until(
            ExpectedConditions
                .visibilityOfElementLocated(
                    heading
                )
        ).isDisplayed();
    }

    public String getAccountName() {

        return wait.until(
            ExpectedConditions
                .visibilityOfElementLocated(
                    accountName
                )
        ).getText();
    }
}
```

### LoginTest.java

```java
package tests;

import org.testng.Assert;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

import pages.DashboardPage;
import pages.LoginPage;

public class LoginTest extends BaseTest {

    @DataProvider(name = "validUsers")
    public Object[][] validUsers() {

        return new Object[][] {

            {
                "user1@example.com",
                "password1",
                "User One"
            },

            {
                "user2@example.com",
                "password2",
                "User Two"
            }

        };
    }

    @Test(dataProvider = "validUsers")
    public void validUserCanLogin(
            String username,
            String password,
            String expectedName) {

        driver.get(
            "https://example.com/login"
        );

        LoginPage loginPage =
            new LoginPage(driver);

        DashboardPage dashboardPage =
            new DashboardPage(driver);

        loginPage.login(
            username,
            password
        );

        Assert.assertTrue(
            dashboardPage.isDisplayed(),
            "Dashboard was not displayed"
        );

        Assert.assertEquals(
            dashboardPage.getAccountName(),
            expectedName,
            "Incorrect account name displayed"
        );
    }
}
```

The original manual workflow:

1. Open application
2. Enter username
3 .Enter password
4. Click Login
5. Verify dashboard
6. Verify username

has now become a reusable automated test architecture.

---

## 19. Manual Test vs. Final Automated Test

It helps to compare the transformation.

### Manual Test

**Precondition:**
User account exists.

1. Open Login page.
2. Enter username.
3. Enter password.
4. Click Login.
5. Verify dashboard appears.
6. Verify correct username appears.


### Automated Representation

**SETUP**<br>
Create browser<br><br>

**DATA**<br>
Load test credentials<br><br>

**ACTION**<br>
Open Login page<br><br>

**ACTION**<br>
Enter credentials<br><br>

**ACTION**<br>
Submit form<br><br>

**WAIT**<br>
Wait for dashboard<br><br>

**ASSERT**<br>
Dashboard is visible<br><br>

**ASSERT**<br>
Expected user is displayed<br><br>

**CLEANUP**<br>
Close browser<br><br>


This is the key mental model for converting manual tests into automation.

---

## 20. Common Mistakes When Converting Manual Tests

Simply getting an automated test to run is not enough.

Several common mistakes make automation difficult to maintain.

### Mistake 1 : Translating Every Manual Step Literally

Suppose the manual test says:

1. Open browser.
2. Open Home page.
3. Click Account.
4. Click Login.
5. Enter credentials.

If the actual purpose is testing login, navigating through several unrelated screens may provide no additional value.

Automation can sometimes navigate directly to:

*/login*

Focus on the behaviour being tested.

### Mistake 2 : Using `Thread.sleep()`

Avoid:

```java
Thread.sleep(5000);
```

when the real requirement is:

> Wait until the dashboard becomes visible.

Use an appropriate wait condition instead.

### Mistake 3 : Using Fragile XPath Locators

Avoid unnecessarily structural selectors such as:

```java
/html/body/div/div[2]/div[3]/form/div[2]/button
```

They are easy to break.

Prefer stable identifiers.

### Mistake 4 : Hard-Coding Credentials

Avoid:

```java
String password = "SecretPassword123!";
```

inside source code.

Use controlled test accounts and secure configuration or CI secrets.

### Mistake 5 : Creating One Giant Test

**Avoid:**

1. Register
2. Login
3. Search
4. Add Item
5. Checkout
6. Edit Profile
7. Logout
8. Login Again
9. Delete Account

all within one massive test.

If something fails halfway through, diagnosing the failure becomes difficult.

Create focused tests around meaningful behaviours.

### Mistake 6 : Making Tests Depend on Each Other

Avoid:

*Test B requires Test A to run first.*

Tests should generally be executable independently and in different orders.

### Mistake 7 : Automating an Unstable Feature Too Early

If a user interface changes every day, automation may require constant repair.

It can be more efficient to wait until the workflow becomes reasonably stable.

### Mistake 8 : Automating Without Assertions

**This:**

```java
click();
sendKeys();
click();
```

is automation.

It is not necessarily a test.

A test needs verification.

### Mistake 9 : Testing Implementation Instead of Behaviour

**Suppose the requirement is:**

> User can successfully add a product to the cart.

**The automation should focus on observable behaviour:**

1. Select product
2. Add product
3. Verify product appears in cart

It usually should not be tightly coupled to internal implementation details that the user never sees.

### Mistake 10 : Expecting Zero Maintenance

>Automated tests are software.
>Software requires maintenance.
>Applications change.
>Browsers change.
>Requirements change.
>Test data changes.
>Dependencies change.
>Selectors change.

*A good automation framework reduces maintenance; it does not eliminate it.*

---

## 21. What Should Remain Manual?

Automation does not replace manual testing.

Some testing activities still benefit heavily from human judgment.

### Exploratory Testing

A tester may notice unexpected behaviour that was never included in a scripted test.

### Usability Testing

Questions such as ***Is this workflow confusing?*** are difficult to answer with ordinary functional automation.

### Visual Review

Automation can detect specific visual differences, but humans are still valuable when evaluating overall appearance and usability.

### New Features

When functionality is still changing rapidly, exploratory manual testing may provide more value than immediately creating automation.

### One-Time Tests

If a test will only run once, automation development may cost more than simply performing the test manually.

**The objective should not be:** *Automate everything.*

**A better objective is:** *Automate the repetitive, predictable testing so testers can spend more time on testing that requires investigation and judgment.*

---

## 22. How to Prioritize a Manual Regression Suite

Imagine you inherit 500 manual regression tests.

*Do not start automating Test Case #1 and continue sequentially through Test Case #500.*

Instead, Prioritize them.

One simple approach is to score tests based on:

<table class="single-box">
<tr>
<td markdown="1">

**Business Risk**
+
**Execution Frequency**
+    
**Manual Execution Time**
+
**Repeatability**
+
**Technical Feasibility**
</td>
</tr>
</table>


**For example:**

| Test                            | Frequency     | Risk     | Automation Value |
| ------------------------------- | ------------- | -------- | ---------------- |
| Customer login                  | Every build   | High     | Very High        |
| Checkout                        | Every release | Critical | Very High        |
| Search                          | Every build   | High     | High             |
| Change profile photo            | Monthly       | Low      | Medium           |
| Visual review of marketing page | Occasionally  | Low      | Low              |

Start where automation provides the greatest return.

---

## 23. One Manual Test Case May Become Several Automated Tests

A common misconception is:

1 manual test = 1 automated test

That does not have to be true.

A manual login case might eventually become:

>validUserCanLogin()
>invalidPasswordShowsError()
>unknownUserShowsError()
>emptyUsernameShowsValidation()
>emptyPasswordShowsValidation()
>lockedUserCannotLogin()
>disabledUserCannotLogin()
>userCanLogout()
>sessionExpiresCorrectly()


Automation frequently exposes opportunities to reorganize manual test coverage into smaller, more focused scenarios.

---

## 24. One Automated Test May Also Replace Many Manual Tests

The reverse is also possible.

Suppose the manual suite contains:

>TC-101 Login as administrator
>TC-102 Login as manager
>TC-103 Login as employee
>TC-104 Login as customer

A data-driven automated test could potentially cover all four:

```java
@Test(dataProvider = "users")
public void userCanLogin(
        String username,
        String password,
        String expectedRole) {

    // Same test logic
}
```

This is why automation design should not simply mirror the manual test-management system line by line.

---

## 25. Think in Terms of Test Layers

Not every test needs to execute through a browser.

Suppose you need to validate this business rule:

>Orders greater than $100 receive free shipping.


You could test 30 combinations through the browser.

But that may be slow.

A better architecture might use:

<table class="single-box">
<tr>
<td markdown="1">

**Unit tests**
       ↓
**API tests**
       ↓
**A smaller number of UI tests**

</td>
</tr>
</table> 

**For example:**

<table class="single-box">
<tr>
<td markdown="1">

**Unit/API tests:**
$90
$99.99
$100
$100.01
$150
$500

**UI tests:**
One representative free-shipping scenario
One representative paid-shipping scenario

</td>
</tr>
</table>


UI automation is powerful, but browser-based end-to-end tests are usually more expensive and slower than lower-level automated tests.

Use the right layer for the behaviour you want to verify.

---

## 26. What Changes With Modern Automation Tools?

The basic conversion process remains the same regardless of framework:

<table class="single-box">
<tr>
<td markdown="1">

Manual Test
↓
Identify intent
↓
Identify test data
↓
Identify actions
↓
Identify expected results
↓
Create locators/interactions
↓
Create assertions
↓
Handle synchronization
↓
Run independently
↓
Integrate into CI/CD

</td>
</tr>
</table>

What changes is the syntax.

For example, Selenium might use:

```java
driver.findElement(
    By.id("login-button")
).click();
```

Other tools may use different syntax and different locator approaches.

Modern frameworks increasingly encourage:

* Stable locators
* Automatic synchronization
* Isolated tests
* Parallel execution
* Reusable fixtures
* CI/CD execution
* Trace and diagnostic information
* User-oriented selectors

The framework changes.

The testing principles do not.

---

## 27. A Practical Conversion Template

When you are ready to automate a manual test case, copy this template.

<table class="single-box">
<tr>
<td markdown="1">

**MANUAL TEST CASE**
----------------

Test ID:

Title:

Business purpose:

Preconditions:

Test data:

Manual actions:

Expected results:


AUTOMATION ANALYSIS
-------------------

Should this test be automated?

Why?

Automation layer:
[ ] Unit
[ ] API
[ ] UI
[ ] Combination

Required test data:

Required environment:

Elements/locators:

Setup requirements:

Cleanup requirements:

Actions to automate:

Assertions:

Synchronization requirements:

External dependencies:

Negative scenarios:

Data-driven opportunities:

Page objects/components required:

CI/CD execution:

Potential maintenance risks:

</td>
</tr>
</table>  

This forces you to think about the test as an automation engineer rather than simply translating instructions into code.

---

## 28. Automation Conversion Checklist

Before considering the conversion complete, check the following.

### Test Selection

* [ ] The scenario benefits from automation.
* [ ] The functionality is reasonably stable.
* [ ] The scenario is likely to be executed repeatedly.
* [ ] The expected result can be objectively measured.

### Manual Test Review

* [ ] The manual test is current.
* [ ] Preconditions are documented.
* [ ] Test data is known.
* [ ] Expected results are clear.
* [ ] Business rules are understood.

### Test Design

* [ ] The test has a clear purpose.
* [ ] The test performs only necessary actions.
* [ ] Assertions verify meaningful results.
* [ ] Test data is controlled.
* [ ] Sensitive information is not hard-coded.

### Selenium Design

* [ ] Locators are stable.
* [ ] Absolute XPath is avoided where possible.
* [ ] Appropriate waits are used.
* [ ] Arbitrary sleeps are minimized or eliminated.
* [ ] Page Objects or equivalent abstractions are used where useful.

### Reliability

* [ ] The test can run independently.
* [ ] The test does not rely unnecessarily on another test.
* [ ] Test data does not conflict with parallel tests.
* [ ] Cleanup occurs when necessary.
* [ ] Browser sessions are properly closed.

### Maintainability

* [ ] Repeated logic has been refactored.
* [ ] Test names describe expected behaviour.
* [ ] Code is readable.
* [ ] Page-specific logic is separated from test logic.
* [ ] Test data can be changed without rewriting the entire test.

### Execution

* [ ] The test runs locally.
* [ ] The test produces a clear pass/fail result.
* [ ] Failures are understandable.
* [ ] The test can run from Maven or the project build tool.
* [ ] The test can run in CI/CD.

---

## 29. From Manual Tester to Automation Tester

Learning automation does not mean abandoning manual testing skills.

In fact, strong manual testing skills are extremely valuable when learning automation.

A manual tester already understands concepts such as:

<table class="single-box">
<tr>
<td markdown="1">
        
Requirements
      ↓
Risk
      ↓
Test conditions
      ↓
Test cases
      ↓
Test data
      ↓
Expected results
      ↓
Defects

</td>
</tr>
</table>  

Automation adds another layer:

<table class="single-box">
<tr>
<td markdown="1">

**Requirements**
      ↓
**Risk**
      ↓
**Test conditions**
      ↓
**Test design**
      ↓
**Automation design**
      ↓
**Code**
      ↓
**Execution**
      ↓
**Assertions**
      ↓
**Results**

</td>
</tr>
</table>


The difficult part is often not learning how to write:

```java
element.click();
```

The more valuable skill is knowing:

* What should be clicked
* Why it should be clicked
* What should happen afterward
* How that result can be verified
* Whether the scenario should be automated at all
* How the test can remain reliable six months later

That is where testing knowledge and programming knowledge meet.

---

## 30. Final Example: The Entire Thought Process

Let's finish with a simple example.

### Manual Requirement

> Registered users must be able to log in using valid credentials.

### Manual Test

1. Open the Login page.
2. Enter valid username.
3. Enter valid password.
4. Click Login.
5. Verify Dashboard appears.


### Automation Analysis

#### What Are We Testing?

Authentication through the user interface.

#### Is It Worth Automating?

Yes.

Login is frequently used and business-critical.

#### What Test Data Is Required?

1. Valid test account
2. Valid password
3. Expected display name


#### What UI Elements Are Required?

1. Username input
2. Password input
3. Login button
4. Dashboard heading
5. Account name

#### What Actions Are Required?

1. Open page
2. Enter username
3. Enter password
4. Click Login

#### What Synchronization Is Required?

Wait for the dashboard after submitting the Login form.

#### What Assertions Are Required?

1. Dashboard appears
2. Correct user appears


#### What Reusable Objects Are Appropriate?

1. LoginPage
2. DashboardPage

#### What Setup Is Required?

Create a browser session.

#### What Cleanup Is Required?

Close the browser session.

#### Can It Run Independently?

Yes.

#### Can It Run in CI?

Yes.

We have now converted the test from a human instruction:

>Verify that login works.

into a repeatable automated test with:

<table class="single-box">
<tr>
<td markdown="1">

**Controlled setup**
+
**Controlled test data**
+
**Automated actions**
+
**Synchronization**
+
**Assertions**
+
**Cleanup**
+
**Reusable architecture**
+
**CI/CD capability**

</td>
</tr>
</table> 

That is the real process of converting a manual test case into an automated test.

---

## 31. Final Thoughts

Converting manual tests into automation is not primarily a copy-and-paste exercise.

A manual test tells a human:

> Perform these actions and decide whether the result is correct.

An automated test must instead define exactly:

1. WHAT state is required
2. WHAT data is required
3. WHAT actions should occur
4. WHEN the application is ready
5. WHAT result is expected
6. HOW that result will be measured
7. HOW the test returns to a clean state

A useful transformation is:

<table class="single-box">
<tr>
<td markdown="1">
 
**Manual Test Case**
        ↓
**Understand the intent**
        ↓
**Decide whether automation adds value**
        ↓
**Identify preconditions and test data**
        ↓
**Translate user actions**
        ↓
**Create stable element locators**
        ↓
**Add synchronization**
        ↓
**Convert expected results into assertions**
        ↓
**Separate reusable page logic**
        ↓
**Make tests independent**
        ↓
**Add data-driven coverage where useful**
        ↓
**Run automatically through CI/CD**

</td>
</tr>
</table> 

The most successful automation suites are not necessarily those containing the greatest number of tests.

They are the ones containing tests that are:

* Reliable
* Useful
* Maintainable
* Fast enough
* Easy to diagnose
* Focused on meaningful business risk

The goal of automation is not simply to replace manual execution.

The goal is to create repeatable feedback that helps the development team discover problems faster and gives testers more time to perform the investigative testing that humans do best.

---

## 32. Appendix: Tools and Concepts Used in This Tutorial

Before we begin converting a manual test case into automation, it helps to understand the main tools and concepts used throughout this tutorial.

You do not need to be an expert in any of these before continuing.

### Java

**Java** is the programming language used to write the automated tests in this tutorial.

It is widely used for Selenium-based test automation and has a large ecosystem of testing frameworks, libraries, build tools, and development tools.

For example:

```java
String username = "testuser@example.com";
```

Java provides the programming logic, while tools such as Selenium and TestNG provide specialized testing capabilities.

---

### Selenium WebDriver

**Selenium WebDriver** is a browser automation tool.

It allows automated tests to control browsers such as Chrome, Edge, and Firefox.

Selenium can perform actions that a user would normally perform manually, including:

* Opening a web page
* Clicking buttons
* Entering text
* Selecting options
* Navigating between pages
* Reading information displayed on a page

For example:

```java
driver.get("https://example.com");

driver.findElement(By.id("login-button")).click();
```

Selenium is responsible primarily for interacting with the browser.

---

### TestNG

**TestNG** is a testing framework for Java.

It helps organize, execute, and manage automated tests.

TestNG provides features such as:

* Test annotations
* Assertions
* Setup and cleanup methods
* Data-driven testing
* Test grouping
* Parallel execution
* Test reporting

For example:

```java
@Test
public void validUserCanLogin() {

    // Automated test steps

}
```

TestNG also provides assertions that determine whether the test passed or failed.

For example:

```java
Assert.assertEquals(actualResult, expectedResult);
```

---

### Maven

**Maven** is a Java build and dependency-management tool.

It can:

* Download Selenium
* Download TestNG
* Manage project dependencies
* Compile Java code
* Run automated tests
* Package applications

Instead of manually downloading every library required by your project, Maven stores dependency information inside a file called:

pom.xml


Tests can then be executed using:

```bash
mvn test
```

---

### Selenium Manager

**Selenium Manager** is included with modern versions of Selenium.

It helps automatically manage the browser drivers Selenium needs to communicate with browsers such as:

* Chrome
* Edge
* Firefox

Older Selenium tutorials often instruct users to manually download files such as:

chromedriver.exe

and configure the file path themselves.

For most normal modern Selenium projects, this is no longer necessary.

For example:

```java
WebDriver driver = new ChromeDriver();
```

Selenium Manager can normally locate or obtain the required browser driver automatically.

---

### Page Object Model

The **Page Object Model**, often abbreviated as **POM**, is a way of organizing automation code.

Instead of placing all Selenium locators and browser interactions directly inside your tests, you create classes that represent pages or important parts of the application.

For example:

- LoginPage
- DashboardPage
- SearchPage
- CheckoutPage


A `LoginPage` class could contain:

* Username locator
* Password locator
* Login button locator
* Methods for entering credentials
* Method for submitting the Login form

This keeps page-specific code separate from the actual test logic.

> **Important:** Page Object Model is unrelated to Maven's `pom.xml` file. They both use the abbreviation **POM**, but they refer to completely different concepts.

---

### TestNG DataProvider

A **DataProvider** is a TestNG feature that allows the same automated test to run several times using different sets of test data.

For example, rather than writing three separate login tests, you could provide three sets of credentials:

```java
@DataProvider(name = "users")
public Object[][] users() {

    return new Object[][] {

        {"user1@example.com", "password1"},
        {"user2@example.com", "password2"},
        {"user3@example.com", "password3"}

    };
}
```

The same test can then run once for each user.

This is known as **data-driven testing**.

---

### GitHub Actions

**GitHub Actions** is GitHub's automation and continuous-integration service.

It can automatically perform tasks when something happens in a GitHub repository.

For example:

<table class="single-box">
<tr>
<td markdown="1">
 
**Developer pushes code**
        ↓
**GitHub Actions starts**
        ↓
**Automated tests run**
        ↓
**Results are reported**

</td>
</tr>
</table> 

Tests can automatically run when:

* Code is pushed
* A pull request is created
* A branch is updated
* A schedule is reached

This means testers do not always need to manually start the automation suite.

---

### CI/CD

**CI/CD** commonly stands for:

* **Continuous Integration**
* **Continuous Delivery**
* or **Continuous Deployment**

Continuous Integration means developers regularly merge code changes and automated checks are performed against those changes.

A simplified CI process might look like:

<table class="single-box">
<tr>
<td markdown="1">

**Code change**
    ↓
**Build application**
    ↓
**Run automated tests**
    ↓
**Report result**

</td>
</tr>
</table>  

Automated testing is an important part of CI/CD because it provides rapid feedback about whether a code change introduced a problem.

---

### API

An **API**, or **Application Programming Interface**, allows software systems to communicate directly with each other.

An API does not require a tester to interact with the application's graphical user interface.

In test automation, APIs can sometimes be used to quickly prepare test data.

For example:

<table class="single-box">
<tr>
<td markdown="1">
 
**API**
 ↓
**Create test customer**

**Selenium**
 ↓
**Test customer checkout**

**API**
 ↓
Delete test customer

</td>
</tr>
</table> 

This may be significantly faster than using Selenium to perform every setup and cleanup step through the browser.

---

### Assertion

An **assertion** is a check that compares the actual behaviour of the application with the expected behaviour.

For example:

```java
Assert.assertEquals(
    actualUsername,
    "Automation User"
);
```

If the actual and expected values match, the assertion passes.

If they do not match, the test fails.

Assertions are extremely important because they allow the automation to determine whether the application behaved correctly.

---

### Locator

A **locator** tells Selenium how to find an element on a web page.

For example:

```java
By.id("username")
```

tells Selenium to find the element whose HTML `id` is:

username


Common Selenium locator types include:

- ID
- Name
- Class Name
- CSS Selector
- XPath
- Link Text
- Partial Link Text
- Tag Name

Choosing stable locators is one of the most important parts of creating reliable Selenium tests.

---

### Explicit Wait

An **explicit wait** tells Selenium to wait until a particular condition occurs.

For example:

```java
wait.until(
    ExpectedConditions.visibilityOfElementLocated(
        By.id("dashboard-heading")
    )
);
```

Selenium waits until the Dashboard heading becomes visible, or until the configured timeout is reached.

This is generally better than using a fixed delay such as:

```java
Thread.sleep(5000);
```

because an explicit wait continues as soon as the required condition becomes true.

---

### How the Main Tools Work Together

The easiest way to understand the main tools is:

<table class="single-box-tools">
<tr>
<td markdown="1">

**Java**  
↓  
Programming language used to write the tests

**Selenium**  
↓  
Controls the web browser

**TestNG**  
↓  
Organizes tests and determines pass/fail results

**Maven**  
↓  
Manages dependencies and runs the project

**GitHub Actions**  
↓  
Runs the tests automatically in CI/CD

</td>
</tr>
</table>
 
You do not need to memorize all of these tools now.

As you work through the examples, their roles will become much clearer.

---

<style>
.single-box-tools {
  width: 100% !important;
  border: 4px solid #c9b98f !important;
  border-radius: 20px !important;
  background-color: #fffaf0 !important;
}

.single-box-tools td {
  padding: 18px 22px;
  background-color: #fffaf0;
  border: none;
  text-align: center;
}
</style>

