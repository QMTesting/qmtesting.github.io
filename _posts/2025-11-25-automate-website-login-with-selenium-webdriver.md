---
layout: post
title: "Learn How to Automate a Website Login with Selenium WebDriver"
categories: ["Automation"]
image: /assets/images/Auto/selenium-testing-automation.webp
permalink: /automate-website-login-with-selenium-webdriver/
tags: [software testing, QA, QC, automation, testing tools, AI]
description: "A guide on how to automate a website login with Selenium WebDriver."
---

<figure>
  <img src="/assets/images/Auto/selenium-testing-automation.webp" alt="Automate a Login with Selenium WebDriver" />
  <figcaption>Image by macrovector_official on Freepik</figcaption>
</figure>

## Introduction

Automating repetitive website tasks, such as logging into web applications, can save huge amounts of time and reduce human error. Selenium WebDriver is one of the most powerful and popular tools for browser automation, used by developers, QA testers, and anyone looking to streamline workflows.

In this beginner‑friendly guide, you’ll learn:

* What Selenium WebDriver is
* How to set up your environment
* How to automate a website login using Java and Selenium WebDriver
* How to use best practices like explicit waits
* A TestNG version of the login script
* How to validate successful logins
* A step‑by‑step tutorial with screenshot references

Let’s get started!

## What Is Selenium WebDriver?

Selenium WebDriver is an open‑source tool that automates browser actions the same way a human user would. It supports multiple programming languages—including Java, Python, C#, and JavaScript—and works across all major browsers.

### Key Features

* **Automated web testing**: Click buttons, submit forms, navigate pages.
* **Headless execution**: Run tests without opening a browser window.
* **Cross‑browser support**: Chrome, Firefox, Edge, Safari, Opera.
* **Mobile automation**: Via Appium.
* **Rich locator strategies**: IDs, names, CSS selectors, XPath, and more.

### Selenium Components

* **WebDriver** – Core automation engine
* **Selenium IDE** – Record/playback for beginners
* **Selenium Grid** – Run tests on multiple machines and browsers in parallel

## Pre‑Setup Requirements

Before writing your first login script, you must complete the following setup.

### ✓ Step 1: Install JDK (Java Development Kit)

Download from Oracle or Adoptium, then configure `JAVA_HOME` in system environment variables.

### ✓ Step 2: Install Eclipse IDE

Any IDE works, but Eclipse is beginner‑friendly.

### ✓ Step 3: Install Selenium WebDriver

Download the Selenium Java client libraries (ZIP) and add them to your project’s **Referenced Libraries**.

### ✓ Step 4: Install ChromeDriver

Download ChromeDriver matching your Chrome version.

> Tip: Chrome now supports built‑in driver management, making setup easier.

### ✓ Step 5: Create a Java Project in Eclipse

Add Selenium JAR files + WebDriver dependencies.

At this point, your environment is ready.

## Selenium Login Test Script

Below is a login automation script using Java and Selenium.

```java
package PackageLogin;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.ExpectedConditions;
import java.time.Duration;

public class ClassLogin {

    public static void main(String[] args) {

        // Set path for ChromeDriver
        System.setProperty("webdriver.chrome.driver", "C:\\ChromeDriver_binary\\chromedriver.exe");

        // Initialize WebDriver
        WebDriver driver = new ChromeDriver();

        try {
            // Open login page
            driver.get("https://your-app-login-url.com"); // Replace with your URL
            driver.manage().window().maximize();

            // Locate and fill username
            WebElement usernameField = driver.findElement(By.id("username"));
            usernameField.sendKeys("yourUsername");

            // Locate and fill password
            WebElement passwordField = driver.findElement(By.id("password"));
            passwordField.sendKeys("yourPassword123");

            // Locate and click login button
            WebElement loginButton = driver.findElement(By.name("LOGIN"));
            loginButton.click();
            System.out.println("Clicked login");

            // Explicit wait for login success
            WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
            wait.until(ExpectedConditions.titleContains("Successful Login"));

            if (driver.getTitle().contains("Successful Login")) {
                System.out.println("Login Successful!");
            } else {
                System.out.println("Login Failed!");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Close browser
            driver.quit();
        }
    }
}
```

### ✔ Fixes Included

* Corrected the locator name (`username`, not `usename`)
* Replaced `Thread.sleep()` with **WebDriverWait** (industry best practice)
* Fixed output message
* Ensured consistent locator strategy
* Clean, readable code for beginners


## Step‑By‑Step Walkthrough

Below are the steps you can visually represent in your blog using screenshots.

You may add images such as:

* ✔ Screenshot of Eclipse project structure
* ✔ Screenshot of the login page used
* ✔ Screenshot highlighting username/password input fields
* ✔ Console output after script execution

These can be created manually using your own browser and IDE.


## Locating Web Elements

To interact with elements, Selenium provides locator strategies:

| Locator Type     | Example                               | When to Use                  |
| ---------------- | ------------------------------------- | ---------------------------- |
| **ID**           | `By.id("username")`                   | Most reliable and preferred  |
| **Name**         | `By.name("LOGIN")`                    | Good when ID isn’t available |
| **CSS Selector** | `By.cssSelector("#username")`         | Flexible, fast               |
| **XPath**        | `By.xpath("//input[@id='username']")` | Complex or dynamic elements  |


## Common Challenges (And Solutions)

### CAPTCHA

Cannot be automated—intentionally. Use test environments without CAPTCHA.

### Dynamic Elements

Use **Explicit Waits** for AJAX‑loaded content.

### Browser Driver Issues

Chrome versions frequently update—use WebDriverManager or built‑in driver support.


## TestNG Version of the Login Script

```java
package PackageLogin;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.testng.Assert;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import java.time.Duration;

public class ClassLoginTestNG {

    WebDriver driver;

    @BeforeMethod
    public void setup() {
        System.setProperty("webdriver.chrome.driver", "C:\\ChromeDriver_binary\\chromedriver.exe");
        driver = new ChromeDriver();
        driver.manage().window().maximize();
    }

    @Test
    public void loginTest() {
        driver.get("https://your-app-login-url.com");

        driver.findElement(By.id("username")).sendKeys("yourUsername");
        driver.findElement(By.id("password")).sendKeys("yourPassword123");
        driver.findElement(By.name("LOGIN")).click();

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        wait.until(ExpectedConditions.titleContains("Successful Login"));

        Assert.assertTrue(driver.getTitle().contains("Successful Login"), "Login was not successful");
    }

    @AfterMethod
    public void teardown() {
        driver.quit();
    }
}
```

### Why Use TestNG?

* Built‑in reporting
* Annotations (BeforeMethod, AfterMethod)
* Automatic assertions
* Supports parallel testing
* Better for real‑world test automation


## Conclusion

Selenium WebDriver is a powerful and flexible tool for automating browser interactions. Whether you’re logging into a website, testing user flows, or running regression tests, Selenium helps eliminate repetitive manual work while improving accuracy.

By following the steps in this guide and using the improved, modern scripts, you now have:

* A fully functioning login automation script
* A TestNG‑based version for advanced testing
* An understanding of locators, waits, and best practices
* A well‑structured workflow for building more complex automated tests

If you’d like, I can also create:

* A downloadable PDF version of this tutorial
* A version styled specifically for Jekyll or Blogger
* Additional examples (logout, two‑step login, data‑driven login)
