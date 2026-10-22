
# How to Create an Azure DevOps Pipleline

## 1. Microsoft — Create Your First Azure DevOps Pipeline
Documentation URL:

https://learn.microsoft.com/en-us/azure/devops/pipelines/create-first-pipeline?view=azure-devops

This beginner-friendly Microsoft guide provides step-by-step instructions for creating a YAML pipeline, connecting it to a Git repository, configuring the pipeline, and executing it.

How it relates to ABC_Login: The instructions help beginner QA testers understand how to create the Regression-Pipeline and Retest-Pipeline in Azure DevOps using the existing azure-pipelines.yml and azure-retest-pipeline.yml files in the ABC_Login repository. 

Microsoft Learn



Steps for creating your ABC_Login pipelines
Because your YAML files already exist, you can use the following procedure:
1. Open your Azure DevOps project.
2. Select Pipelines → New pipeline.
3. Under Where is your code?, select Azure Repos Git.
4. Select your ABC_Login repository.
5. Choose Existing Azure Pipelines YAML file.
6. Select /azure-pipelines.yml to create your Regression pipeline.
7. Save the pipeline and rename it Regression-Pipeline.
8. Repeat the procedure, selecting /azure-retest-pipeline.yml to create Retest-Pipeline.
Before execution, verify that both pipelines can use your self-hosted agent pool and that the secret variable AZURE_PAT is configured.

2. Microsoft — Override the YAML Continuous Integration Trigger
Documentation URL:

https://learn.microsoft.com/en-us/azure/devops/pipelines/repos/azure-repos-git?view=azure-devops

This Microsoft guide explains how YAML pipelines work with Azure Repos Git repositories, including how to configure Continuous Integration triggers.

It also explains how to override the YAML CI trigger using pipeline settings without modifying the YAML file itself.

How it relates to ABC_Login: Your Regression pipeline has a CI trigger that automatically starts a pipeline execution whenever changes are pushed to the main branch.

When you're updating the automation scripts or preparing new training materials, you might prefer to temporarily prevent the Regression pipeline from executing after every Git push. 

Microsoft Learn



Steps to temporarily override the CI trigger
1. Open your Azure DevOps project.
2. Select Pipelines.
3. Open Regression-Pipeline.
4. Select Edit.
5. Select the three-dot menu (...) → Triggers.
6. Under Continuous integration, select Override the YAML continuous integration trigger from here.
7. Configure the branch filters so that no branches used by your project will trigger an automatic run. For example, exclude main, and ensure other branches aren't included.
8. Save your changes.
Your YAML file remains unchanged. You can still start the pipeline manually using Run pipeline.

To restore automatic execution, return to the same settings and clear the override option. Azure DevOps will again use the CI trigger defined in your YAML file.

Important: This only changes the CI trigger. It does not necessarily disable scheduled, pull-request validation, or other separately configured triggers.

3. Microsoft — Troubleshoot Azure Pipeline Triggers
Documentation URL:

https://learn.microsoft.com/en-us/azure/devops/pipelines/troubleshooting/troubleshoot-triggers?view=azure-devops

Explains how to troubleshoot pipelines that execute unexpectedly or fail to execute when expected, including how trigger settings in the Azure DevOps interface can override the YAML configuration.

How it relates to ABC_Login: This reference helps beginner QA testers investigate why the Regression pipeline automatically executes after a Git push or why a pipeline does not start when expected. 

Microsoft Learn
