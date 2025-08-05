# VCFAutomation
VMware Cloud Foundation (VCF) Automation
- Will use this to store things used in VCF Automation for design templates, etc.

# Aria Automation 8.18
CCI is required for these
- Deploy OPEA with new VKS cluster.yaml
  - design template to deploy a new TanzuKubernetesCluster into a new supervisor namespace in an existing supervisor, and then deploy [Intel OPEA](https://github.com/opea-project) using the docker-helm container
- Deploy AMX VKS Cluster.yaml
  - design template to deploy a TanzuKubernetesCluster into a new supervisor namespace in an existing supervisor
- Deploy OPEA to existing cluster.yaml
  - design template to deploy [Intel OPEA](https://github.com/opea-project) into an existing TanzuKubernetesCluster using the docker-helm container
