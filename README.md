# CourtRoom

Setup of courtroom using a k8s cluster

# Pre-Requisites

We need to run the following command as there is a case that when using lxd environment the pod does not have permission to set this on the host.

```
sudo sysctl -w net.netfilter.nf_conntrack_max=524288
```

# Setup

Create a custom lxd profile to apply to the nodes

```
lxc profile copy default k8s
cat lxd.profile | lxc profile edit k8s
```

We need to provision 3 nodes i.e. lxd container running **Ubuntu 22.04** with the **k8s** profile that we created

```
lxc launch --profile k8s ubuntu:24.04 master
lxc launch --profile k8s ubuntu:24.04 worker1
lxc launch --profile k8s ubuntu:24.04 worker2
```

Cluster setup requires certain comands to be executed on both master and worker.
There are certain commands that are common for both node types.
Run the following for preparing the nodes

```
cat bin/setup_node.sh | lxc exec master bash
cat bin/setup_node.sh | lxc exec worker1 bash
cat bin/setup_node.sh | lxc exec worker2 bash
```

Now initialize the k8s cluster by running the following on the **master** node

```
cat bin/setup_master.sh | lxc exec master bash
```

<!-- This will create a shell script on the **master** node that has to executed from the **worker** nodes to join the cluster. -->
<!---->
<!-- > **NOTE**: After running the master setup script, it might take some time for all the resources to come up -->
<!---->
<!-- We need to copy the script from **master** node to local and then to workers before we can execute it on the **worker** nodes -->
<!---->
<!-- ``` -->
<!-- lxc file pull master/tmp/cluster-connect.sh /tmp/cluster-connect.sh -->
<!-- cat /tmp/cluster-connect.sh | lxc exec worker1 bash -->
<!-- cat /tmp/cluster-connect.sh | lxc exec worker2 bash -->
<!-- ``` -->
