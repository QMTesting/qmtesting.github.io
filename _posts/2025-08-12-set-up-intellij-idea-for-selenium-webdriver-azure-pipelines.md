---
layout: post
title: "Setting Up IntelliJ IDEA for Selenium WebDriver"
categories: ["Automation"]
image: "/assets/images/Auto/Intellij_Selenium.webp"
---

<figure>
  <img src="/assets/images/Auto/Intellij_Selenium.webp" alt="set up Intellij IDEA for Selenium WebDriver" />
  <figcaption>Image by vectorjuice on Freepik</figcaption>
</figure>

## Introduction

If you’re planning to automate browser testing with Selenium WebDriver, pairing it with IntelliJ IDEA offers a smooth development experience. IntelliJ provides smart code suggestions, debugging tools, and solid integration with testing frameworks.

And if you intend to later execute your Selenium tests in an Azure DevOps pipeline, starting with a clean and well-prepared local environment will make that transition far easier.

In this guide, you’ll learn how to:

- Install IntelliJ IDEA
- Set up the Java Development Kit (JDK)
- Add Selenium WebDriver to your project
- Run a test locally
- Prepare the project for execution in Azure DevOps

By the end, you’ll have a functioning local Selenium project that’s ready to be connected to a CI/CD pipeline.

## 1. Installing IntelliJ IDEA

### Step 1 – Download the IDE

- Visit https://www.jetbrains.com/idea/download
- Choose the Community Edition unless you need the advanced features of the Ultimate version
- Download the correct installer for your operating system

### Step 2 – Run the Installer

- Follow the on-screen steps to complete installation
- On Windows, you may be asked whether to create shortcuts, associate .java files, or add IntelliJ to your system PATH — choose options that suit your workflow

### Step 3 – First-Time Setup
- When IntelliJ opens for the first time:
- Pick a light or dark UI theme
- Install any recommended plugins (you can skip this if unsure)
- Confirm where you want IntelliJ to store projects

## 2. Installing and Configuring the Java Development Kit (JDK)
   
Selenium in Java requires the Java Development Kit to compile and run.

### Step 1 – Download JDK
- Visit https://adoptium.net or Oracle’s Java downloads
- Select the latest long-term support (LTS) release, such as Java 17 or Java 21

### Step 2 – Install JDK
- Run the installer and note where it is installed — you’ll need this path shortly

### Step 3 – Link the JDK in IntelliJ
- Open IntelliJ
- Go to File → Project Structure (or press Ctrl+Alt+Shift+S)
- Under Project SDK, click Add SDK → JDK
- Point IntelliJ to your JDK installation folder and confirm

## 3. Creating a Selenium Project

Once the IDE and JDK are ready, we can set up a Selenium project.

### Step 1 – Create a New Java Project
- Click New Project from IntelliJ’s welcome screen
- Select Java from the left-hand menu
- Make sure the Project SDK is set to your JDK
- Name your project (e.g., SeleniumSetup) and choose a folder location
- Click Finish

### Step 2 – Add Selenium Libraries
You can add Selenium in two ways:
- Option 1: Maven (recommended)
- Option 2: Manual JAR files

#### Option 1 – Using Maven
- Right-click the project → Add Framework Support → select Maven
- IntelliJ will create a pom.xml file
- Add Selenium as a dependency:
    <dependencies>
        <dependency>
            <groupId>org.seleniumhq.selenium</groupId>
            <artifactId>selenium-java</artifactId>
            <version>4.21.0</version>
        </dependency>
    </dependencies>
- Save the file — IntelliJ will download the required libraries automatically

#### Option 2 – Manual Download
- Go to https://www.selenium.dev/downloads/
- Download the Selenium Java client ZIP file and extract it
- In IntelliJ, open Project Structure → Libraries → Add Java and select all .jar files from the extracted folder

## 4. Running Your First Selenium Script
   
Before diving into Azure DevOps, let’s verify the setup locally.

### Example Java Class:
- import org.openqa.selenium.WebDriver;
- import org.openqa.selenium.chrome.ChromeDriver;
    public class FirstTest {
        public static void main(String[] args) {
            // Tell Selenium where ChromeDriver is located
            System.setProperty("webdriver.chrome.driver", "path/to/chromedriver");
    
            // Launch Chrome
            WebDriver driver = new ChromeDriver();
    
            // Open a website
            driver.get("https://www.example.com");
    
            // Output the page title
            System.out.println("Page title: " + driver.getTitle());
    
            // Close the browser
            driver.quit();
        }
    }

#### Steps to Run:
- Download ChromeDriver from https://chromedriver.chromium.org/downloads
- Make sure the version matches your installed Chrome browser
- Replace "path/to/chromedriver" with the actual file location
- Right-click the Java file → Run 'FirstTest.main()'

If configured correctly, Chrome will launch, open example.com, display the title in the console, and close.

## 5. Preparing for Azure DevOps Pipeline Execution
   
Running tests locally is good, but integrating them into an Azure DevOps CI/CD pipeline allows automated execution on every commit.

### Step 1 – Use Maven or Gradle for Dependencies
- Maven or Gradle ensures that your pipeline can automatically fetch all required libraries, avoiding manual .jar uploads.

### Step 2 – Organize Tests with TestNG
- TestNG provides structured test management, reporting, and parallel execution capabilities that integrate well with Azure DevOps.
- Add TestNG to Maven:
    <dependency>
        <groupId>org.testng</groupId>
        <artifactId>testng</artifactId>
        <version>7.10.2</version>
        <scope>test</scope>
    </dependency>
    Sample TestNG Class:
    
    java
    Copy
    Edit
    import org.testng.annotations.Test;
    import org.openqa.selenium.WebDriver;
    import org.openqa.selenium.chrome.ChromeDriver;
    
    public class GoogleTest {
        @Test
        public void openGoogle() {
            System.setProperty("webdriver.chrome.driver", "path/to/chromedriver");
            WebDriver driver = new ChromeDriver();
            driver.get("https://www.google.com");
            System.out.println("Page title: " + driver.getTitle());
            driver.quit();
        }
    }
  
### Step 3 – Create testng.xml
This file tells TestNG which tests to run:

    <!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd" >
    <suite name="Selenium Suite">
        <test name="Google Test">
            <classes>
                <class name="GoogleTest"/>
            </classes>
        </test>
    </suite>

### Step 4 – Plan for Pipeline Setup
When pushing to a Git repository for Azure DevOps:
- Include your pom.xml and testng.xml
- Ensure ChromeDriver is either included or installed during the pipeline run
- Use pipeline commands to install JDK, Chrome, and dependencies before running tests

Example Maven Pipeline Step:

- script: mvn clean test
  displayName: 'Run Selenium Tests'
  
## 6. Quick Pre-Pipeline Checklist
   
Before sending your project to Azure DevOps, make sure:
- IntelliJ IDEA is installed and linked to the JDK
- Selenium libraries are in place
- ChromeDriver is working locally
- TestNG is installed and configured
- All files are committed to your repository

## Final Thoughts

By setting up IntelliJ IDEA with Selenium WebDriver correctly, you’re laying the groundwork for a robust automation framework. This local setup ensures that when you push your code to Azure DevOps, your tests will execute smoothly in the pipeline without endless troubleshooting.

From here, you can extend your configuration to:
- Run tests in parallel
- Capture screenshots and generate HTML reports
- Test across multiple browsers

A clean and well-prepared local environment will save time and make your Azure DevOps automation journey much easier.
