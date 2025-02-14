# Felix Travieso - KD Pre-screen Project

Alright, so hi there, my name is Felix Travieso and I'm a DevOps Engineer with a background in IT and system administration.  
Although if you are reading this you might probably already have my resume, so that's nothing new.

Thank you for taking the time to consider me for your open DevOps position.

As requested in your specifications, this repository contains my best attempt at completing the project you've outlined, and quite a fun project it's been.  
That being said, trying to finish this in the roughly 4 days I was given was proving a bit of a challenge, so I admittedly cut a few corners to turn around a product that still checks most boxes.

## Nitty Gritty

To dive right into the goodies, the rest of this README is going to be split up into two sections. 
- One is going to be a quick explanation of the project layout, and what things do. 
- The other is going to be a pseudo checklist of each requirement and how they were met.

## Project Layout

### Source Code (Python)

To write the services I decided to go with Python. Partly because it's easy, but mainly because it's just what I'm most familiar with.  
I could have gone .NET, but that wasn't one of the listed options, and it probably would have just made me take longer if it was.

The code for the application can be found in the `src` folder (adding this for completeness, not because I think you need help finding it) and it was written using Flask, with SQLAlchemy used for my ORM. 

I split the code up into 3 separate files (one for each service). Inside the `docker` folder I have Dockerfiles for running both the display and reset services.  
I did **not** include a Dockerfile for the adder service as that's the one I chose to deploy to a VM.

The final layout for the app once all the services are running looks like this:

- `127.0.0.1` Home page
- `127.0.0.1/adder_service` Adder Service
- `127.0.0.1/display_service` Display Service
- `127.0.0.1/reset_service` Reset Service

There are a few other endpoints that serve as a backend to receive button presses from the UI and so forth but those aren't important for this explanation.

I'll include some screenshots in a section further down of what the app looks like if you don't want to run it yourself.

### Terraform

This is definitely where the bulk of the work for this project was, and I'm sure that was intentional. 

The way I like to write Terraform is to split out all the resources into separate files based on resource type.  
Sometimes I do group based on a common objective, and I did that in a few places, but my brain usually works best with stricter separation.

The Terraform should be ready to rock with the included `.tfvars` and defaults file assuming you:

- Have your AWS cli configured and authenticated
- You update the `allowed_bastion_ips` variable
- Have your SSH key at `~/.ssh/id_rsa.pub`

This will spin up all the resources needed to deploy the app in `us-east-1`, and it'll spit out a load balancer IP address that you can then hit to reach the application. It'll be unsecured mind you, which kind of goes against specification `6. Security and Availability`, but at least you're not providing credentials.

I chose to run the adder service as a VM to meet that requirement, and I ran both the display and reset services as Docker containers on ECS to meet the other two. I'll explain why I did that in more detail in the checklist section.

### GitHub Actions

There are two GitHub Action workflows in this repository.

- `build-containers.yml` performs it's namesake and builds and uploads both Docker containers whenever there is a push to the main branch.
- `terraform-plan-apply.yml` needs to be run manually, but it executes a Terraform plan and then goes into a manual approval gate before applying that same plan.

GitHub PATs and AWS secrets are all configured in the repo settings, although I can't really provide you with that so please take my word for it.

### Docker

Not much to write home about here, I debated even including this section, but figured why the hell not.

The Dockerfiles are nothing to write home about, no fancy tricks here, just the bare minimum I needed to run my Flask apps. They work, the end.

## Checklist

Below I'm going to go systematically through the requirements listed in the project spec, and justify how and where I satisfied them.

### General Infrastructure

- Web Ingress via load balancer
  - All data flow into the application is handled by an application load balancer that routes to the different services using different listeners for different sub-paths, each leading to their respective AWS resource.
- Persistent Data Storage via PostgreSQL database
  - I use RDS to create a PostgreSQL server, and then I pass the connection information along to the applications by injecting environment variables using Terraform. The schema is created using SQLAlchemy and can be found in the `/src/db/project_table.py` file.

### Application Requirements

- Adder Service, display service, and reset service
  - More information can be found in the [Python section](#source-code-python).   
  The services all implement the basic functionality that was described for each of them. Also not sure if this was intentional but both the adder and display services were supposed to "**Display the sum of all values in the "value" column of the database.**", I wasn't sure if this was intentional, but I mean, it was in the spec, so I added it anyways.

### Deployment Infrastructure Requirements

- One service deployed on a virtual machine
  - This was easy enough, the adder service is deployed to a VM using a user_data script that pulls down the code and configures the app as a service.
- One service must be deployed within a containerized environment/using a serverless compute technology
  - Okay here you *may* consider that I have cheated somewhat, but let me explain.  
  ECS is a containerized environment and a container orchestration service, so that's check one, and because I am using Fargate as the host instead of setting up my own instances, it technically also leverages serverless compute. I really hope you either see this my way or find my logic clever enough to not deduct any mental or very real points that may or may not exist.
- Bastion access
  - A locked down virtual machine is spun up with a public IP address and your SSH key already configured. Just make sure you update the tfvars to add your IP address to the security group. This isn't how I'd personally do a Bastion server but it's definitely the simplest.
- Centralized Logging
  - Console logs for each service are all configured to be sent over to CloudWatch, each with their own log group. Doing this on the VM was something new for me as I had to figure out the Amazon CloudWatch agent which I didn't even know existed.
- Autoscaling
  - The display service in ECS is configured with an autoscaling policy based on the number of requests received.  
  That being said, this is one of the few things I did not test, as I didn't have the time to setup proper load testing aaaaaaand I didn't want to risk increasing my AWS bill anymore than I already had.

### Security Logging

- Denied traffic logging to object storage service
  - For this I setup a VPC flow log to store logs for all denied traffic, pretty straightforward