This is a demo repo for Terraform running docker locally.
https://www.opsmonkeys.com/2020/09/04/hashicorp-terraform-intro-run-docker-containers-locally/

This is meant to be a very quick and simple introduction to Terraform - a configuration language to help provision, codify, and version control infrastructure and related applications. For more information on Terraform I highly suggest checking out Hashicorp's Terraform documentation:
https://www.terraform.io/docs/index.html

Let's go over a few things you will need to have in order to follow along with this introduction to Terraform. 

Requirements:

Docker - wether you are using MacOS, Windows, Linux, etc you can get and install Docker here: https://www.docker.com/

Terraform - if using MacOS, you can install it using homebrew, or else you can get the binary for most OSes here: https://www.terraform.io/downloads.html

Some sort of IDE or code editor - I prefer Microsoft's VSCode, but you can use any flavor you would like.
Getting started:

Go ahead and open your favorite code editor, and create a new directory to work out of. In this case it doesn't matter what you call it - I will use terraform_local_docker_demo in this case.

Inside this directory we want to create a file called main.tf.


Let's go into this a bit more - what is the main.tf terraform file? This is normally the main file in most terraform based repos or project setup. You will find such things as provider setup, data sources, and configuration for your terraform setup in here.
Inside main.tf we will want to add the provider for docker so that we can use it to provision docker containers on our system. Not actually needed but touching on providers.

```
provider "docker" {
}
```

Ok so what is a Terraform  provider? A Terraform provider is a way for terraform to interact with API sources to provision infrastructure, or interact with applications, or even local tasks.
If this was being run on a remote host, you could pass the host in this provider or use ssh, and apply things such as registry url, credentials, etc for use with docker.

Now I want to get you familiar with some of the most common Terraform commands.

terraform init - will initialize and setup the workspace that it's in
terraform plan - will run a plan, which pulls the state and checks for any changes with your code. It will tell the actions it would perform if you did an apply
terraform apply - this will actually apply or run the code you have written
Now that we have a very quick knowledge on the commands, and at least one terraform configuration file. Let's do a terraform init, and you should see terraform download the docker provider we told it to use. Hint: if you are using version 0.13 or above of terraform you might need to do a terraform 0.13upgrade . which will create another versions.tf file for you.

Now your workspace is ready for some action. Back in main.tf let's go ahead and a few resources to have it call a docker container to run on our local machine. In this we will add resource for the image we would like to pull "busybox" and a resource to create a container from that image and run a command on it. Add the following to your main.tf.

```
# Find the latest busybox image.
resource "docker_image" "busybox" {
  name = "busybox"
  keep_locally = true
}

# Start a busybox container
resource "docker_container" "busybox" {
  name  = "busybox"
  image = docker_image.busybox.latest
  command = ["tail", "-f", "/dev/null"]
}
```

What is a terraform resource? A resource is a declarative object that describes an infrastructure resource to be created and managed. Such Ec2 instances, s3 buckets, docker containers, etc, etc
Now run a terraform plan command, which will create the plan of action for the code we just added. It will output that it wants to create (+) the docker image, and the docker container from it. And reporting two to add, nothing to change, and nothing to destroy.

Great now that we know what Terraform wants to do, let's go ahead and run a terraform apply to create the resources and watch it do it's work. Before it performs the actions it will prompt you to approve, simply type yes

Once you type yes it should only take a few seconds to run the apply. You will see it pull the latest image of busybox and create a container off of it. And will report apply complete at the end.

If you now run a docker ps command you will be able to see the busybox container running.

Go ahead and run another terraform plan - it will check the state against the running resources for any changes. In this case since we have not changed anything it will report no changes.

Fantastic! You have now created your first IaC with Terraform and learned a few basics about terraform and some of it's concepts. Let's finish off by teaching you one more Terraform command.

terraform destroy - This will destroy any resources that are defined in your code.

Go ahead and do a terraform destroy - it will again ask you to approve, answer with yes. After a moment you should see that it destroyed both the container and the image.

Congratulations and I hope you continue learning Terraform and what it can do for you.
