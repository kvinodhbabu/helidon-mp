# Introduction

Deploy Helidon on Oracle Container Engine for Kubernetes and Read using Code Card.

A Guide to show you a few simple steps to create your own image and deploy helidon maven jar on Oracle Kubernetes Engine on Oracle Cloud Infrastructure, and then proceed to launch your Docker image & run your helidon microservice. 

The path that we will take is as follows:

1. Deploy maven jar.
2. Create OKE Cluster in Oracle Cloud Infrastructure.
3. Build Docker Image File.
4. Tag & Push to OCIR.
5. Pull the image from OCIR.
6. Create Service and Deploy on OKE.

# Background
Project Helidon is an open source set of Java libraries used to write microservices. According to the official documentation, "Helidon is a collection of Java libraries for writing microservices that run on a fast web core powered by Netty... There is no unique tooling or deployment model. Your microservice is just a Java SE application."

# Helidon on OKE
In this walkthrough we will create a greetings application with bodytext in Helidon, push it to the Oracle Container Registry, deploy it into an Oracle Container Engine for Kubernetes cluster. 
 
# Build Docker Image
$ `docker build -t helidon-mp .`

# Check if images are loaded
$ `docker images`

# Push Your Image to OCIR
Your account must be in the Administrators group or another group that has the REPOSITORY_CREATE permission.

Sign in to the Oracle Cloud Infrastructure (OCI) web console and generate an authentication token. See Getting an Auth Token.

Remember to copy the generated token. You won’t be able to access it again.

# Log in to the OCIR Docker registry
$ `docker login -u <username> -p <password> <region-code>.ocir.io`
	   
`<region-code>` corresponds to the code for the Oracle Cloud Infrastructure Registry region you're using, as follows:

	1. enter `fra` as the region code for Frankfurt
	2. enter 'iad' as the region code for Ashburn
	3. enter 'lhr' as the region code for London
	4. enter 'phx' as the region code for Phoenix

The user name in the format `<tenancy_name>/<username>`
The password is the generated token.
`<region-code>` is the code for the OCI region that you’re using. For example, the region code for Phoenix is phx. See Regions and Availability Domains.

# Tag the image that you want to push to the registry
$ `docker tag helidon-mp:latest <region-code>.ocir.io/<tenancy-name>/<repo-name>/<image-name>:<tag>`
	   
The next step is to tag the helidon image we are going to push to the registry:

$ `docker tag helidon-mp:latest iad.ocir.io/<tenancy-name>/codecard/helidon-mp:latest`

the local image to tag <repo-name> is optional. It is the name of a repository to which you want to push the image (for example, project01).

# Push the image to the Registry

$ `docker push <region-code>.ocir.io/<tenancy-name>/<repo-name>/<image-name>:<tag>`

$ `docker push iad.ocir.io/<tenancy-name>/codecard/helidon-mp:latest`

You can pull your image with the image path used above, for example:  `ia.ocir.io/helidon/example/helidon-mp:latest`

Within the Registry UI you will see the newly created repository. By default, the repository will be set to private. If you would like to continue with a private repository, you will have to add an image pull secret which allows Kubernetes to authenticate with a container registry to pull a private image. 

Let's first create a namespace for this project called "helidon" 

$ `kubectl create namespace helidon`

# Deploy the application

$ `kubectl create -f target/app.yaml -n helidon`

# Get the NodePort number for your new pod

$ `kubectl get svc -n helidon`

# Get the External IP address for your cluster nodes

$ `kubectl get nodes`
$ `kubectl describe node <NodeName>`

You can now access the application at `http://<NodeIpAddress>:<NodePort>/HelidonMp/<NAME>`

$ `curl http://<NodeExternalIpAddress>:<NodePort>/HelidonMP/Helidon`

{"template":"template1","title":"Hello Helidon!!","subtitle":"How are you?","bodytext":"This is my first Helidon Microservice from the oracle cloud using OKE","icon":"microservice","backgroundColor":"white"}

$ `curl -XGET http://NodeExternalIpAddress:NodePort/HelidonMP/Vinodh`

{"template":"template1","title":"Hello Helidon!!","subtitle":"How are you?","bodytext":"This is my first Helidon Microservice from the oracle cloud using OKE","icon":"microservice","backgroundColor":"white"}

To fetch customized data as template with user inputs to change title, subtitle, bodytext, icon, color.

$ `curl -XPUT -H "Content-Type: application/json" -d '{"title" : "Howdy", "subtitle", "bodytext" : "My updated Helidon MicroService", "icon": "java"}' http://NodeExternalIpAddress:NodePort/HelidonMP/Helidon`
