# Quick and Dirty Selenium Grid on Kubernetes

## Overview

With this repo you can quickly create a Selenium Grid cluster on top of a hosted
Kubernetes cluster running at Linode. And then after poking around you can easily
throw it away :-)

## Assumptions

You have installed the followind:

- A Linode account
- The ``linode-cli`` script
- Helm 3
- kubectl

## Prereqs

### Create Your Cluster

Run the following script:

[scripts/create-linode-k8s-cluster.sh](./scripts/create-linode-k8s-cluster.sh)

It will take a few minutes for everything to spin up and auto-configure itself. 

### Configure kubeconfig

Run this script:

[scripts/download-linode-k8s-kubeconfig.sh](./scripts/download-linode-k8s-kubeconfig.sh)

Follow the directions in the output for configuring ``kubectl`` to use this config.

**Note**: Please execute the `export` command above in **every console window** that
is going to be interacting with your Kubernetes cluster.

## Selenium Grid Installation

### Configuration

There should be a file called `values.yaml` in this repo. This is how we're going to
configure our Selenium Grid installation.

It should look something like this:

[values.yaml](values.yaml)

Here's, we're telling the helm package two things:

1. Only expose our service ports on the local Kubernetes network, **not** on a public
   network. This makes things much safer for our test.
2. Run 1 "debug" version of the Chrome image in our grid.
   - The "debug" versions allow us to VNC into them, which is pretty sweet.
3. Run 2 "debug" versions of the Firefox image.
   
## Installation

Simply run this command:

``` console
helm install selenium-test -f values.yaml stable/selenium
```

## Confirmation 

You can check the status of the system like this:

``` console
kubectl get pods
```

When everything is running you'll see something like this:

START HERE!!!

``` console
NAME                                                   READY   STATUS    RESTARTS   AGE
selenium-test-selenium-chrome-debug-5bcdf6f86d-jxlk2   1/1     Running   0          37s
selenium-test-selenium-hub-76cd9d677f-zn7p5            1/1     Running   0          37s
```

## Port Fowarding

Remember before wheN I said that we weren't going to expose these services to the
public internet? Well, to connect we therefore need to use port forwarding.

Let's assume that you ran the `get pods` command above and see my output (even though yours will be slightly different). In one shell let's first port-forward to the debug pod's VNC port like this:

``` console
export KUBECONFIG=~/.kube/selenium-test-kubeconfig.yaml
kubectl port-forward selenium-test-selenium-chrome-debug-5bcdf6f86d-jxlk2 5900:5900
```

Now open **another** terminaly window. In this we will port-forward to the HTTP port for the Selenium Grid pod:

``` console
export KUBECONFIG=~/.kube/selenium-test-kubeconfig.yaml
kubectl port-forward selenium-test-selenium-hub-76cd9d677f-zn7p5 4444:4444
```

Now all of the network plumbing is complete.

## Running a Web Browser Test

### Installing the Python Dependencies

First install `pipenv` if you don't already have it like this:

``` console
sudo python3 install pipenv
```

Next install your dependencies like this:

``` console
# Remember, any 3.x version of Python will do. Just change this command to match the version in your Pipfile
pipenv --python=/path/to/python38
pipenv install
```

### Running the Test

First let's connect to the brower pod using VNC so we can watch the action:

``` console
vncviewer localhost:5900
# password: secert
```

Now we can finally do the cool part! Let's run the test script provided by the
wonderful people over at testdrive.io ([source](https://testdriven.io/blog/distributed-testing-with-selenium-grid/):

``` console
pipenv run python ./hn_tests.py
```

You should be able to watch the test execute in the `vncviewer` window.

## Finally, the Most Important Part

Cleanup! Make sure you **destroy** your cluster so you no longer need to pay for it
:-)
