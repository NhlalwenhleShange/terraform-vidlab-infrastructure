# VidLab Infrastructure

This is the Terraform setup for the cloud backend of my video-to-picture app. Instead of clicking around the Azure portal, this script provisions all the required resources in one go.

## What it deploys:
- **Resource Group** ('rg-vidlab-prod')
- **Azure Container Registry** ('vidlabacrprod01') for storing Docker images
- **Storage Account** ('vidlabstprod01') with two private containers: 'videos' and 'frames'
- **Container Apps Environment** + **Log Analytics** to host and monitor the app

## How to use it:

Make sure you have Terraform and the Azure CLI installed, then log in:
bash
az login