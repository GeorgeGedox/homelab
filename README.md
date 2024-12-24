# Fresh cluster
- task tf:apply
- Wait for all nodes to be added to the cluster
- task cluster:bootstrap
- Check the cluster to make sure all resources are ok
- task cluster:flux
- Wait for the cluster to install everything, generating and validating the certificates is going to take 15-20mins
