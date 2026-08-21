---
layout: post
title: "Setting Up IntelliJ IDEA for Selenium WebDriver: A Complete Beginner's Guide"
date: 2026-08-21
categories: [Selenium, Test Automation]
tags: [Selenium, Selenium WebDriver, IntelliJ IDEA, Java, Maven, TestNG, Azure DevOps, CI/CD, Automation Testing]
description: "A step-by-step beginner's guide to setting up IntelliJ IDEA, Java, Maven, Selenium WebDriver, Selenium Manager, and TestNG for browser automation and future Azure DevOps pipeline execution."
---

# Setting Up IntelliJ IDEA for Selenium WebDriver

Selenium WebDriver is one of the most widely used tools for automating web browsers. It allows you to write programs that interact with websites much like a real user would—opening pages, clicking buttons, entering information into forms, reading text, and verifying that a web application behaves as expected.

When Selenium is combined with **Java** and **IntelliJ IDEA**, you have a powerful development environment for creating and maintaining automated tests.

IntelliJ IDEA provides features that are particularly useful when developing Selenium tests, including:

- Intelligent Java code completion
- Real-time detection of many coding errors
- Integrated debugging
- Maven and Gradle support
- Git integration
- Test execution directly from the IDE
- Project and dependency management

In this tutorial, we'll set up a Selenium automation project using **Java, Maven, Selenium WebDriver, and IntelliJ IDEA**.

We'll also structure the project so that it can later be moved from local test execution to a **CI/CD platform such as Azure DevOps** without having to rebuild the project from scratch.

---

## What You'll Learn

By the end of this guide, you'll know how to:

1. Install IntelliJ IDEA
2. Install and configure a Java Development Kit (JDK)
3. Create a Maven-based Java project
4. Add Selenium WebDriver to the project
5. Understand how modern Selenium manages browser drivers
6. Create and run your first Selenium script
7. Add TestNG for structured automated testing
8. Run your tests with Maven
9. Prepare the project for future Azure DevOps pipeline execution

> **💡 Goal:** We're not simply trying to get Chrome to open from Java. We're building a clean, repeatable foundation that can eventually grow into a maintainable automated testing framework.

---

# 1. Understanding the Components

Before installing anything, it helps to understand what each component does and how the pieces fit together.

## IntelliJ IDEA

**IntelliJ IDEA** is an Integrated Development Environment, or **IDE**, developed by JetBrains.

An IDE provides the tools needed to write, organize, execute, and debug software.

Instead of writing Java code in a basic text editor and manually compiling everything from a command prompt, IntelliJ provides an integrated environment for performing these tasks.

For Selenium development, IntelliJ can help manage:

- Java source files
- Maven dependencies
- Test classes
- Debugging
- Git repositories
- Project configuration
- Test execution

---

## Java Development Kit (JDK)

The **Java Development Kit**, commonly called the **JDK**, contains the tools required to develop, compile, and run Java applications.

IntelliJ IDEA includes the JetBrains Runtime required to operate the IDE itself, but when you're developing Java applications, your project still needs an appropriate JDK.

Your Selenium Java code will be compiled and executed using this JDK.

---

## Selenium WebDriver

**Selenium WebDriver** is the component that allows your Java program to control a web browser.

For example, Selenium can instruct a browser to:

1. Launch
2. Navigate to a URL
3. Locate an element on a page
4. Click a button
5. Enter text
6. Read information from the page
7. Verify a result
8. Close the browser

This allows repetitive browser testing to be performed automatically instead of manually.

---

## Maven

**Maven** is a Java build and dependency-management tool.

Instead of manually downloading Selenium `.jar` files and adding them to your project, Maven can download and manage the required libraries automatically.

The project's Maven configuration is stored in a file called:

```text
pom.xml
```

This becomes especially useful when you eventually move your project to Azure DevOps.

Another computer—or an Azure DevOps build agent—can examine your `pom.xml` and automatically retrieve the dependencies needed to build and execute the tests.

---

## TestNG

**TestNG** is a Java testing framework.

Although a basic Selenium program can be executed using Java's `main()` method, a testing framework provides much more structure.

TestNG supports features such as:

- `@Test` annotations
- Assertions
- Test setup and cleanup
- Test grouping
- Parameterization
- Parallel execution
- Test suites
- Test reporting

We'll first verify that Selenium works with a simple Java program. Then we'll convert the concept into an actual automated test using TestNG.

---

# 2. IntelliJ IDEA System Requirements

Before installing IntelliJ IDEA, make sure your computer meets the requirements for the version you're installing.

Current IntelliJ IDEA versions generally require considerably more resources than older versions of the IDE.

A modern development computer should meet approximately the following requirements:

<div class="table-scroll">
<table>
  <thead>
    <tr>
      <th>Component</th>
      <th>Recommended Starting Point</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>CPU</strong></td>
      <td>x86_64 or ARM64 processor with 4+ cores</td>
    </tr>
    <tr>
      <td><strong>RAM</strong></td>
      <td>8 GB total RAM or more</td>
    </tr>
    <tr>
      <td><strong>Disk Space</strong></td>
      <td>Approximately 10 GB available</td>
    </tr>
    <tr>
      <td><strong>Display</strong></td>
      <td>1280 × 720 or higher</td>
    </tr>
    <tr>
      <td><strong>Storage</strong></td>
      <td>SSD strongly recommended</td>
    </tr>
  </tbody>
</table>
</div>

IntelliJ IDEA is available for:

- Windows
- macOS
- Linux

### Windows

Current IntelliJ releases support modern 64-bit versions of Windows, including:

- Windows 10
- Windows 11

### macOS

IntelliJ IDEA supports recent macOS versions on both:

- Intel-based Macs
- Apple Silicon Macs

### Linux

IntelliJ supports major modern 64-bit Linux distributions and common desktop environments.

> **⚠️ Important:** JetBrains periodically changes its supported operating systems and hardware requirements. Always check the official **JetBrains IntelliJ IDEA installation documentation** before installing a new version.

> **💡 JDK vs. JetBrains Runtime:** IntelliJ includes its own runtime for operating the IDE. That does **not** mean your Java project automatically has the JDK it needs for Java development.

---

# 3. Installing IntelliJ IDEA

## Step 1 — Download IntelliJ IDEA

Visit the official **JetBrains IntelliJ IDEA download page**:

[Download IntelliJ IDEA](https://www.jetbrains.com/idea/download/)

Choose the installer appropriate for your operating system.

JetBrains' IntelliJ editions and licensing options have evolved over time, so choose the currently available edition that provides the Java development functionality you need.

For a standard Selenium/Java learning project, enterprise application-development features are not normally required.

---

## Step 2 — Install IntelliJ IDEA

### Windows

Run the downloaded installer.

Depending on your IntelliJ version, the installer may offer options such as:

- Creating a desktop shortcut
- Adding IntelliJ commands to your system `PATH`
- Creating file associations

Adding IntelliJ to `PATH` can be useful if you want to launch IntelliJ or open projects from a terminal, but it isn't required for Selenium.

### macOS

Open the downloaded package and move IntelliJ IDEA into the **Applications** folder as instructed.

### Linux

Installation options vary depending on your Linux distribution and preferred installation method.

Follow the installation instructions provided by JetBrains for your distribution.

---

## Step 3 — Start IntelliJ IDEA

Launch IntelliJ IDEA.

On first startup, IntelliJ may ask you to configure:

- Appearance
- Theme
- Settings
- Plugins
- Other preferences

Most of these settings can be changed later, so don't worry about configuring everything immediately.

---

# 4. Installing a Java Development Kit

A Java Selenium project requires a **Java Development Kit (JDK)**.

For most users, selecting a currently supported **Long-Term Support (LTS)** Java release is a sensible choice.

## Option A — Install a JDK Separately

You can obtain an OpenJDK distribution from a provider such as **Eclipse Adoptium**:

[Download Eclipse Temurin](https://adoptium.net/)

Oracle also provides a JDK:

[Oracle Java Downloads](https://www.oracle.com/java/technologies/downloads/)

Download and install the appropriate version for your:

- Operating system
- CPU architecture

---

## Option B — Download a JDK Through IntelliJ

Modern versions of IntelliJ IDEA can also help you download and configure a JDK while creating a project.

This is often the easiest approach for beginners because IntelliJ can associate the downloaded JDK directly with the project.

---

# 5. Creating the Selenium Project

We'll create our project using **Maven**.

Using Maven from the beginning avoids manually managing Selenium `.jar` files and makes the project much easier to reproduce on another computer or CI/CD agent.

## Step 1 — Create a New Project

From the IntelliJ welcome screen:

1. Click **New Project**.
2. Select **Java**.
3. Select the JDK you installed.
4. Select **Maven** as the build system if that option is presented.
5. Give the project a name such as:

```text
SeleniumSetup
```

6. Select where the project should be stored.
7. Create the project.

A typical Maven test project will eventually resemble:

```text
SeleniumSetup
│
├── pom.xml
│
└── src
    ├── main
    │   └── java
    │
    └── test
        └── java
```

For automated tests, we'll normally place test classes under:

```text
src/test/java
```

---

# 6. Understanding pom.xml

The `pom.xml` file is one of the most important files in a Maven project.

**POM** stands for **Project Object Model**.

Among other things, this file can tell Maven:

- Information about the project
- Which Java version to use
- Which external libraries the project requires
- Which plugins are required during the build
- How tests should be executed

Instead of copying Selenium libraries manually into the project, we'll declare Selenium as a Maven dependency.

Maven can then download the required libraries and make them available to the Java project.

This is a major advantage when working with CI/CD.

An Azure DevOps build agent doesn't need copies of the libraries stored on your personal computer. Maven can recreate the project's dependencies based on the information contained in `pom.xml`.

---

# 7. Adding Selenium WebDriver

Open your project's:

```text
pom.xml
```

Inside the `<dependencies>` section, add the Selenium Java dependency.

For example:

```xml
<dependencies>

    <dependency>
        <groupId>org.seleniumhq.selenium</groupId>
        <artifactId>selenium-java</artifactId>
        <version>4.47.0</version>
    </dependency>

</dependencies>
```

> **⚠️ Version Note:** Selenium is updated regularly. The version shown above was current when this tutorial was updated. Check the [official Selenium downloads page](https://www.selenium.dev/downloads/) or Maven Central before creating a new project.

After saving `pom.xml`, IntelliJ and Maven should download Selenium and its required **transitive dependencies**.

A transitive dependency is simply another library that Selenium itself depends on.

You can normally confirm the dependencies through IntelliJ's Maven interface.

If IntelliJ displays a Maven reload notification, allow the project to reload.

---

# 8. Browser Drivers and Selenium Manager

Browser-driver management is an area where modern Selenium has become considerably easier.

## The Older Approach

Older Selenium tutorials often instructed users to:

1. Determine their installed Chrome version.
2. Download a matching ChromeDriver manually.
3. Store `chromedriver.exe` somewhere on the computer.
4. Configure its location in Java.

You may therefore encounter code like this in older examples:

```java
System.setProperty(
    "webdriver.chrome.driver",
    "C:\\drivers\\chromedriver.exe"
);
```

This approach may still be useful in certain specialized environments, but it is **generally unnecessary with modern Selenium**.

---

## The Modern Approach — Selenium Manager

Modern Selenium releases include **Selenium Manager**.

When your Java program creates a ChromeDriver:

```java
WebDriver driver = new ChromeDriver();
```

Selenium can automatically manage much of the browser-driver setup.

When required, Selenium Manager can:

1. Discover the browser installed on the system.
2. Determine the appropriate driver.
3. Download the required driver.
4. Cache it locally.
5. Make it available to Selenium.

This removes one of the most common problems encountered in older Selenium tutorials: manually keeping ChromeDriver synchronized with Chrome.

> **💡 Tip:** For a standard modern Selenium installation, don't begin by manually downloading ChromeDriver. Try Selenium's built-in driver management first.

> **⚠️ Corporate Networks:** Selenium Manager may need Internet access to retrieve browser-driver metadata or download a driver. Corporate proxies, security software, and firewall restrictions can therefore affect automatic driver management.

---

# 9. Creating Your First Selenium Script

Now let's verify that the basic environment works.

Create a Java class named:

```text
FirstTest.java
```

Enter the following code:

```java
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

public class FirstTest {

    public static void main(String[] args) {

        WebDriver driver = new ChromeDriver();

        try {
            driver.get("https://www.example.com");

            System.out.println(
                "Page title: " + driver.getTitle()
            );

        } finally {
            driver.quit();
        }
    }
}
```

Notice what is **not** present:

```java
System.setProperty(
    "webdriver.chrome.driver",
    "path/to/chromedriver"
);
```

For a standard modern Selenium setup, Selenium Manager can handle driver discovery and management automatically.

---

# 10. Understanding the Selenium Script

Let's examine the program one piece at a time.

## Import WebDriver

```java
import org.openqa.selenium.WebDriver;
```

`WebDriver` is the Selenium interface through which we interact with a browser.

---

## Import ChromeDriver

```java
import org.openqa.selenium.chrome.ChromeDriver;
```

`ChromeDriver` provides the implementation used to automate Google Chrome.

---

## Create the Browser Session

```java
WebDriver driver = new ChromeDriver();
```

This creates a new WebDriver session and launches Chrome.

If a suitable ChromeDriver isn't already available, Selenium Manager can resolve and manage it automatically.

---

## Navigate to a Website

```java
driver.get("https://www.example.com");
```

This tells the browser to navigate to the specified URL.

---

## Retrieve the Page Title

```java
driver.getTitle();
```

WebDriver asks the browser for the current page's title.

We then display it in the IntelliJ console:

```java
System.out.println(
    "Page title: " + driver.getTitle()
);
```

---

## Close the Browser

```java
driver.quit();
```

`quit()` terminates the WebDriver session and closes the associated browser windows.

Our example places this inside a `finally` block:

```java
finally {
    driver.quit();
}
```

This is useful because Java attempts to execute the cleanup code even if an exception occurs while the browser automation is running.

---

# 11. Running the Test

In IntelliJ:

1. Open `FirstTest.java`.
2. Locate the green **Run** icon beside the class or `main()` method.
3. Click it.
4. Select **Run 'FirstTest.main()'**.

If everything is configured correctly:

1. Chrome launches.
2. Selenium opens `example.com`.
3. IntelliJ displays the page title in the **Run** console.
4. Chrome closes.

You have now successfully created and executed your first Selenium WebDriver program.

> **💡 Don't worry if Chrome closes quickly.** The program explicitly calls `driver.quit()` after retrieving the page title.

---

# 12. Browser Automation vs. Automated Testing

Our first example proves that Selenium works, but there's an important distinction to understand.

It performs **browser automation**, but it doesn't yet perform a meaningful **automated test**.

The program opens a webpage and prints information:

```java
System.out.println(
    "Page title: " + driver.getTitle()
);
```

But it never determines whether the page title is actually correct.

A useful automated test should answer a question such as:

> Did the application produce the result we expected?

For example:

> Is the page title equal to `"Example Domain"`?

This is where a testing framework such as **TestNG** becomes useful.

---

# 13. Adding TestNG

Add TestNG to the `<dependencies>` section of your `pom.xml`.

For example:

```xml
<dependency>
    <groupId>org.testng</groupId>
    <artifactId>testng</artifactId>
    <version>YOUR_CURRENT_TESTNG_VERSION</version>
    <scope>test</scope>
</dependency>
```

Before using the example, check the current TestNG release and replace:

```text
YOUR_CURRENT_TESTNG_VERSION
```

with the appropriate version.

The following setting:

```xml
<scope>test</scope>
```

tells Maven that TestNG is required for the project's testing activities rather than as a normal runtime dependency.

---

# 14. Creating a TestNG Selenium Test

Create a test class under:

```text
src/test/java
```

For example:

```text
ExampleTest.java
```

Enter:

```java
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.Assert;
import org.testng.annotations.Test;

public class ExampleTest {

    @Test
    public void verifyExamplePageTitle() {

        WebDriver driver = new ChromeDriver();

        try {
            driver.get("https://www.example.com");

            String actualTitle = driver.getTitle();

            Assert.assertEquals(
                actualTitle,
                "Example Domain"
            );

        } finally {
            driver.quit();
        }
    }
}
```

This is now an actual automated test rather than simply a browser-automation demonstration.

---

# 15. Understanding the TestNG Test

The annotation:

```java
@Test
```

tells TestNG that the method is a test method.

The browser is launched with:

```java
WebDriver driver = new ChromeDriver();
```

The test navigates to:

```text
https://www.example.com
```

We retrieve the title:

```java
String actualTitle = driver.getTitle();
```

Then TestNG compares the actual title with the title we expect:

```java
Assert.assertEquals(
    actualTitle,
    "Example Domain"
);
```

If the two values match, the test **passes**.

If they don't match, TestNG reports the test as **failed**.

> **💡 Key Concept:** Printing information to the console is useful for learning and debugging, but an automated test normally needs an **assertion** to determine whether the expected behaviour actually occurred.

---

# 16. Running the Test with Maven

One major benefit of Maven is that tests don't have to be executed exclusively through IntelliJ.

Open IntelliJ's terminal and run:

```bash
mvn test
```

Maven will:

1. Read `pom.xml`.
2. Resolve the required dependencies.
3. Compile the project.
4. Compile the test code.
5. Execute the tests.
6. Report whether they passed or failed.

This command is particularly important because the same basic Maven command can later be executed by Azure DevOps.

Locally, the process looks like this:

```text
Developer's Computer
        |
        v
     mvn test
        |
        v
 Selenium Tests
```

Later, the concept becomes:

```text
Azure DevOps Agent
        |
        v
     mvn test
        |
        v
 Selenium Tests
```

That reproducibility is one of the main reasons Maven is preferable to manually adding Selenium JAR files.

---

# 17. Using testng.xml

As your project grows, you may want more control over which tests TestNG executes.

A `testng.xml` file can define a TestNG test suite.

For example:

```xml
<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd">

<suite name="Selenium Suite">

    <test name="Example Tests">

        <classes>
            <class name="ExampleTest"/>
        </classes>

    </test>

</suite>
```

A TestNG suite can eventually contain:

- Multiple test classes
- Multiple groups
- Parameters
- Parallel execution settings
- Different test configurations

> **💡 Note:** A `testng.xml` file isn't always necessary for a very small project. It becomes more useful as your automation suite grows and you need greater control over test execution.

---

# 18. Preparing the Project for Azure DevOps

Once the project runs reliably on your computer, you can begin preparing it for CI/CD execution.

The basic principle is:

> **Everything required to recreate and execute the test should either exist in source control or be reproducibly installed by the pipeline.**

Your repository should therefore contain items such as:

```text
SeleniumSetup
│
├── pom.xml
├── testng.xml
│
└── src
    └── test
        └── java
            └── ExampleTest.java
```

The `testng.xml` file is optional if your project doesn't use a TestNG suite configuration.

You should **not normally commit a locally downloaded ChromeDriver executable simply because Selenium needs a browser driver**.

Modern Selenium's driver-management capabilities make that unnecessary for many configurations.

---

# 19. Why CI/CD Changes the Way We Build Tests

A Selenium test that works only on your computer is difficult to automate reliably.

Suppose your test contains this:

```text
C:\Users\YourName\Downloads\chromedriver.exe
```

That path probably doesn't exist on an Azure DevOps agent.

Likewise, manually installed JAR files may exist on your computer but not on the pipeline agent.

Using **Maven** and **Selenium Manager** reduces these machine-specific dependencies.

The objective is to make the project reproducible:

```text
Git Repository
      |
      v
Azure DevOps Agent
      |
      +--> obtains Java
      |
      +--> obtains project source
      |
      +--> Maven resolves dependencies
      |
      +--> Selenium resolves driver requirements
      |
      v
 Selenium Tests Run
```

If another compatible computer can clone the repository, install the necessary runtime components, run Maven, and execute the tests without depending on files hidden somewhere on your personal computer, you're moving in the right direction.

---

# 20. Running Selenium in an Azure DevOps Pipeline

A future Azure DevOps YAML pipeline might ultimately execute a Maven command such as:

```yaml
- script: mvn clean test
  displayName: 'Run Selenium Tests'
```

This is intentionally a **simplified example**.

A production Selenium pipeline may also need to configure:

- Java
- Maven
- Browser availability
- Headless browser execution
- Environment variables
- Test-result publishing
- Screenshots
- Build artifacts
- Secrets
- Browser versions
- Network access

Those subjects deserve their own dedicated tutorial.

The important point at this stage is that the local project has been structured so that it can eventually be automated.

---

# 21. Common Problems and Troubleshooting

## IntelliJ Cannot Find Java

Check the project's SDK configuration.

In IntelliJ, inspect the project's **Project Structure** and confirm that a valid JDK is selected.

Remember:

> IntelliJ's bundled JetBrains Runtime doesn't eliminate the need for an appropriate Java development JDK for your project.

---

## Maven Cannot Resolve Selenium

Check:

- Your Internet connection
- The syntax of `pom.xml`
- Maven configuration
- Corporate proxy settings
- Firewall restrictions

Try refreshing or reloading the Maven project.

You can also run:

```bash
mvn clean test
```

from the terminal and inspect the error messages.

---

## Chrome Does Not Launch

First confirm that Chrome is installed and launches normally outside Selenium.

If Selenium Manager can't obtain or resolve the required driver, investigate:

- Internet connectivity
- Proxy restrictions
- Firewall policies
- Browser installation
- Selenium error messages

---

## Browser Opens and Immediately Closes

This may actually indicate that your program is working correctly.

Our example deliberately calls:

```java
driver.quit();
```

after performing its actions.

If you need to inspect what happens before the browser closes, use IntelliJ's **debugger and breakpoints** rather than permanently removing cleanup code.

---

## Test Passes in IntelliJ but Fails with Maven

This is an important problem to investigate before moving the project to Azure DevOps.

A test intended for CI/CD should ideally work when executed from the command line using Maven.

Try:

```bash
mvn clean test
```

If the test fails, investigate the Maven output and resolve the difference before creating the pipeline.

---

## Selenium Manager Cannot Download a Driver

This can occur in environments with restricted Internet access.

Check whether:

- A corporate proxy is required
- A firewall blocks the connection
- Security software is preventing downloads
- Your browser installation can be detected
- Your Selenium version is current

Corporate development environments may require additional Selenium Manager or proxy configuration.

---

# 22. Quick Pre-Pipeline Checklist

Before moving your Selenium project into Azure DevOps, confirm the following:

- [ ] IntelliJ IDEA is installed and working.
- [ ] A supported JDK is installed.
- [ ] IntelliJ recognizes the project's JDK.
- [ ] The project uses Maven or another reproducible build system.
- [ ] Selenium is declared as a project dependency.
- [ ] The Selenium script runs successfully from IntelliJ.
- [ ] Selenium Manager can resolve the required browser driver.
- [ ] TestNG is configured if you're using it.
- [ ] Tests contain meaningful assertions.
- [ ] `mvn test` works locally.
- [ ] Project files are stored in Git.
- [ ] Machine-specific paths have been eliminated wherever possible.
- [ ] Passwords, API keys, tokens, and other secrets are **not** committed to the repository.

If all of these items are satisfied, you have a much stronger foundation for moving your Selenium tests into a CI/CD environment.

---

# 23. Where to Go From Here

At this point, you have established the basic Selenium development environment:

```text
IntelliJ IDEA
      +
     Java
      +
    Maven
      +
Selenium WebDriver
      +
    TestNG
```

The next step is to move beyond simply opening a webpage and begin interacting with actual web applications.

Useful topics to learn next include:

### Finding Elements

Learn how Selenium locates page elements using:

- ID
- Name
- CSS selectors
- XPath
- Link text

### Interacting with Elements

Learn how to:

- Click buttons
- Enter text
- Select options
- Read page content
- Work with checkboxes
- Handle alerts

### Synchronization

Learn how to use **explicit waits** so that Selenium waits intelligently for elements and page conditions instead of relying on arbitrary sleep commands.

### Test Organization

As the project grows, explore:

- Page Object Model
- Reusable methods
- Test setup and teardown
- Test data management
- Configuration files

### Reporting and Diagnostics

Improve troubleshooting by adding:

- Screenshots on failure
- Logging
- Test reports
- Azure DevOps test-result publishing

### CI/CD

Finally, move the tests into Azure DevOps and learn how to:

- Execute Selenium from a YAML pipeline
- Run Chrome in headless mode
- Publish TestNG results
- Store screenshots as pipeline artifacts
- Configure environment variables and secrets
- Trigger tests automatically when code changes

---

# Final Thoughts

Setting up Selenium WebDriver involves more than simply getting Chrome to open from a Java program.

A well-designed setup establishes a development environment that is **repeatable, maintainable, and portable**.

Each component has a specific purpose:

| Component | Purpose |
|---|---|
| **IntelliJ IDEA** | Development environment |
| **Java/JDK** | Programming language and development tools |
| **Maven** | Build and dependency management |
| **Selenium WebDriver** | Browser automation |
| **Selenium Manager** | Automated browser-driver management |
| **TestNG** | Test structure, assertions, execution, and reporting |
| **Git** | Source control |
| **Azure DevOps** | Future CI/CD execution |

Most importantly, the project can evolve naturally from:

```text
Running a Selenium script manually in IntelliJ
```

to:

```text
Running automated tests with TestNG and Maven
```

and eventually to:

```text
Running those tests automatically in Azure DevOps
```

without rebuilding the project from scratch.

That is why taking the time to establish a clean local Selenium environment is worthwhile. You're not simply configuring an IDE—you're creating the foundation for a larger automated testing framework.

---

## Useful Resources

- [Selenium Documentation](https://www.selenium.dev/documentation/)
- [Selenium Downloads](https://www.selenium.dev/downloads/)
- [Selenium Manager Documentation](https://www.selenium.dev/documentation/selenium_manager/)
- [IntelliJ IDEA Documentation](https://www.jetbrains.com/help/idea/)
- [Maven Documentation](https://maven.apache.org/guides/)
- [TestNG Documentation](https://testng.org/)
- [Azure DevOps Pipelines Documentation](https://learn.microsoft.com/azure/devops/pipelines/)

---

*Last updated: August 2026*
