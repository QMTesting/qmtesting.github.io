---
layout: post
title: "Shift-Left Testing in DevOps: A Beginner’s Guide to Preventing Defects Early"
categories: ["Automation"]
permalink: /understanding-waits-in-selenium-to-eliminate-flaky-posts/
tags:
  - "flaky tests"
  - "Automation"
  - "QA in Automation"
  - "Automation"
  - "test automation"
  - "QA testing"
  - "Software Testing"
description: "Discover how to eliminate flaky Selenium tests by mastering waits. Learn the differences between implicit, explicit, and fluent waits, and apply best practices to stabilize your automation scripts."
image: "https://res.cloudinary.com/dig9gupue/image/upload/f_auto,q_auto,w_700/v1774457872/understanding-waits-in-selenium-to-eliminate-flaky-posts-700_x67yaa.png" 
---


<img 
  src="https://res.cloudinary.com/dig9gupue/image/upload/f_auto,q_auto,w_700/v1774457872/understanding-waits-in-selenium-to-eliminate-flaky-posts-700_x67yaa.png"
  srcset="
    https://res.cloudinary.com/dig9gupue/image/upload/f_auto,q_auto,w_350/v1774457872/understanding-waits-in-selenium-to-eliminate-flaky-posts-700_x67yaa.png 350w,
    https://res.cloudinary.com/dig9gupue/image/upload/f_auto,q_auto,w_500/v1774457872/understanding-waits-in-selenium-to-eliminate-flaky-posts-700_x67yaa.png 500w,
    https://res.cloudinary.com/dig9gupue/image/upload/f_auto,q_auto,w_700/v1774457872/understanding-waits-in-selenium-to-eliminate-flaky-posts-700_x67yaa.png 700w
  "
  sizes="(max-width: 768px) 100vw, 700px"
  width="700"
  height="500"
  loading="lazy"
  alt="how to eliminate flaky Selenium tests by mastering waits"
  fetchpriority="high">


Flaky tests are one of the biggest frustrations for new automation testers. One day your script passes, the next day it fails — even though nothing changed. Most of the time, the culprit isn’t Selenium, your code, or the application. It’s timing.

Modern web applications are dynamic. Elements load asynchronously, animations delay interactions, and network conditions vary. If your script tries to click, type, or assert something before the browser is ready, your test becomes unreliable.

This is where waits come in. Understanding waits is one of the most important skills for beginner and intermediate QA testers who want to write stable, trustworthy automation.


## 🌟 Why Waits Matter

Selenium executes commands much faster than a real user. Without waits, Selenium may:

- Try to click an element before it appears  
- Assert text before the page finishes loading  
- Interact with elements still covered by loaders or animations  
- Fail because the DOM updated a split second later  

Waits help your script pause intelligently until the browser is ready — not too early, not too late.


## 🧠 Types of Waits in Selenium

Selenium provides three main types of waits:

- Implicit Waits  
- Explicit Waits  
- Fluent Waits  

Each has a purpose, and knowing when to use which one is the key to eliminating flakiness.


## 1️⃣ Implicit Waits

Implicit waits tell Selenium:

> “Whenever you try to find an element, keep trying for X seconds before failing.”

**✔️ Good for:**
- Simple scripts  
- Pages with predictable load times  

**❌ Not good for:**
- Complex, dynamic applications  
- Waiting for specific conditions (visibility, clickability, etc.)

**Example (Java):**

```java
driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
```


## 2️⃣ Explicit Waits

Explicit waits are the backbone of stable Selenium automation. They allow you to wait for **specific conditions**, not just time.

Instead of saying “wait 10 seconds,” you say:

> “Wait *up to* 10 seconds until this element is visible/clickable/present.”

This makes your tests faster and far more reliable.

**✔️ Good for:**
- Dynamic applications  
- Elements that appear/disappear  
- Waiting for conditions like visibility, clickability, text, alerts, frames  

**❌ Not good for:**
- Replacing all waits everywhere (overuse can slow tests)

**Example (Java):**

```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
WebElement button = wait.until(ExpectedConditions.elementToBeClickable(By.id("submit")));
button.click();
```


## 3️⃣ Fluent Waits

Fluent waits are a more customizable version of explicit waits. They let you define:

- Maximum wait time  
- Polling frequency  
- Exceptions to ignore  

This is useful when dealing with elements that appear unpredictably or when the DOM is unstable.

**Example (Java):**

```java
Wait<WebDriver> wait = new FluentWait<>(driver)
        .withTimeout(Duration.ofSeconds(20))
        .pollingEvery(Duration.ofMillis(500))
        .ignoring(NoSuchElementException.class);

WebElement element = wait.until(driver -> driver.findElement(By.id("dynamic")));
```

## 🧩 Why Tests Become Flaky Without Proper Waits

Flakiness usually comes from **racing the browser**. Here are the most common timing issues:

### 🔹 1. Element not yet visible  
The element exists in the DOM but isn’t visible.  
**Use:** `visibilityOfElementLocated`

### 🔹 2. Element not clickable  
A loader or overlay is covering it.  
**Use:** `elementToBeClickable`

### 🔹 3. DOM updated after you located the element  
You get a `StaleElementReferenceException`.  
**Use:** `refreshed(ExpectedConditions...)`

### 🔹 4. AJAX calls still running  
The page *looks* ready, but data hasn’t loaded yet.  
**Use:** `presenceOfElementLocated`

### 🔹 5. Animations still running  
Buttons slide, fade, or expand before becoming stable.  
**Use:** `elementToBeClickable` or a custom JS wait

When you match the right wait to the right condition, flakiness drops dramatically.


## 🛠️ Practical Examples: Choosing the Right Wait

<table>
  <thead>
    <tr>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d; width: 175px;">Scenario</th>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d; width: 200px;">Best Wait</th>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d; width: 200px;">Why</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Button appears after AJAX</td>
      <td><code>visibilityOfElementLocated</code></td>
      <td>Ensures element is visible before clicking</td>
    </tr>
    <tr>
      <td>Loader disappears</td>
      <td><code>invisibilityOfElementLocated</code></td>
      <td>Prevents clicking through overlays</td>
    </tr>
    <tr>
      <td>Text updates dynamically</td>
      <td><code>textToBePresentInElement</code></td>
      <td>Avoids stale assertions</td>
    </tr>
    <tr>
      <td>Element becomes enabled</td>
      <td><code>elementToBeClickable</code></td>
      <td>Ensures it’s interactable</td>
    </tr>
    <tr>
      <td>Table rows load slowly</td>
      <td><code>presenceOfAllElementsLocatedBy</code></td>
      <td>Waits for DOM population</td>
    </tr>
  </tbody>
</table>




## 🧪 Real‑World Example: Fixing a Flaky Test

Imagine this test:

```java
driver.findElement(By.id("login")).click();
driver.findElement(By.id("username")).sendKeys("caroline");
```

Sometimes it fails because the username field isn’t ready yet.

**Fix with explicit wait:**

```java
WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("username")))
        .sendKeys("caroline");
```

Now the test waits intelligently instead of guessing.


## 🚫 What *Not* to Do

Many beginners try to fix flakiness with:

```java
Thread.sleep(5000);
```

This is the automation equivalent of duct tape.

❌ Slows down your suite  
❌ Doesn’t adapt to fast/slow environments  
❌ Still fails if the element takes longer than expected  

Use sleeps only for debugging — never in production tests.


## 🧭 Best Practices for Eliminating Flaky Tests

### ✔️ 1. Prefer explicit waits over implicit waits  
Implicit waits apply globally and can cause unexpected delays.

### ✔️ 2. Wait for conditions, not time  
Always ask: *What exactly am I waiting for?*

### ✔️ 3. Avoid mixing implicit and explicit waits  
This can cause unpredictable wait times.

### ✔️ 4. Use page objects to centralize waits  
Your waits become reusable and easier to maintain.

### ✔️ 5. Test in unstable environments  
If your waits survive slow CI pipelines, they’ll survive anything.


## 🎯 Final Thoughts

Understanding waits is one of the fastest ways to level up as an automation tester. When you stop racing the browser and start synchronizing with it, your tests become:

- More stable  
- More predictable  
- Easier to debug  
- CI‑friendly  
- Professional‑grade  

Flaky tests aren’t a Selenium problem — they’re a timing problem. And waits are your solution.


