# Evolution
Cloud first approach for building applications and deploying it with minimal efforts.

### Few Building Blocks
- `IAC`
- `Cloud Native` using tools from CNCF
- `Security`
- `Best Practices`

![alt text](https://github.com/cloud-first-approach/Evolution.infra/blob/main/docs/images/frontpage.png)


# Features and Scope of Project

Evolution is a cloud-enabled, devops-ready practice for any applications, built to be deployed on kubernetes.

- Microservices using Clean Architecture
- Async Communication using Message Queue
- GRPC Communication
- Infrastructure as code
- Service Mesh (Kuma/Istio)
- Container (Podman/docker)
- Terraform

# Prerequisites

Tools and Technologies used in bulding this project

- [.NET Core](https://dotnet.microsoft.com/) - Free. Cross-platform. Open source.
A developer platform for building all your apps!
- [ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/?view=aspnetcore-6.0) - ASP.NET Core to create web apps and services that are fast, secure, cross-platform, and cloud-based
- [Docker](https://www.docker.com/) - OS-level virtualization to deliver software in packages called containers.
- [Redis](https://redis.io/) - The open source, in-memory data store used by millions of developers as a database, cache, streaming engine, and message broker.
- [RabbitMQ](https://www.rabbitmq.com/) - RabbitMQ is one of the most popular open source message brokers.
- [Kubernetes](https://kubernetes.io/) - Kubernetes is an open-source container orchestration system for automating software deployment, scaling, and management. (kind / minikube / EKS / AKS). Kubectl also is required to be setup.
- [Terraform](https://www.terraform.io/) - Terraform is an open-source infrastructure as code software tool created by HashiCorp.
- [Dapr](https://www.terraform.io/) - Dapr in a distributed runtime for applications running on VM or K8s. Get [Microsoft Learning Ebook](https://learn.microsoft.com/en-us/dotnet/architecture/dapr-for-net-developers/)
- [Fluxcd](https://fluxcd.io/) - Flux is a set of continuous and progressive delivery solutions for Kubernetes that are open and extensible. 
- [Flagger](https://www.weave.works/oss/flagger/) - Automate and manage canary and other advanced deployments with Istio, Linkerd, AWS App Mesh or NGINX for traffic shifting. Integrated Prometheus metrics control canary deployment success or failure.
- [ArgoCD](https://argoproj.github.io/cd/) - Declarative continuous delivery with a fully-loaded UI. 
- [Powershell](https://learn.microsoft.com/en-us/powershell/) - PowerShell is a cross-platform task automation solution made up of a command-line shell, a scripting language, and a configuration management framework. PowerShell runs on Windows, Linux, and macOS.
# Project Overview

The setup requires a secret file. private.secrets handy
## OR
Environment variables are required. `AWS_ACCESS_KEY` or `AWS_SECRET_KEY` should be set correctly for s3 access

The project tries to build a simple youtube backend for practice of Dev-Ops. Focusing both on Dev and Ops of a bit.


The Project has few basic components

- `Uploader Api` to be able to upload videos
- `Processor Api` to process Videos and store
- `Streaming Api` to Stream Videos Directly and stored videos.
- `Client` on Blazor


# Deployment

**Learn how to Deploy this project to K8** [Click here](https://github.com/cloud-first-approach/Evolution.infra/blob/main/Deploy/readme.md) 

