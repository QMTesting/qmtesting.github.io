---
layout: post
title: "Setting Up IntelliJ IDEA for Selenium WebDriver"
categories: ["Automation"]
image: "/assets/images/Auto/Intellij_Selenium.webp"
tags: [software testing, automation, IntelliJ IDEA, Selenium, QA, QC, Quality Control]
description: "A guide on learning how to Set Up IntelliJ IDEA for Selenium WebDriver."
---

<figure>
  <img
    src="/assets/images/Auto/Intellij_Selenium-700.webp"
    srcset="/assets/images/Auto/Intellij_Selenium-300.webp 300w, /assets/images/Auto/Intellij_Selenium-390.webp 390w, /assets/images/Auto/Intellij_Selenium-700.webp 700w"
    sizes="(max-width: 767px) 390px, (min-width: 1000px) 700px, 100vw"
    alt="Set Up IntelliJ IDEA for Selenium WebDriver"
  />
   <figcaption>Image by vectorjuice on Freepik</figcaption>
</figure>

## Introduction

If you’re planning to automate browser testing with Selenium WebDriver, pairing it with IntelliJ IDEA offers one of the smoothest development experiences available. IntelliJ provides intelligent code completion, real-time error detection, integrated debugging tools, and seamless integration with build tools like Maven or Gradle. All of this makes it easier to write, organize, and maintain test automation projects.

And if you intend to later execute your Selenium tests in an Azure DevOps pipeline, starting with a clean and well-prepared local environment will make that transition far easier. Setting things up properly now prevents headaches later when builds fail in CI/CD because of missing dependencies or inconsistent configurations.

In this guide, you’ll learn how to:

- Install IntelliJ IDEA

- Set up the Java Development Kit (JDK)

- Add Selenium WebDriver to your project

- Run a test locally

- Prepare the project for execution in Azure DevOps

By the end, you’ll have a functioning local Selenium project that’s pipeline-ready and can be scaled into a more robust automation framework.

## ⚙ IntelliJ IDEA System Requirements (Windows / macOS / Linux)

Before providing the installation instructions, here are the minimum(Min) and recommended(Rec) requirements to install IntelliJ IDEA for Windows, macOS, and Linux.

## 💻IntelliJ IDEA System Requirements   – Windows

| *Category*            | Minimum Requirement* | *Recommended Requirement* |
|---------------------|----------------------|-------------------------|
| Operating System    | Windows 10 (64-bit) | Windows 11 (64-bit, latest updates) |
| CPU                 | Any 64-bit CPU      | 4+ cores processor |
| RAM                 | 2 GB                | 8 GB or more (16 GB+ for large projects) |
| Disk Space          | 2.5 GB free space   | SSD with additional space for projects and caches |
| Display             | 1024×768            | 1920×1080 (Full HD) or higher |
| Java Runtime        | Bundled JetBrains Runtime (OpenJDK-based) | Latest JetBrains Runtime or custom JDK |
| .NET Framework      | 4.7.2 or later      | Latest version available |

## 🍎IntelliJ IDEA System Requirements   – macOS

| Category            | Minimum Requirement | Recommended Requirement |
|---------------------|----------------------|-------------------------|
| Operating System    | macOS 12 (Monterey) | macOS 13–14 (Ventura, Sonoma) with latest updates |
| CPU                 | Intel Core 2 Duo or Apple Silicon (M1) | Apple Silicon (M1/M2/M3) or Intel 4+ cores |
| RAM                 | 2 GB                | 8 GB or more (16 GB+ for large projects) |
| Disk Space          | 2.5 GB free space   | SSD with additional space for projects and caches |
| Display             | 1024×768            | Retina display (1920×1080 or higher) |
| Java Runtime        | Bundled JetBrains Runtime (OpenJDK-based) | Latest JetBrains Runtime or custom JDK |

## 🐧IntelliJ IDEA System Requirements   – Linux

| Category            | Minimum Requirement | Recommended Requirement |
|---------------------|----------------------|-------------------------|
| Operating System    | Modern 64-bit Linux distribution (Gnome, KDE, or Unity) | Latest stable 64-bit Linux distribution (e.g., Ubuntu LTS, Fedora, Debian) |
| CPU                 | Any 64-bit CPU      | 4+ cores processor |
| RAM                 | 2 GB                | 8 GB or more (16 GB+ for large projects) |
| Disk Space          | 2.5 GB free space   | SSD with additional space for projects and caches |
| Display             | 1024×768            | 1920×1080 (Full HD) or higher |
| Java Runtime        | Bundled JetBrains Runtime (OpenJDK-based) | Latest JetBrains Runtime or custom JDK |
| Libraries           | GLIBC 2.17+, GTK+ 2.18+ | Latest versions available |

---

## 1. Installing IntelliJ IDEA
### Step 1 – Download the IDE

Visit JetBrains IntelliJ IDEA Download Page.

Choose the Community Edition (free) unless you specifically need enterprise features such as Spring framework support, advanced profiling, or database tools available in the Ultimate Edition.

Download the installer for your operating system (Windows, macOS, or Linux).

💡 Tip: The Community Edition is more than enough for Selenium automation work.

### Step 2 – Run the Installer

#### On Windows: 
the installer will ask if you want to create a desktop shortcut, add IntelliJ to PATH, or associate .java files with IntelliJ. Choose based on preference, but adding IntelliJ to PATH makes it easier to open projects from the terminal.

#### On macOS: 
drag IntelliJ IDEA into the Applications folder.

#### On Linux: 
extract the .tar.gz and run the idea.sh script.

### Step 3 – First-Time Setup

- Choose a UI theme (Light or Dark).

- Optionally install recommended plugins like Git Integration, Lombok support, or Maven Helper. These can speed up development but aren’t required initially.

- Configure your default project location — this is where new projects will be created.

## 2. Installing and Configuring the Java Development Kit (JDK)

Selenium in Java requires a Java Development Kit (JDK) to compile and run your tests. IntelliJ does not include one by default, so you need to install it separately.

### Step 1 – Download JDK

- Visit Adoptium or Oracle Java.

- Choose the latest Long-Term Support (LTS) version (e.g., Java 17 or Java 21). LTS versions receive updates for years, ensuring stability.

### Step 2 – Install JDK

- During installation, make note of the installation path (e.g., C:\Program Files\Java\jdk-17 on Windows). You’ll need this to configure IntelliJ.

- On macOS, JDKs are typically installed under /Library/Java/JavaVirtualMachines/.

### Step 3 – Link the JDK in IntelliJ

- Open IntelliJ → File → Project Structure (Ctrl+Alt+Shift+S).

- Under Project SDK, click Add SDK → JDK.

- Browse to the installation folder of your JDK and confirm.

- Make sure Project language level is set to match your JDK (e.g., 17).

💡 Tip: If IntelliJ still can’t detect the JDK, verify that your environment variable JAVA_HOME is set correctly.

## 3. Creating a Selenium Project

- With IntelliJ and JDK ready, the next step is to set up a Selenium project.

### Step 1 – Create a New Java Project

- From IntelliJ’s welcome screen, click New Project.

- Select Java on the left, ensure the SDK points to your installed JDK.

- Name your project (e.g., SeleniumSetup) and choose a folder location.

- Click Finish. IntelliJ will generate the project structure.

### Step 2 – Add Selenium Libraries

Selenium is not included by default. You can integrate it in two ways:

#### Option 1 – Maven (Recommended)

- Right-click the project → Add Framework Support → Maven.

- IntelliJ generates a pom.xml file.

- Add Selenium as a dependency:

      <dependency>
          <groupId>org.seleniumhq.selenium</groupId>
          <artifactId>selenium-java</artifactId>
          <version>4.21.0</version>
      </dependency>


- Save the file. IntelliJ automatically downloads all required Selenium libraries.

#### Option 2 – Manual JAR Download

- Visit Selenium Downloads.

- Download the Java Client Library ZIP file and extract it.

- In IntelliJ → File → Project Structure → Libraries → Add Java, select all .jar files from the extracted folder.

💡 If you’re planning to run tests in Azure DevOps later, Maven is strongly preferred since it handles dependency management automatically.

## 4. Running Your First Selenium Script

Before setting up CI/CD, verify that everything works locally.

### Example Java Class

    import org.openqa.selenium.WebDriver;
    import org.openqa.selenium.chrome.ChromeDriver;
    
    public class FirstTest {
        public static void main(String[] args) {
            // Path to ChromeDriver
            System.setProperty("webdriver.chrome.driver", "path/to/chromedriver");
    
            // Launch Chrome
            WebDriver driver = new ChromeDriver();
    
            // Open a website
            driver.get("https://www.example.com");
    
            // Output the page title
            System.out.println("Page title: " + driver.getTitle());
    
            // Close browser
            driver.quit();
        }
    }

### Steps to Run

- Download ChromeDriver from ChromeDriver Downloads.

- Ensure the ChromeDriver version matches your installed Chrome browser version.

- Replace "path/to/chromedriver" with the actual path where ChromeDriver is stored.

- Right-click your Java file → Run ‘FirstTest.main()’.

- If successful, Chrome launches, navigates to example.com, prints the page title in the console, and closes.

## 5. Preparing for Azure DevOps Pipeline Execution

Running tests locally is useful, but CI/CD pipelines allow you to execute them automatically whenever you push code.

### Step 1 – Use Maven or Gradle for Dependencies

This ensures that your pipeline can download Selenium, TestNG, and other libraries automatically instead of relying on manually uploaded JARs.

### Step 2 – Organize Tests with TestNG

TestNG provides structured test execution, annotations, parallel runs, and detailed reports. It integrates seamlessly with Azure DevOps pipelines.

#### Add TestNG to Maven:

    <dependency>
        <groupId>org.testng</groupId>
        <artifactId>testng</artifactId>
        <version>7.10.2</version>
        <scope>test</scope>
    </dependency>


#### Example TestNG Class:

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

This configuration file tells TestNG which tests to run:

    <!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd">
    <suite name="Selenium Suite">
        <test name="Google Test">
            <classes>
                <class name="GoogleTest"/>
            </classes>
        </test>
    </suite>

### Step 4 – Plan for Pipeline Setup

#### When pushing to a Git repo for Azure DevOps:

- Commit pom.xml, testng.xml, and all test classes.

- Ensure ChromeDriver is available (install it dynamically in the pipeline or store in repo).

#### In Azure DevOps YAML pipeline:

- script: mvn clean test
  displayName: 'Run Selenium Tests'

## ✅ 6. Quick Pre-Pipeline Checklist

- IntelliJ IDEA installed and linked to JDK
  
- Selenium libraries added via Maven
  
- ChromeDriver downloaded and working locally
  
- TestNG added and testng.xml configured
  
- All files pushed to repository

## 🎯 Final Thoughts

By setting up IntelliJ IDEA with Selenium WebDriver correctly, you’re laying the foundation for a scalable automation framework. This careful preparation ensures that when you push your project to Azure DevOps, your builds will run smoothly without unexpected dependency issues.

From here, you can extend your setup to:

- Run tests in parallel for faster execution

- Capture screenshots and generate detailed HTML reports

- Add logging frameworks (Log4j, SLF4J) for better debugging

- Integrate with cross-browser tools like Selenium Grid or BrowserStack

💡 A clean local environment saves time, prevents frustration, and makes your journey into CI/CD with Azure DevOps far smoother.
