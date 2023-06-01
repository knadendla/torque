# Deploy an EKS cluster using Torque

<img width="979" alt="image" src="https://user-images.githubusercontent.com/96681520/203494295-26fd6d03-f7eb-4a4d-9e82-38f463a9444c.png">

## Prequisites Instructions for cross account deployment
###### Use case description: Torque runs on account A (source account) and provisions environments on account B (target account).

<img width="1002" alt="image" src="https://user-images.githubusercontent.com/96681520/195613626-8e6473de-6eb0-40c2-b7ab-af5f66cd811e.png">

1. In the target account, account B, create an IAM role called "eks-cluster-creator" with your cluster host OIDC identity provider as a web identity. Follow this [documentation](https://docs.qtorque.io/blueprint-designer-guide/service-accounts-for-aws "documentation").
2. In account B, Attach a new policy that able to provision and destroy EKS cluster out of this [json file](https://github.com/QualiTorque/TFSamples/blob/main/config/eks-cluster-creator/policy.json)
3. Create a new service account on your cluster based on [this yaml file](https://github.com/QualiTorque/TFSamples/blob/main/config/eks-cluster-creator/serviceaccount.yaml)
	- Make sure to change:
    	- The Role ARN to the created in section (1) 
    	- The environment `namespace`

## Deployment Instructions:
1. Go to your Torque account
2. Under your space Go to the settings/repositories section
3. Attach this repository as an asset repository
4. In the asset discovery view, check the `dev-cluster` asset and then click on _Generate Blueprints_ button
5. Under the blueprints section publish the `dev-cluster` blueprint
6. Open the generated blueprint and edit the yaml file, replace the `service-account` with the service account created in step (3) of the pre-req.
7. Launch the environment. Fill the required inputs:
	- Account number - the AWS account number of the target account, account B. 
	- cluster-name 
	- AWS region
	- Set `true` for each auxillary service you wish to deploy on the cluster (such as elk stack, istio etc.) or false if you do not wish to install them. 
	- Role ARN of the role you wish to allow permission to the cluster, for example: arn:aws:iam::123456789:role/role
	- role_username, which is the actual role name in IAM.
	- Select the host_name which is the execution host name

After filling all the inputs above, click Launch environment. 
The environment initialization will take roughly about 20 minutes.
