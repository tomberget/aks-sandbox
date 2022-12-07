# ArgoCD crds

*ArgoCD* crds are installed independently of the `argo_cd` module. Before
*ArgoCD* can be updated you need to fetch the updated crds using the
`update-crds.sh` script.

```bash
./update-crds.sh v2.1.3
```

This will create a new directory for the `v2.1.3` version crds and pull
all the crds for this version.
