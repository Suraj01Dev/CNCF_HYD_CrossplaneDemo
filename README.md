# Crossplane Demo

This repository contains a demonstration of Crossplane, a framework for building cloud native control planes.

## Installing Crossplane

There are multiple ways to install Crossplane. The most common methods are using the `up` CLI (Upbound Universal Crossplane) or `helm`. 

### Method 1: Using Upbound CLI (UXP)

1. **Install the `up` CLI:**
   ```bash
   curl -sL "https://cli.upbound.io" | sh
   sudo mv up /usr/local/bin/
   ```

2. **Install Universal Crossplane (UXP) to your Kubernetes cluster:**
   ```bash
   up uxp install
   ```

3. **Verify the installation:**
   ```bash
   kubectl get pods -n crossplane-system
   ```

### Method 2: Using Helm

1. **Add the Crossplane Helm repository:**
   ```bash
   helm repo add crossplane-stable https://charts.crossplane.io/stable
   helm repo update
   ```

2. **Install Crossplane:**
   ```bash
   helm install crossplane --namespace crossplane-system --create-namespace crossplane-stable/crossplane
   ```

3. **Verify the installation:**
   ```bash
   kubectl get pods -n crossplane-system
   ```

## Setting up the AWS Provider

After installing Crossplane, you need to install a provider to manage resources. In this example, we'll configure the AWS S3 Provider.

### 1. Install the AWS S3 Provider

Create a file named `provider-aws-s3.yaml`:

```yaml
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-aws-s3
spec:
  package: xpkg.upbound.io/upbound/provider-aws-s3:v0.41.0 
```

Apply it to your cluster:
```bash
kubectl apply -f provider-aws-s3.yaml
```

### 2. Create AWS Credentials Secret

Create a file named `aws-credentials.txt` containing your AWS credentials:

```ini
[default]
aws_access_key_id = YOUR_ACCESS_KEY_ID
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY
```

Create a Kubernetes Secret from this file:
```bash
kubectl create secret generic aws-secret \
  -n crossplane-system \
  --from-file=creds=./aws-credentials.txt
```

### 3. Create a ProviderConfig

The `ProviderConfig` tells the AWS provider how to authenticate using the secret you just created.

Create a file named `provider-config-aws.yaml`:

```yaml
apiVersion: aws.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: aws-secret
      key: creds
```

Apply it to your cluster:
```bash
kubectl apply -f provider-config-aws.yaml
```

Now Crossplane is installed and configured to manage AWS S3 resources!
