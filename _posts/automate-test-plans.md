---
layout: post
title: "How to Automate Azure DevOps Test Plan Creation and Updates Using PowerShell and REST API"
description: "Learn how to automate Azure DevOps Test Plan creation, Test Suites, and Test Case updates for each sprint using PowerShell and the Azure DevOps REST API. Includes step-by-step setup and script examples."
date: 2025-10-17
author: Margaret
categories: [Azure DevOps, QA, Automation, PowerShell]
tags: [Azure DevOps, Test Plans, REST API, PowerShell, Automation, Sprint Testing, QA Engineering]
image: /assets/images/azure-devops-testplan-automation.jpg
---

# **How to Automate Azure DevOps Test Plan Creation and Updates Using PowerShell and REST API**

## **Introduction**

Manually creating and organizing Test Plans for every sprint in Azure DevOps can become time-consuming—especially for large teams with multiple features and test cases. Fortunately, **Azure DevOps REST APIs** make it possible to automate these actions.

In this post, you’ll learn how to **automate Test Plan creation, Test Suites, and Test Cases** using **PowerShell scripts** integrated with your Azure DevOps project.  
This automation not only saves time but also ensures consistent naming conventions, traceability, and quality across sprints.

---

## **1. Prerequisites**

Before starting, make sure you have the following:

- **Azure DevOps Organization URL** (e.g., `https://dev.azure.com/yourorgname/`)
- **Project Name** (e.g., `MyProject`)
- **Personal Access Token (PAT)** with permissions for Test Management or **System.AccessToken** from a pipeline
- **PowerShell (5.1 or later)** on your system or self-hosted agent
- **REST API endpoints** for:
  - Creating Test Plans  
  - Adding Test Suites  
  - Creating and linking Test Cases

---

## **2. Set Up Variables in PowerShell**

Start your script by defining the key variables for your Azure DevOps organization, project, and authentication.

```powershell
# Azure DevOps configuration
$organization = "https://dev.azure.com/yourorgname"
$project = "MyProject"
$iterationPath = "MyProject\\Sprint_12"
$baseUrl = "$organization/$project/_apis"

# Authentication
# Option 1: Using PAT
$pat = "YOUR_PERSONAL_ACCESS_TOKEN"
$encodedAuth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$pat"))

# Option 2 (recommended in pipeline): Use System.AccessToken
# $encodedAuth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$env:SYSTEM_ACCESSTOKEN"))

# Create JSON body for the new Test Plan
$body = @{
    name = "Sprint_12_Test_Plan"
    area = @{ path = $project }
    iteration = @{ path = $iterationPath }
    description = "Automated Test Plan for Sprint 12"
} | ConvertTo-Json

# API call
$response = Invoke-RestMethod -Uri "$baseUrl/testplan/plans?api-version=7.1-preview.1" `
    -Method Post `
    -Headers @{ Authorization = "Basic $encodedAuth"; "Content-Type" = "application/json" } `
    -Body $body

$testPlanId = $response.id
Write-Host "✅ Test Plan created with ID: $testPlanId"

This creates a Test Plan under your sprint iteration path and returns a unique Test Plan ID for later use.

4. Add Test Suites for Each User Story

Next, create Test Suites under the new Test Plan.
Each suite can represent a User Story, Feature, or Testing Category.

# Example list of user stories
$userStories = @(
    @{ title = "User Story 101 - Login Authentication" },
    @{ title = "User Story 102 - Add Item to Cart" },
    @{ title = "User Story 103 - Checkout and Payment" }
)

foreach ($story in $userStories) {
    $suiteBody = @{
        suiteType = "staticTestSuite"
        name = $story.title
        parentSuite = @{ id = 1 }  # Root suite
    } | ConvertTo-Json

    $suiteResponse = Invoke-RestMethod -Uri "$baseUrl/testplan/Plans/$testPlanId/suites?api-version=7.1-preview.1" `
        -Method Post `
        -Headers @{ Authorization = "Basic $encodedAuth"; "Content-Type" = "application/json" } `
        -Body $suiteBody

    Write-Host "🗂️ Created Test Suite: $($story.title)"
}

Each suite will appear under your newly created Test Plan in Azure DevOps.

5. Add or Link Test Cases

You can also create new test cases dynamically or link existing ones.

Option 1: Create new test cases

$testCases = @(
    @{ title = "Verify login with valid credentials"; steps = "Enter username, password, click Login"; expected = "Dashboard loads successfully" },
    @{ title = "Verify login with invalid credentials"; steps = "Enter invalid password"; expected = "Error message displayed" }
)

foreach ($test in $testCases) {
    $testBody = @{
        fields = @{
            "System.Title" = $test.title
            "Microsoft.VSTS.TCM.Steps" = "<steps id='0' type='ActionStep'><parameterizedString isformatted='true'>$($test.steps)</parameterizedString><parameterizedString isformatted='true'>$($test.expected)</parameterizedString></steps>"
        }
    } | ConvertTo-Json

    $createTestCase = Invoke-RestMethod -Uri "$organization/$project/_apis/wit/workitems/\$testcase?api-version=7.1-preview.3" `
        -Method Post `
        -Headers @{ Authorization = "Basic $encodedAuth"; "Content-Type" = "application/json-patch+json" } `
        -Body $testBody

    Write-Host "🧪 Created Test Case: $($test.title)"
}

$testCases = @(
    @{ title = "Verify login with valid credentials"; steps = "Enter username, password, click Login"; expected = "Dashboard loads successfully" },
    @{ title = "Verify login with invalid credentials"; steps = "Enter invalid password"; expected = "Error message displayed" }
)

foreach ($test in $testCases) {
    $testBody = @{
        fields = @{
            "System.Title" = $test.title
            "Microsoft.VSTS.TCM.Steps" = "<steps id='0' type='ActionStep'><parameterizedString isformatted='true'>$($test.steps)</parameterizedString><parameterizedString isformatted='true'>$($test.expected)</parameterizedString></steps>"
        }
    } | ConvertTo-Json

    $createTestCase = Invoke-RestMethod -Uri "$organization/$project/_apis/wit/workitems/\$testcase?api-version=7.1-preview.3" `
        -Method Post `
        -Headers @{ Authorization = "Basic $encodedAuth"; "Content-Type" = "application/json-patch+json" } `
        -Body $testBody

    Write-Host "🧪 Created Test Case: $($test.title)"
}

Option 2: Link existing test cases to a suite

$existingTestCaseIds = @(2345, 2346, 2347)

foreach ($id in $existingTestCaseIds) {
    $addCase = @{
        workItemIds = @($id)
    } | ConvertTo-Json

    Invoke-RestMethod -Uri "$baseUrl/testplan/Plans/$testPlanId/suites/1/testcases/$id?api-version=7.1-preview.1" `
        -Method Post `
        -Headers @{ Authorization = "Basic $encodedAuth"; "Content-Type" = "application/json" } `
        -Body $addCase
}

6. Update Test Run Results Automatically

After automation runs (for example, Selenium or Postman tests), you can automatically update results in Azure DevOps:

$testRunBody = @{
    name = "Sprint_12_Automation_Run"
    plan = @{ id = $testPlanId }
    automated = $true
} | ConvertTo-Json

$runResponse = Invoke-RestMethod -Uri "$baseUrl/test/runs?api-version=7.1-preview.3" `
    -Method Post `
    -Headers @{ Authorization = "Basic $encodedAuth"; "Content-Type" = "application/json" } `
    -Body $testRunBody

$testRunId = $runResponse.id
Write-Host "🚀 Created test run ID: $testRunId"

You can later update individual test results using:

PATCH /_apis/test/runs/{runId}/results/{resultId}?api-version=7.1-preview.3

7. Automate the Entire Workflow in an Azure Pipeline

You can easily integrate the script above in your YAML pipeline as a QA setup stage, using the built-in System.AccessToken:

- job: CreateSprintTestPlan
  displayName: "Automate Sprint Test Plan Creation"
  pool: MySelfHostedAgentPool
  steps:
    - task: PowerShell@2
      inputs:
        targetType: 'filePath'
        filePath: '$(System.DefaultWorkingDirectory)/scripts/Create-TestPlan.ps1'
      env:
        SYSTEM_ACCESSTOKEN: $(System.AccessToken)



### Make sure your pipeline settings include:
✅ “Allow scripts to access OAuth token” → Enabled

## 8. Benefits of Automating Test Plan Creation

| **Benefit**      | **Description**                                                                  |
| ---------------- | -------------------------------------------------------------------------------- |
| **Consistency**  | Ensures every sprint Test Plan follows the same structure and naming convention. |
| **Efficiency**   | Reduces manual setup time for QA teams at sprint start.                          |
| **Traceability** | Maintains clear links between test cases, user stories, and sprints.             |
| **Scalability**  | Supports continuous testing workflows with minimal overhead.                     |

## Conclusion

Automating Azure DevOps Test Plan creation with PowerShell and REST APIs allows your QA team to focus on testing—not setup.
By dynamically generating Test Plans, Suites, and Cases for each sprint, you ensure consistent coverage and effortless traceability across your Agile process.

Once you implement this automation, sprint planning becomes faster, more predictable, and better aligned with your DevOps pipeline—resulting in improved quality and collaboration across your entire project lifecycle.
