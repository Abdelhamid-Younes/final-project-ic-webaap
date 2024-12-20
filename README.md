# Devops Final Project IC-GROUP

![](images/CI_CD_Pipeline.png)

## Project overview

The **Devops Final Project** is the final project as part of the DevOps training program at [Eazytraining](https://eazytraining.fr/) school. Its goal is to provide both a practical and theoretical demonstration of the technical skills acquired during the DevOps Bootcamp, including **Docker**, **GitLab-CI**, **Jenkins**, **Terraform**, **Ansible**, and **Kubernetes**.

In this project, I implemented a comprehensive solution that includes:

- Containerization of applications.
- Setting up a CI/CD pipeline.
- Deploying applications on AWS ec2 using Ansible and docker-compose.

The applications involved are:
- **Odoo**: A multifunctional ERP used for enterprise management.
- **PgAdmin**: A graphical tool for managing PostgreSQL databases.
- **Ic-webapp**: A showcase website chich is containerized for easier deployment and management.

This project also demonstrates the integration of various tools and technologies to achieve automation, scalability, and efficient application deployment.

# Table of Contents  

[**Project overview**](#Project overview)

## PART 1: Web Application Containerization

This part outlines the steps to containerize the web application using Docker.
- The Docker image is based on `python:3.6-alpine`.
- The working directory is set to `/opt`.
-  Install the Flask module, version `1.1.2`.
- Expose the port `8080` as the default application port.
- Create two environment variables: `ODOO_URL`: to define the URLs of the Odoo and `PGADMIN_URL` applications.
- Launch the application by running `app.py` using the command `python` in the `ENTRYPOINT`.
- Create a `Dockerfile` with the above configurations.
- Build the Docker image using the following command:

  ```bash
  $ docker build -t ic-webapp:1.0 .

- Launch a test container to verify the functionality:

  ```bash
  $ docker run --name ic-webapp-test -d -p 8080:8080 ic-webapp:1.0

- Once the test is successful, remove the test container:

  ```bash
  $ docker rm -f ic-webapp-test

- Push the image to Docker Hub:
  ```bash
  $ docker tag ic-webapp:1.0 younesabdh/ic-webapp:1.0
  $ docker push younesabdh/ic-webapp:1.0



