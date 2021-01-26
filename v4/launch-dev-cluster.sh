#!/bin/sh

if [ $# -ne 1 ]; then
	echo "Need release version, e.g. 4.0.0-0.ci-2019-04-15-011801"
	exit 1
fi

version=$1
clusterDir=/home/rmarasch/workspace/openshift-install/openshift-utils/cluster-aws
pullSecret=/home/rmarasch/workspace/openshift-install/openshift-utils/PULL_SECRET
#host=registry.svc.ci.openshift.org
host=registry.ci.openshift.org
image=ocp/release

rm -rf /tmp/openshift-release
mkdir /tmp/openshift-release
pushd /tmp/openshift-release

echo "Extracting release $version"

oc adm release extract --tools --to /tmp/openshift-release -a $pullSecret "$host/$image:$version"

mkdir -p /tmp/openshift-release/oc
tar -xzf "openshift-client-linux-$version.tar.gz" -C /tmp/openshift-release/oc
cp /tmp/openshift-release/oc/oc $HOME/go/bin/

mkdir -p /tmp/openshift-release/openshift-install
tar -xzf "openshift-install-linux-$version.tar.gz" -C /tmp/openshift-release/openshift-install
cp /tmp/openshift-release/openshift-install/openshift-install $HOME/go/bin/

echo "Destroying previous cluster at $clusterDir"

openshift-install --dir $clusterDir destroy cluster

rm -rf $clusterDir
mkdir $clusterDir
export KUBECONFIG=$clusterDir/auth/kubeconfig
pushd $clusterDir

echo "Creating new cluster at $version"

echo "============ PULL SECRET ============"
echo " "
cat $pullSecret
echo " "
echo "===================================="

openshift-install --dir $clusterDir create cluster

popd

popd
