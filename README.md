# openshift-utils

A bag of utility scripts for developing on OpenShift.

## /v4

`/v4` contains scripts for launching and hacking on an OCP 4 cluster.

1. `launch-dev-cluster.sh`

The script defaults to pulling a release payload from the [OCP release status](https://openshift-release.svc.ci.openshift.org/) page, using the provided version number. You must provide a pull secret for the OCP CI registry, which can be obtained as follows:

```
$ oc login api.ci.openshift.org

// download your pull secret to PULL_SECRET
$ oc registry login --to=PULL_SECRET

// PULL_SECRET now can pull from api.ci.openshift.org
// Note that you may need to remove newlines from the pull secret
// for it to work with openshift-install
```

Note that logins to `api.ci.openshift.org` are restriced to members of the OpenShift github organization.
