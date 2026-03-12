---
layout: post
title: "Choosing What to Automate: A Practical Decision Framework"
categories: ["Automation"]
image: "/assets/images/Auto/what-to-automate.webp"
permalink: /choosing-what-to-automate/
tags: [software testing, QA, QC, qa automation, test automation strategy, software testing, qa engineering, testing framework]
description: "Learn how QA engineers can decide what tests to automate using a practical decision framework. Includes automation decision tree, scoring model, and best practices."
---

<figure>
  <img src="/assets/images/Auto/what-to-automate.webp" alt="Choosing What to Automate" />
  <figcaption></figcaption>
</figure>

## Introduction

Automation is one of the most powerful tools available to modern QA engineers. Done well, it accelerates feedback, reduces repetitive manual work, and protects critical functionality across every release.

However, **not every test should be automated**.

One of the most common mistakes teams make is attempting to automate too much, too early, or at the wrong layer of the system. The result is often brittle tests, slow pipelines, and growing maintenance costs.

This guide introduces a **practical framework QA engineers can use to decide what tests to automate**, along with a **decision tree and scoring model** that help teams prioritize automation efforts effectively.



## Why Choosing the Right Tests to Automate Matters

Automation requires ongoing investment. Every automated test introduces:

* Code that must be maintained
* Dependencies on environments and data
* Execution time in CI pipelines

When teams automate the wrong tests, they often experience:

* Flaky builds
* Fragile UI tests
* Slow feedback cycles
* High maintenance overhead

Strong automation strategies focus on **maximizing long-term value**, not maximizing test counts.

The goal is to automate tests that:

* Run frequently
* Protect critical user workflows
* Provide fast, reliable feedback
* Remain stable over time

<h2>Automation Decision Tree</h2>
<p>The following decision tree helps QA teams quickly evaluate automation candidates.</p>

<div style="
    position: relative;
    width: 100%;
    background-color: white; /* Change this to any color you like */
    border-radius: 6px;
    padding: 2em;
    box-sizing: border-box;
">
    <!-- Copy Button -->
    <button onclick="copyMermaidCode(this)" style="
        position: absolute;
        top: 8px;
        right: 8px;
        background-color: black;
        color: white;
        border: none;
        border-radius: 4px;
        padding: 4px 8px;
        cursor: pointer;
        font-size: 14px;">
        Copy
    </button>

    <!-- Mermaid Diagram -->
    <div class="mermaid" style="transform: scale(1.00); transform-origin: top left;">
flowchart TD
    A[Test Scenario] --> B{Runs Frequently?}
    B -- No --> C[Keep as Manual Test]
    B -- Yes --> D{Business Critical?}
    D -- Yes --> E{Feature Stable?}
    E -- No --> F[Wait Until Feature Stabilizes]
    E -- Yes --> G[Automate Test]
    D -- No --> H{Easy to Automate?}
    H -- No --> C
    H -- Yes --> I{Low Maintenance Cost?}
    I -- No --> C
    I -- Yes --> G
    </div>
</div>

<script>
function copyMermaidCode(button) {
    const mermaidDiv = button.nextElementSibling;
    const code = mermaidDiv.textContent.trim();
    navigator.clipboard.writeText(code).then(() => {
        button.textContent = 'Copied!';
        setTimeout(() => button.textContent = 'Copy', 2000);
    });
}
</script>

### How to Use This Decision Tree

QA engineers can use this model during:

* Sprint planning
* Test case design
* Automation backlog grooming

If a test fails multiple decision points, it is usually better suited for **manual execution or exploratory testing**.

## The QA Automation Decision Framework

Before automating a test, QA engineers should evaluate it across five key dimensions. Together, the following factors help determine whether automation will provide a meaningful return on investment:

### 1. Execution Frequency

The more frequently a test runs, the greater the benefit of automation.

**Strong candidates include:**

* Regression tests
* Smoke tests
* CI pipeline validations
* API contract checks

Tests executed on **every build or deployment** typically deliver the highest automation ROI.


### 2. Business and User Impact

Automation should protect the most critical parts of the product.

Examples of **high-impact workflows**:

* Authentication and login
* Payment processing
* Account creation
* Data integrity operations
* Core product workflows

If these areas fail, the impact on users and the business can be significant.


### 3. Feature Stability

Automating unstable features often leads to brittle tests.

Avoid automation when:

* UI elements are frequently redesigned
* Requirements are still evolving
* Features are experimental

It is usually better to **wait until the feature stabilizes** before investing in automation.


### 4. Test Determinism

A strong automation candidate should produce **predictable results**.

Good automated tests are:

* Deterministic (same input produces same output)
* Scriptable
* Observable with clear pass/fail conditions

Tests that require **human interpretation or visual judgment** are typically poor candidates for automation.


### 5. Maintenance Cost

Every automated test must be maintained over time.

Tests that are expensive to maintain often include:

* Highly dynamic UI workflows
* Complex environment dependencies
* Multi-system integration setups

Automation should reduce effort—not create long-term maintenance burdens.


## Aligning Automation with the Test Pyramid

A strong QA automation strategy also respects the **test pyramid**.

<div style="position: relative; width: 500px; margin: 20px auto; background: white; padding: 12px; border-radius: 6px;">

  <!-- Copy Button -->
  <button onclick="copyPyramidImage()"
          style="position: absolute; top: 10px; right: 10px; padding: 4px 8px; font-size: 14px; cursor: pointer; background-color: black; color: white;">
    Copy
  </button>

  <!-- Pyramid SVG -->
  <svg id="testPyramidSVG" width="480" height="420" xmlns="http://www.w3.org/2000/svg">

    <!-- Outer pyramid -->
    <polygon points="240,30 10,390 470,390"
             fill="white" stroke="black" stroke-width="3" />

    <!-- Horizontal lines that meet the triangle edges -->
    <!-- Line 1: intersects left and right triangle edges at y=190 -->
    <line x1="150" y1="170" x2="332" y2="170" stroke="black" stroke-width="3" />

    <!-- Line 2: intersects left and right triangle edges at y=260 -->
    <line x1="90" y1="260" x2="389" y2="260" stroke="black" stroke-width="3" />

    <!-- UI Tests -->
    <text x="240" y="120" text-anchor="middle" font-size="24" font-weight="bold">
      UI Tests
    </text>
    <text x="240" y="145" text-anchor="middle" font-size="18">
      (Few &amp; Critical)
    </text>

    <!-- Integration Tests -->
    <text x="240" y="215" text-anchor="middle" font-size="24" font-weight="bold">
      Integration Tests
    </text>
    <text x="240" y="240" text-anchor="middle" font-size="18">
      (Moderate)
    </text>

    <!-- Unit / API Tests -->
    <text x="240" y="310" text-anchor="middle" font-size="24" font-weight="bold">
      Unit / API Tests
    </text>
    <text x="240" y="340" text-anchor="middle" font-size="18">
      (Many &amp; Fast)
    </text>

  </svg>
</div>

<script>
async function copyPyramidImage() {
  const svg = document.getElementById("testPyramidSVG");
  const svgData = new XMLSerializer().serializeToString(svg);

  const canvas = document.createElement("canvas");
  canvas.width = svg.width.baseVal.value;
  canvas.height = svg.height.baseVal.value;
  const ctx = canvas.getContext("2d");

  const img = new Image();
  img.src = "data:image/svg+xml;base64," + btoa(svgData);

  img.onload = async () => {
    ctx.drawImage(img, 0, 0);

    canvas.toBlob(async (blob) => {
      try {
        await navigator.clipboard.write([
          new ClipboardItem({ "image/png": blob })
        ]);
        alert("Pyramid image copied!");
      } catch (err) {
        alert("Copy failed — your browser may not support image clipboard.");
      }
    }, "image/png");
  };
}
</script>


### Key Principles

#### **Unit and API tests should make up the majority of automation.**

When deciding what tests to automate, QA teams should first look for opportunities at the **unit or API layer**. These tests run quickly, are easier to maintain, and are less likely to break due to UI changes. If a feature’s behavior can be validated through an API call or service-level test, it is usually a better automation candidate than testing the same behavior through the UI. Prioritizing automation at this level allows teams to run large numbers of tests in every build and receive rapid feedback when something fails.

#### **Integration tests verify interactions between components.**

Integration tests are valuable automation candidates when the risk lies in **how different parts of the system interact**. For example, a workflow might depend on an API calling another service, writing data to a database, or triggering a downstream process. These interactions are common sources of defects. When deciding what to automate, QA engineers should prioritize integration tests for scenarios where multiple services, systems, or data flows must work together correctly. Automating these interactions helps detect issues that unit tests alone may not catch.

#### **UI tests should focus on critical end-to-end workflows.**

UI automation should be used selectively for **high-value user journeys** that validate the system from the user's perspective. When deciding what UI tests to automate, focus on workflows that are essential to the product, such as login, account creation, or completing a transaction. These tests confirm that the full stack—from the interface to backend services—works together as expected. Less critical UI scenarios can often be covered more efficiently through API or integration tests.

#### **Over-reliance on UI automation often leads to slow and fragile pipelines.**

UI tests typically run slower and are more sensitive to interface changes than lower-level tests. If too many tests are automated at the UI level, test pipelines can become slow and difficult to maintain. When deciding what to automate, QA teams should avoid automating every UI scenario and instead prioritize a smaller set of critical workflows. Keeping most automation at the unit and API levels helps maintain faster feedback cycles and more stable test suites.

## A Simple Automation Scoring Model

QA teams often use this simple scoring model to evaluate potential automation candidates.

<table>
  <thead>
    <tr>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Criterion</th>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Score 1</th>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Score 5</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Frequency</td>
      <td>Rarely executed</td>
      <td>Runs every build</td>
    </tr>
    <tr>
      <td>Business Impact</td>
      <td>Low impact</td>
      <td>Mission critical</td>
    </tr>
    <tr>
      <td>Stability</td>
      <td>Frequently changing</td>
      <td>Very stable</td>
    </tr>
    <tr>
      <td>Determinism</td>
      <td>Hard to automate</td>
      <td>Fully deterministic</td>
    </tr>
    <tr>
      <td>Maintenance Cost</td>
      <td>High cost</td>
      <td>Low cost</td>
    </tr>
  </tbody>
</table>


### Interpreting the Score

The table below shows the two ends of the scoring scale. Scores of 2–4 represent intermediate values between these extremes, allowing teams to estimate how strongly each criterion applies to a particular test.

<table>
  <thead>
    <tr>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Score</th>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Recommendation</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>20–25</strong></td>
      <td>Automate immediately</td>
    </tr>
    <tr>
      <td><strong>14–19</strong></td>
      <td>Strong candidate</td>
    </tr>
    <tr>
      <td><strong>10–13</strong></td>
      <td>Consider partial automation</td>
    </tr>
    <tr>
      <td><strong>Below 10</strong></td>
      <td>Keep manual</td>
    </tr>
  </tbody>
</table>


This method helps QA teams make **consistent and objective automation decisions**.

## Weighted Automation Scoring Model

For many QA Teams, some criteria have a greater influence on automation value than others. A weighted scoring model reflects this by assigning higher importance to factors like business impact and execution frequency.

Each criterion is scored from 1–5, then multiplied by its weight to produce a weighted score. The total score helps prioritize which tests should be automated first.

<table>
  <thead>
    <tr>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Criterion</th>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Description</th>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Weight</th>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Score (1–5)</th>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Weighted Score</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Execution Frequency</strong></td>
      <td>How often the test is executed</td>
      <td>3</td>
      <td>1–5</td>
      <td>Score × 3</td>
    </tr>
    <tr>
      <td><strong>Business Impact</strong></td>
      <td>Risk to users or the business if the feature fails</td>
      <td>3</td>
      <td>1–5</td>
      <td>Score × 3</td>
    </tr>
    <tr>
      <td><strong>Feature Stability</strong></td>
      <td>How stable the feature or interface is</td>
      <td>2</td>
      <td>1–5</td>
      <td>Score × 2</td>
    </tr>
    <tr>
      <td><strong>Determinism</strong></td>
      <td>How reliably the test can produce consistent results</td>
      <td>2</td>
      <td>1–5</td>
      <td>Score × 2</td>
    </tr>
    <tr>
      <td><strong>Maintenance Cost</strong></td>
      <td>Expected long-term maintenance effort</td>
      <td>2</td>
      <td>1–5</td>
      <td>Score × 2</td>
    </tr>
  </tbody>
</table>

### Example Weighted Score Calculation

<table>
  <thead>
    <tr>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Criterion</th>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Score</th>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Weight</th>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Weighted Score</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Execution Frequency</td>
      <td>5</td>
      <td>3</td>
      <td>15</td>
    </tr>
    <tr>
      <td>Business Impact</td>
      <td>4</td>
      <td>3</td>
      <td>12</td>
    </tr>
    <tr>
      <td>Feature Stability</td>
      <td>4</td>
      <td>2</td>
      <td>8</td>
    </tr>
    <tr>
      <td>Determinism</td>
      <td>5</td>
      <td>2</td>
      <td>10</td>
    </tr>
    <tr>
      <td>Maintenance Cost</td>
      <td>3</td>
      <td>2</td>
      <td>6</td>
    </tr>
    <tr>
      <td><strong>Total</strong></td>
      <td></td>
      <td></td>
      <td><strong>51</strong></td>
    </tr>
  </tbody>
</table>

### Interpreting the Weighted Score

This weighted approach helps QA teams prioritize automation efforts more effectively, ensuring that automation work focuses on tests that deliver the highest value and risk reduction.

<table>
  <thead>
    <tr>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Total Score</th>
      <th style="text-align:center; font-weight: 900; background-color: #bc960d;">Recommendation</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>45+</strong></td>
      <td>High priority for automation</td>
    </tr>
    <tr>
      <td><strong>30–44</strong></td>
      <td>Good candidate for automation</td>
    </tr>
    <tr>
      <td><strong>20–29</strong></td>
      <td>Consider partial or lower-priority automation</td>
    </tr>
    <tr>
      <td><strong>Below 20</strong></td>
      <td>Keep manual for now</td>
    </tr>
  </tbody>
</table>


## Common Automation Mistakes QA Teams Make

### Automating Too Early

Automating unstable features leads to constant test failures and wasted effort.

### Automating Everything

Some tests are better suited for **manual or exploratory testing**.

### Ignoring Maintenance Costs

Automation that requires constant repair can become a liability.

### Overusing UI Automation

UI tests are valuable but should be **used sparingly and strategically**.


## Practical Starting Points for QA Engineers

If you're building or expanding an automation suite, start with:

* High-value regression tests
* Smoke tests in CI pipelines
* Critical user workflows
* API-level validations
* Stable, deterministic scenarios

These tests usually provide the **fastest return on automation investment**.


## Conclusion

Effective test automation is not about achieving 100% automation coverage. It is about **strategically selecting the tests that deliver the greatest long-term value**.

By evaluating test candidates based on:

* Execution frequency
* Business impact
* Feature stability
* Determinism
* Maintenance cost

QA engineers can build automation suites that are **reliable, scalable, and sustainable**.

Thoughtful automation leads to faster feedback, more confident releases, and stronger software quality.


## FAQ

### Should QA teams aim for 100% automation?

No. Some tests require human judgment or exploratory investigation and are better executed manually.

### When is UI automation appropriate?

UI automation is most valuable for **critical end-to-end workflows** that validate the full user experience.

### What tests should be automated first?

Start with:

* Regression tests
* Smoke tests
* High-risk workflows
* API-level validations

These typically deliver the fastest return.

### How often should automation suites be reviewed?

Automation suites should be reviewed regularly—ideally **every sprint**—to remove flaky tests, update outdated scenarios, and reassess priorities.
