# Quick and Dirty Selenium Grid on Kubernetes

## Assumptions

You have installed the followind:

- Helm 3
- kubectl
- Python 3.8
  - You can use a different 3.x version, as long as you update the value in the
    `Pipfile`.

## Prereqs

### Create Your Cluster
1. Obtain a Digital Ocean account
   - You don't *have* to use DO and there are a lot of good Kubernetes hosts out
     there, but the instructions below are specific to DO.
2. Go to your DO dashboard and click on the following buttons:
   - `Kubernetes -> Create -> Clusters`
3. Under **Choose a datacenter region** choose the default.
4. Under **Choose cluster capacity** choose the following:
   - **Machine Type**: General Purpose nodes
   - **Number Nodes**: 1
5. The **Monthly Rate** for this should be $60 / month. Hopefully we'll only use it for less than a couple of hours (at $0.09 / hour).
6. Under the **Choose a name** choose something descriptiive like **selenium-test**.
7. Click on the **Create Cluster** button.

It will take a few minutes for everything to spin up and auto-configure itself. In
the meantime you should be able to click on the **Download Config File** button to -
you guessed it - download the `kubectl` config file.

### Configure kubeconfig

After downloading the `kubectl` config file you should see a file with a name like
this in your `Downloads` directory:

- `selenium-test-kubeconfig.yaml`

Then configure `kubectl` to use it like this:

``` terminal
cp ~/Downloads/selenium-test-kubeconfig.yaml ~/.kube
export KUBECONFIG=~/.kube/selenium-test-kubeconfig.yaml
```

**Note**: Please execute the `export` command above in **every console window** that
is going to be interacting with your Kubernetes cluster.

## Selenium Grid Installation

### Configuration

There should be a file called `values.yaml` in this repo. This is how we're going to
configure our Selenium Grid installation.

It should look something like this:

``` yaml
hub:
  serviceType: ClusterIP
chromeDebug:
  enabled: true
```

Here's, we're telling the helm package two things:

1. Only expose our service ports on the local Kubernetes network, **not** on a public
   network. This makes things much safer for our test.
2. Run 1 "debug" version of the Chrome image in our grid.
   - The "debug" versions allow us to VNC into them, which is pretty sweet.
   
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
