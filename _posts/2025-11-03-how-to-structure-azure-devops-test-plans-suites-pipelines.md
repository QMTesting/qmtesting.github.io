---
layout: post
title: "How to Automate Test Plans and Suites With Azure DevOps Pipelines"
categories: ["Automation"]
image: /assets/images/DevOps/TestPlans-Suites-Pipelines.webp
permalink: /how-to-structure-azure-devops-test-plans-suites-pipelines/
tags: [software testing, QA, QC, Azure DevOps, automation, test plans, suites, pipelines]
description: "A guide on how to automate How to Automate Test Plans and Suites With Azure DevOps Pipelines."
---

<figure>
  <img src="/assets/images/DevOps/TestPlans-Suites-Pipelines.webp" alt="Automate Test Plans and Suites With Pipelines" />
  <figcaption>Image by Freepik</figcaption>
</figure>


Managing Azure DevOps Test Plans manually becomes painful fast — especially when every sprint requires:

- A new Test Plan  
- New Test Suites for each User Story  
- Linking existing Test Cases  
- Keeping everything aligned with iteration paths  

The good news: **you can automate all of it** using Azure DevOps REST APIs, PowerShell, and a simple YAML pipeline.

This guide shows you exactly how to:

- Create Test Plans automatically  
- Create Test Suites per User Story  
- Link Test Cases  
- Run everything inside an Azure DevOps Pipeline  

Let’s make your sprint setup fully hands‑free.


## 🧭 **1. Why Automate Test Plans and Suites?**

Automation solves the biggest pain points in sprint‑based QA:

### **Benefits**
- **Zero manual setup** — no more clicking through Test Plans UI  
- **Guaranteed consistency** — naming, structure, and traceability stay clean  
- **Instant sprint readiness** — Test Plans are created the moment a sprint starts  
- **Better DevOps alignment** — pipelines become the source of truth  
- **Scalable** — works for 5 stories or 500  


## 🧱 **2. Recommended Structure for Automated Test Plans**

<div class="table-scroll">
<table>
  <thead>
    <tr>
      <th style="text-align:center; font-size: 20px; font-weight: 900; background-color: #bc960d; width: 155px;">Element</th>
      <th style="text-align:center; font-size: 20px; font-weight: 900; background-color: #bc960d; width: 185px;">Best Practice</th>
      <th style="text-align:center; font-size: 20px; font-weight: 900; background-color: #bc960d; width: 185px;">Why</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Test Plan</strong></td>
      <td>One per sprint</td>
      <td>Clean historical record + sprint alignment</td>
    </tr>
    <tr>
      <td><strong>Test Suite</strong></td>
      <td>One per User Story</td>
      <td>Perfect traceability</td>
    </tr>
    <tr>
      <td><strong>Test Cases</strong></td>
      <td>Linked to User Story + Suite</td>
      <td>Enables reporting + automation</td>
    </tr>
    <tr>
      <td><strong>Pipeline</strong></td>
      <td>One automation pipeline</td>
      <td>Runs every sprint or on demand</td>
    </tr>
  </tbody>
</table>
</div>


## ⚙️ **3. Azure DevOps REST APIs You Will Use**

Azure DevOps exposes the following endpoints for test management:

<div class="table-scroll">
<table>
  <thead>
    <tr>
      <th style="text-align:center; font-size: 20px; font-weight: 900; background-color: #bc960d; width: 100px;">Purpose</th>
      <th style="text-align:center; font-size: 20px; font-weight: 900; background-color: #bc960d; width: 200px;">Endpoint</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Create Test Plan</td>
      <td><code>POST /_apis/test/plans</code></td>
    </tr>
    <tr>
      <td>Create Test Suite</td>
      <td><code>POST /_apis/test/plans/{planId}/suites</code></td>
    </tr>
    <tr>
      <td>Add Test Case to Suite</td>
      <td><code>POST /_apis/test/plans/{planId}/suites/{suiteId}/testcases/{testCaseId}</code></td>
    </tr>
    <tr>
      <td>Query Work Items (WIQL)</td>
      <td><code>POST /_apis/wit/wiql</code></td>
    </tr>
    <tr>
      <td>Get Work Item Details</td>
      <td><code>GET /_apis/wit/workitems/{id}</code></td>
    </tr>
  </tbody>
</table>
</div>

All examples below use **API version 7.1-preview**.


## 🧩 **4. Full PowerShell Script: Create Test Plans, Suites, and Link Test Cases**

This script:

- Creates a Test Plan for the sprint  
- Queries all active User Stories in that sprint  
- Creates a Static Test Suite for each story  
- Finds all linked Test Cases  
- Adds them to the suite  

It includes improved error handling, logging, and naming conventions.


## **PowerShell Script**

```powershell


# ==========================================
# Azure DevOps Test Plan Automation Script
# 2025 Updated Version
# ==========================================

param(
    [string]$OrgUrl = "https://dev.azure.com/YOURORG",
    [string]$Project = "YOURPROJECT",
    [string]$SprintName = "Sprint 18"
)

# Use System.AccessToken inside Azure DevOps Pipeline
$Token = $env:SYSTEM_ACCESSTOKEN
if (-not $Token) {
    throw "SYSTEM_ACCESSTOKEN is not available. Enable 'Allow scripts to access OAuth token' in the pipeline."
}

$Headers = @{
    Authorization = "Bearer $Token"
    "Content-Type" = "application/json"
}

$IterationPath = "$Project\$SprintName"
$AreaPath = $Project

Write-Host "🔧 Starting automation for $SprintName..."

# ---------------------------------------------------------
# 1. Create Test Plan
# ---------------------------------------------------------
$PlanBody = @{
    name      = "$SprintName - Test Plan"
    area      = @{ path = $AreaPath }
    iteration = $IterationPath
} | ConvertTo-Json -Depth 10

$PlanUri = "$OrgUrl/$Project/_apis/test/plans?api-version=7.1-preview.1"
$Plan = Invoke-RestMethod -Uri $PlanUri -Method Post -Headers $Headers -Body $PlanBody

$PlanId = $Plan.id
Write-Host "📘 Created Test Plan: $PlanId"

# ---------------------------------------------------------
# 2. Query User Stories in Sprint
# ---------------------------------------------------------
$Wiql = @"
SELECT [System.Id], [System.Title]
FROM WorkItems
WHERE [System.WorkItemType] = 'User Story'
AND [System.State] <> 'Closed'
AND [System.IterationPath] = '$IterationPath'
"@

$QueryBody = @{ query = $Wiql } | ConvertTo-Json
$QueryUri = "$OrgUrl/$Project/_apis/wit/wiql?api-version=7.1-preview.2"

$UserStories = Invoke-RestMethod -Uri $QueryUri -Method Post -Headers $Headers -Body $QueryBody

if ($UserStories.workItems.Count -eq 0) {
    Write-Host "⚠️ No active User Stories found for $SprintName."
    exit 0
}

# ---------------------------------------------------------
# 3. Create Test Suites + Link Test Cases
# ---------------------------------------------------------
foreach ($Story in $UserStories.workItems) {

    $StoryId = $Story.id
    $StoryDetails = Invoke-RestMethod -Uri "$OrgUrl/$Project/_apis/wit/workitems/$StoryId?api-version=7.1-preview.3" -Headers $Headers
    $StoryTitle = $StoryDetails.fields.'System.Title'

    Write-Host "🧩 Processing User Story $StoryId - $StoryTitle"

    # Create Static Suite
    $SuiteBody = @{
        suiteType = "StaticTestSuite"
        name      = "US$StoryId - $StoryTitle"
    } | ConvertTo-Json -Depth 10

    $SuiteUri = "$OrgUrl/$Project/_apis/test/plans/$PlanId/suites?api-version=7.1-preview.3"
    $Suite = Invoke-RestMethod -Uri $SuiteUri -Method Post -Headers $Headers -Body $SuiteBody

    $SuiteId = $Suite.id
    Write-Host "📁 Created Suite $SuiteId for User Story $StoryId"

    # Get linked Test Cases
    $Relations = $StoryDetails.relations `
        | Where-Object { $_.rel -eq "System.LinkTypes.Hierarchy-Forward" -and $_.url -match "/workItems/" }

    $TestCaseIds = @()
    foreach ($Rel in $Relations) {
        if ($Rel.url -match "/workItems/(\d+)") {
            $TestCaseIds += $Matches[1]
        }
    }

    if ($TestCaseIds.Count -eq 0) {
        Write-Host "⚠️ No test cases linked to User Story $StoryId"
        continue
    }

    # Add Test Cases to Suite
    foreach ($TcId in $TestCaseIds) {
        $AddUri = "$OrgUrl/$Project/_apis/test/plans/$PlanId/suites/$SuiteId/testcases/$TcId?api-version=7.1-preview.3"
        Invoke-RestMethod -Uri $AddUri -Method Post -Headers $Headers
        Write-Host "🔗 Linked Test Case $TcId → Suite $SuiteId"
    }
}

Write-Host "🎉 Automation complete for $SprintName!"
```


## 🚀 **5. YAML Pipeline to Run the Automation**

This pipeline:

- Runs the PowerShell script  
- Passes sprint name dynamically  
- Uses `System.AccessToken`  
- Can be scheduled or triggered manually  

## **azure-pipelines.yml**

```yaml


trigger: none

parameters:
  - name: sprintName
    type: string
    default: "Sprint 18"

pool:
  vmImage: 'windows-latest'

steps:
  - checkout: self

  - task: PowerShell@2
    displayName: "Automate Test Plan + Suites"
    inputs:
      targetType: inline
      script: |
        Write-Host "Running automation for: ${{ parameters.sprintName }}"

        ./automation/Create-TestPlan.ps1 `
          -OrgUrl "https://dev.azure.com/YOURORG" `
          -Project "YOURPROJECT" `
          -SprintName "${{ parameters.sprintName }}"

    env:
      SYSTEM_ACCESSTOKEN: $(System.AccessToken)

```


## 🧠 **6. Best Practices for Automated Test Plan Management**

<div class="table-scroll">
<table>
  <thead>
    <tr>
      <th style="text-align:center; font-size: 20px; font-weight: 900; background-color: #bc960d; width: 100px;">Area</th>
      <th style="text-align:center; font-size: 20px; font-weight: 900; background-color: #bc960d; width: 100px;">Best Practice</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Naming</strong></td>
      <td>Use <code>US1234 - Title</code> for suites</td>
    </tr>
    <tr>
      <td><strong>Traceability</strong></td>
      <td>Always link Test Cases to User Stories</td>
    </tr>
    <tr>
      <td><strong>Regression</strong></td>
      <td>Keep a separate long‑lived Regression Plan</td>
    </tr>
    <tr>
      <td><strong>Automation</strong></td>
      <td>Run this pipeline at sprint creation</td>
    </tr>
    <tr>
      <td><strong>Governance</strong></td>
      <td>Lock Test Plans after sprint ends</td>
    </tr>
  </tbody>
</table>
</div>


## 🏁 **Conclusion**

Automating your Azure DevOps Test Plans removes repetitive manual work and ensures your sprint structure is always:

- Clean  
- Consistent  
- Traceable  
- Audit‑ready  
- Automation‑friendly  

With PowerShell + Azure DevOps REST APIs + YAML pipelines, you can generate an entire sprint’s test structure in seconds — and focus your time on actual testing, not setup.

<style>
  @media only screen and (max-width: 780px) {
    .language-powershell highlighter-rouge {
       width: 400px;
    }
  }
</style>  
