# Learn How to Set Up Selenium with Java in Eclipse – 2026 Beginner Guide

[Automation with Selenium WebDriver for Eclipse](https://qmstesting.com/assets/images/Auto/Eclipse-java.webp)

*Image on Freepik*

## Introduction

Selenium WebDriver is one of the most widely used tools for automating web browser testing. If you are beginning a career in software testing or learning test automation for the first time, Selenium with Java is an excellent place to start.

This tutorial explains how to install and configure **Selenium WebDriver with Java and Eclipse using the current 2026 approach**.

The setup process has become much easier than it was several years ago. Older Selenium tutorials often tell you to:

* download Selenium `.jar` files manually;
* add dozens of JAR files to the Eclipse Build Path;
* download ChromeDriver separately;
* make sure ChromeDriver matches the installed Chrome version;
* add ChromeDriver to the Windows `PATH`;
* configure `webdriver.chrome.driver` inside your Java code; or
* download additional logging libraries such as SLF4J.

For a normal Selenium project, **you no longer need to do any of these things**.

Instead, we will use:

* **Java Development Kit (JDK) 25 LTS**
* **Eclipse IDE for Java Developers**
* **Apache Maven**
* **Selenium WebDriver 4**
* **Selenium Manager**
* **JUnit**
* **Google Chrome**

Maven will automatically download Selenium and the other Java libraries your project needs.

Selenium Manager, which is included with Selenium, will normally detect your browser and automatically obtain the correct browser driver.

By the end of this tutorial, you will have created a real automated browser test that:

1. launches Google Chrome;
2. opens a test webpage;
3. locates a text field;
4. enters text;
5. clicks a button;
6. verifies the result using an assertion; and
7. closes the browser.

No previous Selenium experience is required.

---

# What Is Selenium WebDriver?

**Selenium WebDriver** is an open-source browser automation tool.

It allows a program to control a web browser in much the same way that a person would.

For example, Selenium can:

* open a browser;
* navigate to a URL;
* click links and buttons;
* enter information into forms;
* select checkboxes and dropdown lists;
* read text displayed on a webpage;
* switch between browser windows and tabs;
* work with alerts;
* upload files;
* take screenshots;
* verify that expected information appears;
* test applications using different browsers; and
* run automated regression tests.

A manual tester might perform the following test:

> Open the website, enter a username and password, click **Login**, and verify that the dashboard appears.

A Selenium test can perform those same actions automatically.

---

# What Selenium Is — and Is Not

It is helpful for beginners to understand what Selenium actually does.

Selenium is primarily designed for **web browser automation**.

It is particularly useful for:

* functional testing;
* regression testing;
* browser compatibility testing;
* automated UI testing;
* repetitive browser testing; and
* end-to-end web testing.

Selenium itself is **not**:

* a test management system;
* an API testing tool;
* a performance/load testing tool;
* a defect tracking system; or
* a complete testing framework.

That is why Selenium is often combined with other tools.

For this tutorial, for example, we will combine:

**Selenium + Java + Maven + JUnit + Eclipse**

Each has a different purpose.

| Tool               | Purpose                                               |
| :----------------- | :---------------------------------------------------- |
| Java               | Programming language used to write the tests          |
| Eclipse            | IDE used to write, organize, run, and debug Java code |
| Maven              | Manages project dependencies and builds               |
| Selenium WebDriver | Controls the web browser                              |
| Selenium Manager   | Automatically manages browser drivers                 |
| JUnit              | Runs tests and provides assertions                    |

---

# Selenium WebDriver Advantages

Selenium remains popular with software testers for several reasons.

### Multiple Browser Support

Selenium supports major browsers including:

* Google Chrome;
* Mozilla Firefox;
* Microsoft Edge; and
* Safari.

This allows testers to execute similar automated tests against multiple browsers.

### Cross-Platform Support

Selenium can be used on major operating systems such as:

* Windows;
* macOS; and
* Linux.

### Multiple Programming Languages

Selenium provides official language bindings including:

* Java;
* Python;
* C#;
* JavaScript;
* Ruby; and
* Kotlin through the Java ecosystem.

This tutorial uses **Java**.

### Open Source

Selenium is open-source and free to use.

### Integration with Testing Frameworks

Java Selenium projects can be combined with frameworks such as:

* JUnit;
* TestNG; and
* Cucumber.

### Integration with Build and CI/CD Tools

Selenium tests can eventually be incorporated into tools and platforms such as:

* Maven;
* Gradle;
* Jenkins;
* GitHub Actions;
* GitLab CI/CD;
* Azure DevOps; and
* other continuous integration systems.

### Parallel Testing

More advanced Selenium frameworks can execute multiple tests at the same time, significantly reducing the amount of time required for a large regression suite.

### Real Browser Interaction

Selenium drives real browsers, allowing automated tests to interact with webpages similarly to users.

---

# Selenium Setup Overview for 2026

We will complete the setup in the following order:

1. Install Java JDK.
2. Verify Java.
3. Configure `JAVA_HOME` if necessary.
4. Install Eclipse IDE.
5. Verify Eclipse is using the correct JDK.
6. Create a Maven project.
7. Add Selenium to `pom.xml`.
8. Add JUnit to `pom.xml`.
9. Allow Maven to download the dependencies.
10. Create a Java test class.
11. Write your first Selenium test.
12. Run the test.
13. Understand what the code does.
14. Learn how Selenium Manager handles ChromeDriver.
15. Troubleshoot common beginner problems.

---

# Step 1: Install the Java Development Kit

Selenium's Java bindings require Java.

Java source code is written in `.java` files and compiled into bytecode that runs on the Java Virtual Machine.

To develop Selenium tests, install a **Java Development Kit (JDK)** rather than trying to install a separate Java Runtime Environment.

## Which Java Version Should You Use in 2026?

For a beginner starting a new Selenium Java project in 2026, **JDK 25 LTS** is a sensible choice.

LTS means **Long-Term Support**.

Although newer non-LTS Java releases may also be available, an LTS release is usually preferable for learning and for projects that you expect to maintain over time.

Download the JDK from the official Oracle Java downloads page:

[Oracle Java Downloads](https://www.oracle.com/java/technologies/downloads/)

Other OpenJDK distributions can also be used, but this tutorial assumes Oracle JDK.

---

## Install JDK 25 on Windows

On the Java download page:

1. Locate **JDK 25**.
2. Select **Windows**.
3. Select the **x64 Installer** if you are using a normal Intel or AMD 64-bit Windows PC.
4. Download the installer.
5. Double-click the downloaded file.
6. Allow Windows to run the installer if prompted.
7. Click **Next**.
8. Keep the default installation directory unless you have a reason to change it.
9. Continue through the installation.
10. Click **Close** when installation finishes.

The installation directory will normally resemble:

```text
C:\Program Files\Java\jdk-25
```

The exact directory may vary depending on the JDK distribution and version you install.

---

# Step 2: Verify the Java Installation

Before installing Selenium or creating a project, verify that Windows can find Java.

Open **Command Prompt**.

You can do this by:

1. pressing the Windows key;
2. typing `cmd`; and
3. selecting **Command Prompt**.

Enter:

```bash
java -version
```

You should see information showing the installed Java version.

Next enter:

```bash
javac -version
```

`java` runs Java programs.

`javac` is the Java compiler.

Seeing responses from both commands confirms that the JDK is available.

---

# Step 3: Configure JAVA_HOME on Windows

Depending on the Java installer you use, Java may already be configured correctly.

If:

```bash
java -version
```

and:

```bash
javac -version
```

both work, you can often continue without making additional changes.

However, Maven and other Java development tools commonly use the `JAVA_HOME` environment variable, so it is useful to configure it correctly.

## Find the JDK Directory

For example:

```text
C:\Program Files\Java\jdk-25
```

Do **not** include `\bin` in `JAVA_HOME`.

Correct:

```text
C:\Program Files\Java\jdk-25
```

Incorrect:

```text
C:\Program Files\Java\jdk-25\bin
```

---

## Create JAVA_HOME

In Windows:

1. Open the Windows search box.
2. Search for **environment variables**.
3. Select **Edit the system environment variables**.
4. Select **Environment Variables**.
5. Under **System variables**, select **New**.

Enter:

```text
Variable name:
JAVA_HOME
```

For the value, enter your JDK installation directory. For example:

```text
C:\Program Files\Java\jdk-25
```

Click **OK**.

---

## Add Java to PATH

Still under **System variables**:

1. locate `Path`;
2. select it;
3. click **Edit**;
4. click **New**; and
5. enter:

```text
%JAVA_HOME%\bin
```

Click **OK** until all windows are closed.

Do not delete your existing `PATH` entries.

---

## Verify JAVA_HOME

Close any Command Prompt window you already have open.

Open a **new** Command Prompt.

Enter:

```bat
echo %JAVA_HOME%
```

You should see your JDK directory.

Then run:

```bash
java -version
```

and:

```bash
javac -version
```

again.

If all three commands work, Java is ready.

---

# Step 4: Install Eclipse IDE

Next we need an Integrated Development Environment, or **IDE**.

An IDE provides tools for:

* writing Java code;
* organizing Java projects;
* detecting syntax errors;
* running tests;
* debugging tests;
* managing Maven dependencies;
* viewing project files; and
* working with Git.

For this tutorial we will use **Eclipse IDE for Java Developers**.

The 2026 Eclipse Java package already includes Maven integration, which is important because we will use Maven to manage Selenium.

---

## Download Eclipse

Go to the official Eclipse website and download the current stable **Eclipse IDE for Java Developers** package appropriate for your operating system.

On Windows, most modern computers use the **x86_64** version.

Avoid milestone, development, or release-candidate builds when you are a beginner. Choose the current stable release.

---

## Install Eclipse

Run the Eclipse installer.

When presented with the available packages, select:

**Eclipse IDE for Java Developers**

Continue with the installation.

The default installation settings are normally appropriate for a beginner.

After the installation completes, click:

**Launch**

---

# Step 5: Select an Eclipse Workspace

The first time Eclipse starts, you will be asked to select a **workspace**.

A workspace is a directory where Eclipse stores projects and workspace configuration.

For example:

```text
C:\Users\YourName\eclipse-workspace
```

The default is fine.

You may select:

**Use this as the default and do not ask again**

if you intend to use the same workspace regularly.

Click:

**Launch**

Eclipse will open.

If you see the Welcome screen, you can close it to display the main workspace.

---

# Step 6: Verify That Eclipse Is Using Your JDK

Before creating the Selenium project, verify Eclipse recognizes the Java installation.

In Eclipse:

1. select **Window**;
2. select **Preferences**;
3. expand **Java**;
4. select **Installed JREs**.

Your installed JDK should appear.

Although Eclipse calls this screen **Installed JREs**, it can point to a full JDK.

If JDK 25 appears and is checked, you are ready.

If it does not:

1. click **Add**;
2. select **Standard VM**;
3. click **Next**;
4. browse to the JDK directory, for example:

```text
C:\Program Files\Java\jdk-25
```

5. finish the configuration; and
6. make sure the JDK is selected.

Click:

**Apply and Close**

---

# Step 7: Why We Will Use Maven

At this point, older Selenium tutorials often instruct users to download a ZIP file containing Selenium Java libraries.

They then tell you to add numerous `.jar` files manually to Eclipse.

That approach is no longer recommended for a normal beginner project.

We will use **Maven** instead.

Maven is a Java build and dependency-management tool.

Instead of downloading Selenium libraries yourself, you declare Selenium as a dependency inside a file named:

```text
pom.xml
```

Maven then:

1. reads the dependency;
2. determines which libraries Selenium requires;
3. downloads them;
4. stores them locally;
5. adds them to the project classpath; and
6. makes them available to your Java code.

This makes projects much easier to:

* create;
* maintain;
* update;
* share with other testers;
* store in Git;
* run on another computer; and
* execute from CI/CD systems.

---

# Step 8: Create a Maven Project in Eclipse

In Eclipse, select:

**File > New > Maven Project**

If **Maven Project** does not appear immediately, select:

**File > New > Other**

Then expand:

```text
Maven
```

and select:

```text
Maven Project
```

Click **Next**.

---

## Create a Simple Project

For a beginner tutorial, select:

```text
Create a simple project (skip archetype selection)
```

Then click:

**Next**

You will now enter the Maven project information.

---

## Group ID

The **Group Id** normally identifies your organization, company, or project namespace.

For this tutorial enter:

```text
com.qmstesting
```

---

## Artifact ID

The **Artifact Id** is essentially the project name.

Enter:

```text
selenium-beginner
```

Leave the packaging type as:

```text
jar
```

You can enter a project name such as:

```text
Selenium Beginner Project
```

Click:

**Finish**

---

# Step 9: Understand the Maven Project Structure

Eclipse should create a project containing files and directories similar to:

```text
selenium-beginner
│
├── src/main/java
├── src/main/resources
├── src/test/java
├── src/test/resources
│
└── pom.xml
```

The two most important items for now are:

```text
src/test/java
```

and:

```text
pom.xml
```

### `src/test/java`

This directory will contain our automated test classes.

### `pom.xml`

This file describes the Maven project and its dependencies.

We will add Selenium and JUnit here.

---

# Step 10: Add Selenium WebDriver to pom.xml

Double-click:

```text
pom.xml
```

If Eclipse opens a graphical Maven editor, select the:

**pom.xml**

or **Source**

tab near the bottom so you can edit the XML directly.

Replace the contents with the following:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         https://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>com.qmstesting</groupId>
    <artifactId>selenium-beginner</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.release>25</maven.compiler.release>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>

        <!-- Selenium WebDriver -->
        <dependency>
            <groupId>org.seleniumhq.selenium</groupId>
            <artifactId>selenium-java</artifactId>
            <version>4.48.0</version>
        </dependency>

        <!-- JUnit -->
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>6.1.2</version>
            <scope>test</scope>
        </dependency>

    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.5.4</version>
            </plugin>
        </plugins>
    </build>

</project>
```

Save the file using:

```text
Ctrl + S
```

---

# What Did We Just Add?

This is worth understanding rather than simply copying the code.

## Selenium Dependency

This section tells Maven that our project needs Selenium:

```xml
<dependency>
    <groupId>org.seleniumhq.selenium</groupId>
    <artifactId>selenium-java</artifactId>
    <version>4.48.0</version>
</dependency>
```

Instead of downloading Selenium JAR files ourselves, Maven downloads them automatically.

It also downloads Selenium's required dependencies.

---

## JUnit Dependency

This section adds JUnit:

```xml
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <version>6.1.2</version>
    <scope>test</scope>
</dependency>
```

JUnit gives us features such as:

```java
@Test
```

and assertions such as:

```java
assertEquals()
```

These allow us to create actual automated **tests**, rather than simply creating scripts that control a browser.

---

# Step 11: Update the Maven Project

Eclipse will normally detect changes to `pom.xml`.

To make sure all dependencies are downloaded:

1. right-click your project;
2. select **Maven**;
3. select **Update Project**.

Make sure your project is selected.

Click:

**OK**

Maven may need a little time on the first run because it must download Selenium, JUnit, and their dependencies.

When complete, you should see:

```text
Maven Dependencies
```

under your project.

Expand it and you will see numerous JAR files.

The important difference is that **Maven manages these files for you**.

Do not manually add them to the Eclipse Build Path.

---

# Step 12: Install Google Chrome

For this tutorial we will use Google Chrome.

If Chrome is already installed and working normally, you do not need to do anything.

You **do not normally need to download ChromeDriver**.

That is one of the most important differences between modern Selenium and older tutorials.

Selenium includes a feature called **Selenium Manager**, which handles this automatically.

We will explain Selenium Manager in more detail shortly.

---

# Step 13: Create Your Test Package

In Eclipse, locate:

```text
src/test/java
```

Right-click it and select:

**New > Package**

Enter:

```text
com.qmstesting.tests
```

Click:

**Finish**

Using lowercase package names is standard Java naming practice.

Your project should now resemble:

```text
selenium-beginner
└── src/test/java
    └── com.qmstesting.tests
```

---

# Step 14: Create Your First Selenium Test Class

Right-click:

```text
com.qmstesting.tests
```

Select:

**New > Class**

Enter the class name:

```text
FirstSeleniumTest
```

Click:

**Finish**

Eclipse will create something similar to:

```java
package com.qmstesting.tests;

public class FirstSeleniumTest {

}
```

---

# Step 15: Write Your First Selenium Test

Replace the class contents with:

```java
package com.qmstesting.tests;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;

public class FirstSeleniumTest {

    WebDriver driver;

    @Test
    void submitWebFormTest() {

        driver = new ChromeDriver();

        driver.get("https://www.selenium.dev/selenium/web/web-form.html");

        driver.manage().window().maximize();

        WebElement textBox = driver.findElement(By.name("my-text"));
        WebElement submitButton =
                driver.findElement(By.cssSelector("button"));

        textBox.sendKeys("Selenium");

        submitButton.click();

        WebElement message =
                driver.findElement(By.id("message"));

        assertEquals("Received!", message.getText());
    }

    @AfterEach
    void tearDown() {

        if (driver != null) {
            driver.quit();
        }
    }
}
```

Save the file.

You have now created your first Selenium automated test.

---

# Step 16: Run the Selenium Test

Right-click anywhere inside:

```text
FirstSeleniumTest.java
```

Select:

**Run As > JUnit Test**

Several things should happen.

Chrome should:

1. launch;
2. navigate to the Selenium test webpage;
3. locate the text field;
4. enter `Selenium`;
5. click the submit button;
6. verify that `Received!` appears; and
7. close.

The JUnit view in Eclipse should show the test as successful.

A successful test normally appears with a green status indicator.

Congratulations — you have created and executed your first Selenium automated browser test.

---

# Step 17: Understand the Selenium Code

Running code that you do not understand is not very useful, so let's examine it piece by piece.

---

## Import WebDriver

```java
import org.openqa.selenium.WebDriver;
```

`WebDriver` is the primary Selenium interface used to communicate with the browser.

We declare:

```java
WebDriver driver;
```

Think of `driver` as our connection to the browser.

---

# Create ChromeDriver

```java
driver = new ChromeDriver();
```

This tells Selenium that we want to automate Google Chrome.

In older Selenium versions, this often required something like:

```java
System.setProperty(
    "webdriver.chrome.driver",
    "C:\\drivers\\chromedriver.exe");
```

That normally should **not** be necessary today.

When Selenium sees:

```java
new ChromeDriver();
```

it can use Selenium Manager to locate the required ChromeDriver automatically.

---

# Navigate to a Website

```java
driver.get(
    "https://www.selenium.dev/selenium/web/web-form.html");
```

This tells the browser to navigate to the specified URL.

The equivalent manual action would be typing the address into Chrome and pressing Enter.

---

# Maximize the Browser

```java
driver.manage().window().maximize();
```

This maximizes the browser window.

This step is not required for every Selenium test, but it can make the browser easier to watch while learning.

---

# Locate the Text Box

```java
WebElement textBox =
        driver.findElement(By.name("my-text"));
```

A `WebElement` represents an element on a webpage.

Examples of web elements include:

* buttons;
* text boxes;
* links;
* checkboxes;
* dropdown lists;
* headings;
* images; and
* tables.

Here Selenium searches for an HTML element whose `name` attribute is:

```text
my-text
```

---

# Enter Text

```java
textBox.sendKeys("Selenium");
```

`sendKeys()` simulates keyboard input.

Selenium enters:

```text
Selenium
```

into the text box.

---

# Locate the Submit Button

```java
WebElement submitButton =
        driver.findElement(By.cssSelector("button"));
```

This example uses a CSS selector.

It searches for a:

```html
<button>
```

element.

---

# Click the Button

```java
submitButton.click();
```

The `click()` method performs a mouse-click action on the element.

This is similar to a user manually clicking the button.

---

# Find the Result Message

```java
WebElement message =
        driver.findElement(By.id("message"));
```

This time Selenium finds an element using its HTML `id`.

The locator:

```java
By.id("message")
```

means:

> Find the element whose `id` attribute is `message`.

---

# Verify the Result

```java
assertEquals("Received!", message.getText());
```

This is where JUnit performs the actual test verification.

We expect the webpage to display:

```text
Received!
```

`message.getText()` obtains the actual text displayed by the webpage.

JUnit then compares:

```text
Expected: Received!
Actual:   value returned by the webpage
```

If they match, the assertion passes.

If they do not match, the test fails.

This is a very important concept in test automation:

> **Automation should verify results, not simply perform actions.**

A script that clicks buttons without checking the outcome is not providing much testing value.

---

# Close the Browser

Our cleanup method is:

```java
@AfterEach
void tearDown() {

    if (driver != null) {
        driver.quit();
    }
}
```

`@AfterEach` tells JUnit to run this method after every test.

The command:

```java
driver.quit();
```

closes the browser and ends the Selenium session.

Using `quit()` is important because otherwise browser and driver processes may remain running after the test finishes.

---

# Step 18: Understanding Selenium Manager

One of the most significant improvements to modern Selenium is **Selenium Manager**.

Years ago, setting up Chrome automation required testers to:

1. determine their Chrome version;
2. find a compatible ChromeDriver version;
3. download ChromeDriver;
4. extract `chromedriver.exe`;
5. place it in a directory;
6. add the directory to `PATH` or specify it in Java; and
7. repeat the process when Chrome updated.

This was one of the most frustrating parts of learning Selenium.

Modern Selenium normally manages this process automatically.

When this code executes:

```java
WebDriver driver = new ChromeDriver();
```

Selenium can determine that Chrome requires a driver.

Selenium Manager can then:

1. detect the installed browser;
2. determine the appropriate driver version;
3. download the required driver if it is missing;
4. cache it locally; and
5. allow Selenium to start the browser.

The same concept also applies to other supported browsers.

Therefore, in a normal Selenium 4 project, you should **not start by manually downloading ChromeDriver**.

---

# What Happens the First Time Selenium Runs?

The first test execution may take slightly longer than later executions.

That is normal.

Selenium Manager may need Internet access to locate and download a browser driver.

After downloading it, Selenium stores the driver in its local cache.

Later tests can normally reuse the cached driver.

This is also why a corporate:

* firewall;
* proxy;
* VPN;
* endpoint-security tool; or
* Internet restriction

can sometimes cause Selenium Manager problems.

---

# Step 19: Run the Test from Maven

You do not have to run tests only from Eclipse.

Because this is a Maven project, tests can also be executed from the command line.

Open a terminal in the project directory.

Run:

```bash
mvn test
```

Maven will:

1. compile the project;
2. compile the test classes;
3. start the test framework;
4. execute your tests; and
5. display the results.

You might see output ending with something similar to:

```text
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
```

and:

```text
BUILD SUCCESS
```

This is important because the same Maven command can later be used by continuous integration tools.

---

# Do I Need to Install Maven Separately?

Not necessarily if you are only running Maven functionality through Eclipse.

The Eclipse IDE for Java Developers includes Maven integration.

However, if you want to execute:

```bash
mvn test
```

directly from Windows Command Prompt or PowerShell, you need a command-line Maven installation available on your computer.

After installing Maven, verify it with:

```bash
mvn -version
```

The output should identify:

* the Maven version;
* the Java version;
* the Java home directory; and
* your operating system.

---

# Step 20: Learn Selenium Locators

The next major Selenium skill to learn is **locators**.

Selenium must locate an element before it can interact with it.

Consider this HTML:

```html
<input
    id="username"
    name="username"
    type="text"
    class="login-field">
```

Selenium can potentially locate this element several ways.

---

## Locate by ID

```java
driver.findElement(By.id("username"));
```

A unique, stable ID is usually an excellent locator.

---

## Locate by Name

```java
driver.findElement(By.name("username"));
```

---

## Locate by CSS Selector

```java
driver.findElement(
    By.cssSelector("#username"));
```

or:

```java
driver.findElement(
    By.cssSelector("input[name='username']"));
```

CSS selectors are extremely useful and worth learning.

---

## Locate by Link Text

For a link such as:

```html
<a href="/contact">Contact Us</a>
```

you could use:

```java
driver.findElement(
    By.linkText("Contact Us"));
```

---

## Locate by XPath

```java
driver.findElement(
    By.xpath("//input[@id='username']"));
```

XPath is powerful, but beginners sometimes overuse extremely long XPath expressions copied from browser developer tools.

Whenever possible, prefer stable and understandable locators.

---

# Good Locator Priority

There is no universal rule that fits every application, but a tester should generally look for locators that are:

* unique;
* stable;
* understandable;
* resistant to UI layout changes; and
* intentionally provided for automation where possible.

Examples might include:

```java
By.id("username")
```

or:

```java
By.cssSelector("[data-testid='login-button']")
```

A short stable locator is usually preferable to a huge XPath based on the webpage's visual structure.

---

# Step 21: Learn to Inspect Web Elements

To automate a real website, you must learn how to inspect its HTML.

In Chrome:

1. open the webpage;
2. right-click an element;
3. select **Inspect**.

Chrome DevTools will open.

Suppose you see:

```html
<button id="loginButton" type="submit">
    Login
</button>
```

A Selenium locator could be:

```java
driver.findElement(By.id("loginButton"));
```

You could then click it:

```java
driver.findElement(
    By.id("loginButton")).click();
```

Learning basic HTML and browser developer tools will greatly improve your Selenium skills.

---

# Step 22: Avoid Thread.sleep() for Normal Synchronization

Beginners frequently encounter Selenium examples containing:

```java
Thread.sleep(5000);
```

This simply stops Java for five seconds.

Although occasionally useful for troubleshooting or demonstrations, fixed sleeps are generally a poor synchronization strategy for real automated tests.

Web applications are asynchronous.

An element might appear in:

* 300 milliseconds;
* 2 seconds;
* 4 seconds; or
* 10 seconds.

Waiting exactly five seconds can therefore be either:

* unnecessarily slow; or
* not long enough.

Selenium provides **wait mechanisms** that are better suited to this problem.

---

# Step 23: Use Explicit Waits

Suppose you click a button and need to wait for another element to become visible.

First import:

```java
import java.time.Duration;

import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
```

Then create a wait:

```java
WebDriverWait wait =
        new WebDriverWait(
            driver,
            Duration.ofSeconds(10));
```

Now wait for an element:

```java
WebElement message =
        wait.until(
            ExpectedConditions.visibilityOfElementLocated(
                By.id("message")));
```

This means:

> Wait up to 10 seconds for the element to become visible.

If it becomes visible after one second, Selenium continues immediately.

It does not automatically wait the entire 10 seconds.

Explicit waits are therefore an important concept for reliable Selenium automation.

---

# Step 24: Create a More Realistic Test

Once your basic test works, you can rewrite it using a wait and clearer test stages.

```java
package com.qmstesting.tests;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.time.Duration;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class WebFormTest {

    private WebDriver driver;

    @Test
    void userCanSubmitWebForm() {

        // Arrange
        driver = new ChromeDriver();

        WebDriverWait wait =
                new WebDriverWait(
                    driver,
                    Duration.ofSeconds(10));

        // Act
        driver.get(
            "https://www.selenium.dev/selenium/web/web-form.html");

        WebElement textBox =
                wait.until(
                    ExpectedConditions
                        .visibilityOfElementLocated(
                            By.name("my-text")));

        textBox.sendKeys("Selenium");

        driver.findElement(
            By.cssSelector("button")).click();

        // Assert
        WebElement message =
                wait.until(
                    ExpectedConditions
                        .visibilityOfElementLocated(
                            By.id("message")));

        assertEquals(
            "Received!",
            message.getText());
    }

    @AfterEach
    void tearDown() {

        if (driver != null) {
            driver.quit();
        }
    }
}
```

This illustrates the common testing concept:

```text
Arrange
Act
Assert
```

### Arrange

Prepare the browser and test conditions.

### Act

Perform the behaviour being tested.

### Assert

Verify the result.

---

# Step 25: Test with Firefox

One advantage of Selenium is that the same general test can be executed against another browser.

Install Mozilla Firefox.

Change:

```java
import org.openqa.selenium.chrome.ChromeDriver;
```

to:

```java
import org.openqa.selenium.firefox.FirefoxDriver;
```

Then change:

```java
driver = new ChromeDriver();
```

to:

```java
driver = new FirefoxDriver();
```

Selenium Manager can manage the required Firefox driver as well.

You normally do not have to manually download `geckodriver`.

---

# Test with Microsoft Edge

For Microsoft Edge, import:

```java
import org.openqa.selenium.edge.EdgeDriver;
```

and use:

```java
driver = new EdgeDriver();
```

Again, Selenium Manager normally handles the driver.

---

# Step 26: Understand Test Failures

Change:

```java
assertEquals(
    "Received!",
    message.getText());
```

temporarily to:

```java
assertEquals(
    "Something Else",
    message.getText());
```

Run the test.

The test should now fail.

That is useful.

Automated testing is not simply about obtaining green results. You need confidence that your test can also correctly recognize when the application does **not** behave as expected.

JUnit should report information showing the difference between the expected and actual result.

Restore the assertion afterwards:

```java
assertEquals(
    "Received!",
    message.getText());
```

---

# Step 27: Common Beginner Selenium Errors

Even with the modern setup, you will eventually encounter errors.

Here are some of the most common.

---

## `NoSuchElementException`

Example:

```text
org.openqa.selenium.NoSuchElementException
```

This means Selenium could not find an element using your locator.

Possible causes include:

* the locator is incorrect;
* the webpage changed;
* the element has not appeared yet;
* the element is inside an iframe;
* you are on the wrong page;
* the element is in another browser window; or
* dynamic HTML changed the locator.

First inspect the element again using browser developer tools.

---

## `TimeoutException`

This commonly occurs with explicit waits.

For example, you might ask Selenium to wait up to 10 seconds:

```java
wait.until(
    ExpectedConditions.visibilityOfElementLocated(
        By.id("message")));
```

If the element never becomes visible, Selenium throws a timeout exception.

Investigate whether:

* the locator is correct;
* the page loaded successfully;
* another element is blocking the page;
* the expected event occurred; or
* more appropriate waiting logic is needed.

---

## `ElementClickInterceptedException`

This means Selenium found an element but another element may be blocking the click.

Common examples include:

* cookie banners;
* pop-ups;
* modal windows;
* loading overlays; and
* sticky navigation components.

---

## `StaleElementReferenceException`

Web applications frequently update their DOM.

If Selenium previously located an element and the page replaces that element, the stored `WebElement` reference can become stale.

You may need to locate the element again.

---

# Selenium Manager Cannot Download the Driver

If Selenium Manager cannot obtain the appropriate browser driver, possible reasons include:

* no Internet connection;
* firewall restrictions;
* corporate proxy restrictions;
* antivirus or endpoint-security restrictions;
* unsupported browser installation;
* browser version problems; or
* corrupted cached driver information.

Do not immediately start downloading random browser drivers manually.

First examine the Selenium error message because it usually contains useful diagnostic information.

---

# Chrome Opens and Immediately Closes

This may actually mean your test worked correctly.

If your test ends with:

```java
driver.quit();
```

Chrome will close when the test finishes.

If you want to observe what Selenium is doing while learning, run the test from Eclipse and watch the browser.

Avoid permanently adding long `Thread.sleep()` statements simply to keep the browser open.

---

# Eclipse Cannot Resolve Selenium Imports

If Eclipse puts red lines under imports such as:

```java
import org.openqa.selenium.WebDriver;
```

check your `pom.xml`.

Then:

1. right-click the project;
2. select **Maven**;
3. select **Update Project**;
4. select the project;
5. click **OK**.

Also verify that:

```text
Maven Dependencies
```

appears in the project.

---

# Maven Dependency Problems

If dependencies were not downloaded successfully, try:

**Right-click project > Maven > Update Project**

If necessary, enable:

```text
Force Update of Snapshots/Releases
```

and update again.

A corporate network may also prevent Maven from accessing remote dependency repositories.

---

# Java Version Problems

If Eclipse or Maven reports a Java version problem, check:

```bash
java -version
```

and:

```bash
javac -version
```

If Maven is installed separately, also check:

```bash
mvn -version
```

Pay attention to the Java version shown by Maven.

Windows can have several Java versions installed simultaneously, so the version used by Eclipse, Maven, and your command line is not always automatically the same.

---

# Should You Delete module-info.java?

Older Selenium Eclipse instructions sometimes recommend deleting:

```text
module-info.java
```

to solve library problems.

That is unnecessary when following this Maven tutorial.

Our Maven test project does not require you to create a Java module.

For a beginner Selenium automation project, keeping the project simple and non-modular is perfectly reasonable.

---

# Should You Download Selenium JAR Files?

For this Maven-based setup:

**No.**

Do not download the Selenium Java ZIP simply to add the JAR files manually to Eclipse.

Maven handles Selenium dependencies for you.

Manual JAR installation is mainly relevant to specialized situations or environments where a standard dependency-management approach cannot be used.

---

# Should You Download ChromeDriver?

Normally:

**No.**

Selenium Manager manages ChromeDriver automatically.

Manual driver management can still be necessary in certain restricted or specialized environments, but it should not be the default starting point for a beginner in 2026.

---

# Should You Set webdriver.chrome.driver?

Normally:

**No.**

Older code frequently contains:

```java
System.setProperty(
    "webdriver.chrome.driver",
    "C:\\chromedriver\\chromedriver.exe");
```

Modern Selenium normally does not require it.

Use:

```java
WebDriver driver =
        new ChromeDriver();
```

and let Selenium Manager handle the driver.

---

# Should You Install SLF4J or Logback Manually?

Do not download random logging JARs and copy them into your Selenium directory simply because an older tutorial recommends it.

When using Maven, Java libraries should generally be declared as dependencies.

This produces a cleaner, repeatable, and maintainable project.

---

# Recommended Project Structure as You Learn Selenium

A beginner project might initially contain:

```text
selenium-beginner
│
├── src
│   ├── main
│   │   └── java
│   │
│   └── test
│       └── java
│           └── com
│               └── qmstesting
│                   └── tests
│                       ├── FirstSeleniumTest.java
│                       └── WebFormTest.java
│
└── pom.xml
```

As your framework becomes more advanced, you might eventually add:

```text
pages
tests
utilities
configuration
data
```

For example:

```text
src/test/java
└── com.qmstesting
    ├── pages
    │   └── LoginPage.java
    │
    ├── tests
    │   └── LoginTest.java
    │
    └── utilities
        └── DriverFactory.java
```

Do not worry about building a sophisticated framework yet.

First become comfortable with:

1. creating drivers;
2. opening webpages;
3. finding elements;
4. interacting with elements;
5. using waits;
6. writing assertions; and
7. debugging failed tests.

---

# Important Skills to Learn Next

Once you have completed this tutorial, a good Selenium learning path is:

### 1. HTML Basics

Learn the meaning of:

```html
id
name
class
input
button
a
div
form
table
```

You do not need to become a web developer, but understanding HTML makes locating elements much easier.

### 2. Browser Developer Tools

Become comfortable with Chrome DevTools and the **Elements** panel.

### 3. Selenium Locators

Learn:

```java
By.id()
By.name()
By.className()
By.linkText()
By.cssSelector()
By.xpath()
```

Pay particular attention to CSS selectors.

### 4. WebElement Methods

Learn methods such as:

```java
click()
sendKeys()
clear()
getText()
isDisplayed()
isEnabled()
isSelected()
getAttribute()
```

### 5. Assertions

Learn JUnit assertions such as:

```java
assertEquals()
assertTrue()
assertFalse()
assertNotNull()
```

### 6. Explicit Waits

Learn:

```java
WebDriverWait
```

and:

```java
ExpectedConditions
```

### 7. Dropdown Lists

Learn Selenium's:

```java
Select
```

class.

### 8. Alerts

Learn how to handle JavaScript alerts.

### 9. Browser Windows and Tabs

Learn:

```java
getWindowHandle()
getWindowHandles()
switchTo()
```

### 10. Frames

Learn how Selenium interacts with:

```html
iframe
```

elements.

### 11. Screenshots

Learn how to capture screenshots when tests fail.

### 12. JUnit Lifecycle Methods

Learn annotations such as:

```java
@BeforeEach
@AfterEach
@BeforeAll
@AfterAll
@Test
```

### 13. Page Object Model

Once you can write several working tests, learn the **Page Object Model**.

This helps separate:

* test logic;
* page locators; and
* page interactions.

### 14. Data-Driven Testing

Learn to execute similar tests with multiple sets of data.

### 15. Git and GitHub

Put your Selenium project under source control.

### 16. Continuous Integration

Eventually learn how to run:

```bash
mvn test
```

automatically through tools such as GitHub Actions.

---

# A Few Selenium Best Practices for Beginners

Developing good habits early will make your automated tests much easier to maintain.

## Always Close the Browser

Use:

```java
driver.quit();
```

during cleanup.

---

## Always Verify Something

Do not create tests that only perform actions.

Include meaningful assertions.

For example:

```java
assertEquals(
    "Dashboard",
    driver.getTitle());
```

---

## Prefer Stable Locators

Avoid locators that depend heavily on visual position or deeply nested page structures.

---

## Avoid Large Numbers of Hard-Coded Sleeps

Prefer explicit waits for conditions that actually matter.

---

## Give Tests Meaningful Names

Better:

```java
void validUserCanLogIn()
```

Less useful:

```java
void test1()
```

A test name should communicate the behaviour being verified.

---

## Keep One Clear Purpose Per Test

A test should normally have a clear reason to exist.

For example:

```text
Valid user can log in
```

is clearer than one enormous automated test that:

* logs in;
* changes profile details;
* creates an order;
* deletes an account;
* logs out; and
* performs many unrelated assertions.

---

## Read Error Messages

Selenium exceptions often provide valuable information about what went wrong.

Do not immediately change code randomly when a test fails.

Ask:

1. What line failed?
2. What exception occurred?
3. What element was Selenium trying to find?
4. What was the expected result?
5. What actually appeared in the browser?

This is part of developing the debugging skills required of an automation tester.

---

# Frequently Asked Questions

## Do I need programming experience to learn Selenium?

Some Java knowledge is extremely helpful.

You do not need to be an expert developer, but you should gradually learn:

* variables;
* data types;
* methods;
* classes;
* objects;
* constructors;
* conditions;
* loops;
* collections;
* exceptions; and
* object-oriented programming.

---

## Is Java still suitable for Selenium in 2026?

Yes.

Java remains one of Selenium's officially supported languages and has a large automation-testing ecosystem.

---

## Do I have to use Eclipse?

No.

Selenium Java can also be developed using IDEs such as IntelliJ IDEA and Visual Studio Code.

This tutorial uses Eclipse because it provides a full Java development environment and integrated Maven support.

---

## Do I need Maven?

Technically, no.

Selenium Java libraries can be managed manually.

However, Maven is strongly recommended for a modern Java automation project because it makes dependency management much easier.

---

## Is Selenium Manager part of Selenium?

Yes.

You do not normally install Selenium Manager separately.

It is included with modern Selenium releases and invoked automatically when necessary.

---

## Do I need ChromeDriver?

Chrome still requires a browser-driver component internally.

The important difference is that **you normally don't need to download or manage ChromeDriver yourself**.

Selenium Manager handles it.

---

## Can I use Selenium with Firefox or Edge?

Yes.

For Firefox:

```java
WebDriver driver =
        new FirefoxDriver();
```

For Edge:

```java
WebDriver driver =
        new EdgeDriver();
```

Selenium Manager normally handles their browser drivers as well.

---

# Conclusion

Setting up Selenium WebDriver with Java is considerably easier in 2026 than it was in the past.

A modern Selenium Java project no longer needs to begin with manually downloading Selenium JAR files and individual browser drivers.

The recommended beginner workflow is:

```text
Install JDK
      ↓
Install Eclipse
      ↓
Create Maven Project
      ↓
Add Selenium Dependency
      ↓
Add JUnit Dependency
      ↓
Create Test Class
      ↓
new ChromeDriver()
      ↓
Selenium Manager Handles Driver
      ↓
Run Automated Test
```

The most important thing to remember is that installing Selenium is only the beginning.

A capable Selenium tester needs to understand not only how to make a browser perform actions, but how to design tests that reliably verify application behaviour.

Your next priorities should therefore be:

* HTML and browser developer tools;
* Selenium locators;
* WebElement interactions;
* explicit waits;
* assertions;
* JUnit;
* test organization;
* Page Object Model;
* test data;
* Git; and
* CI/CD execution.

Once you can confidently open a browser, locate elements, interact with them, wait for application states, and verify expected outcomes, you have the foundation needed to begin building maintainable Selenium automation frameworks.

For additional examples, see the official [Selenium WebDriver Getting Started documentation](https://www.selenium.dev/documentation/webdriver/getting_started/first_script/).
