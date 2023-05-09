# DEVNET-3008: Terraforming the Lost City
This repository will serve as the source code repo (not the demo repo) of the DEVNET-3008 session performed at Cisco Live 2023 in Las Vegas.

## Usage
Folder structure is broken in two unique folders, based on the Terraform provider for CML2.  All files will work without modification within any DevNet Sandbox backed by CML, as the bridge connection and management IPs are based on that IP addressing scheme.  These can be modified to support any arbitrary installation, however.

### `terraform-yaml`

This folder contains a very simple TF HCL file, defining a lifecycle resource based on the YAML file defined within that same folder.  This will create a 3-node IOSv topology with G0/0 attached to a MGMT VRF, which connects to the external connector (bridged) interface in CML for direct reachability.  If a new file is desired to be used, the appropriate file name and path must be incluided within the HCL file to point to the new YAML definition.

### `terraform-hcl`

This folder contains a more "Terraform-centric" approach to defining a topology within CML.  Rather than abstract the configuration to a single YAML file, the required elements are defined inline, including the lab, nodes, and links between the nodes.  The only external dependencies are on the configuration files defined within the folder.  These configurations are optional, however, in order to ensure that the topology boots with a defined configuration, these must be included within the repo (and appropriate pathing should be done within the HCL file itself).  It is possible to define the configuration of each node inline -- however -- this was not done for the sake of readability. 

## Using these files with Atlantis

This repo won't serve as a canonical resource for using Atlantis.  Much of the information can be found [here](https://www.runatlantis.io/guide/testing-locally.html) on the Atlantis site.
However, at a base level, one should perform the following steps:

- Install Terraform
- Download the Atlantis binary
- Establish some reachability from the SCM to the Atlantis server (port forwarding + DNS, ngrok, etc)
- Establish a webhook mechanism from the SCM pointing to the URL of the Atlantis server
- Ensure proper authorization (tokens, SSH keys, etc) for Atlantis to access the defined build repos
- Start Atlantis
- Create PR in build repo
- PROFIT!!! $$$

By default, Atlantis will "autoplan" the PR, meaning that once the webhooks are fired off to the build server, it will proceed to perform a `terraform plan` on the files within the PR and display that output to the PR.  When you're ready to apply the changes -- ensure that you use `atlantis apply`, rather than just the singular `atlantis apply -d .`, which will prevent you from deleting the plan when the time comes from the PR.

To delete the running simulation -- you'll need to ensure that the PR is not closed and that you use the wake word to signal to the Atlantis build server that it should perform some action.  This is done using `atlantis plan -- -delete`, which will then remove the running simulation from the CML2 server.

Any questions or comments can be directed to me on Twitter via [@qsnyder](https://twitter.com/qsnyder)
