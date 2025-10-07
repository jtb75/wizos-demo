:::success

This feature requires a Wiz Cloud Advanced <Glossary id="license" /> and is not supported in Wiz for Gov. [Learn more](doc:licenses).

:::

This guide provides some quick and easy steps for you to get started with WizOS and build secure applications. For a more abstract discussion, see the [How WizOS Works](doc:how-wizos-works) page. See also the [WizOS Tutorials](doc:wizos-tutorials) for step-by-step walkthroughs of key scenarios.

If you are currently using Alpine for your base or application images, read the [Alpine-to-WizOS Compatibility](doc:alpine-wizos-compatibility) page before following the instructions below.

## Basic workflow

[Step 1](#pull-images): Pull images

[Step 2](#install-packages): Install packages

[Step 3](#optional-remove-the-shell-and-package-manager): (Optional) Remove the shell and package manager

%WIZARD_START%

### Pull images

1. Log in to the Wiz portal.
2. On the top right, click **Profile > Tenant Info**.
3. In the **General** tab, scroll down to the **Wiz Registry Credentials** section and choose **WizOS Registry**.

![](https://docs-assets.wiz.io/images/tenant-1b0a5023.jpg)

4. Use the credentials to authenticate to the WizOS registry:

```dockerfile
echo <PASSWORD> | docker login registry.os.wiz.io --username <USERNAME> --password-stdin <REGISTRY_URL>
```

5. Choose an image from the [Secured Image Catalog](https://app.wiz.io/inventory/secured-image-catalog) and copy its Wiz URL.
6. In your Dockerfile, replace the image with the Wiz URL in the `FROM` command. You can specify the image version in three ways:
   - (Recommended) By the `latest` tag
   - By a specific image version tag
   - By the major version number
   - By pinning to a sha256 digest

For example:

```dockerfile
 FROM registry.os.wiz.io/wizos-base:latest
```

### Install packages

1. Follow [these instructions](doc:service-accounts-settings#add-a-service-account) to create a service account in the Wiz portal with the following settings:
   - For Type—Select **Custom Integration (GraphQL API)**.
   - For API Scopes—Select **WizOS Package Repository Access Token**.
2. Authenticate to the WizOS package repository.
3. Download packages. To do that, use the supplied `apk add` and `apk-auth` commands from the WizOS image. For example:

```dockerfile
RUN --mount=type=secret,id=WIZOS_CLIENT_ID \
 --mount=type=secret,id=WIZOS_CLIENT_SECRET \
 export $(WIZOS_SECRET_PATH=/run/secrets apk-auth) && \
 apk add --no-cache \
 python3
```

:::warning

If your organization uses a proxy server, add the `https_proxy` environment variable to the Dockerfile before the `apk add` command. For example: `ENV https_proxy="http://my.proxy.server:8080`.

:::

### (Optional) Remove the shell and package manager

To harden the Wiz OS image even more, you can remove the shell and package manager, which are typically not needed in production.

To do so:

1. Ensure your application doesn't use any of the following in production:
   - Running command line tools (e.g. `ls`)
   - Running shell commands (e.g. `bash -c "echo foo > /tmp"`)
   - Installing packages at runtime (e.g. `apk add vim`)

2. Add the following command at the end of the Dockerfile, before the `CMD` or `ENTRYPOINT` instruction:

```dockerfile
RUN apk del wizos-keys wizos-apk-auth apk-tools busybox
```

3. (Recommended) Test your application to ensure it works as expected.

:::warning

Containers without a shell or package managers are often harder to debug in production. If you are running on Kubernetes, you may use (with caution) the `kubectl debug` command to attach more comprehensive ephemeral containers to your existing pods. To learn more, see Kubernetes' guide on [debugging running pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-running-pod/).

:::

%WIZARD_END%

## Example

To build a Python application using the **WizOS base** image, follow these instructions:

1. Create the Dockerfile:

```dockerfile
FROM registry.os.wiz.io/wizos-base:latest

# WIZOS_CLIENT secrets are passed to this dockerfile by `docker build`
# use apk-auth to install packages from the wizos apk registry
RUN --mount=type=secret,id=WIZOS_CLIENT_ID \
 --mount=type=secret,id=WIZOS_CLIENT_SECRET \
 export $(WIZOS_SECRET_PATH=/run/secrets apk-auth) && \
 apk add --no-cache \
 python3

WORKDIR /app

COPY ./src/ /app

ENTRYPOINT ["python3", "main.py"]
```

<Expandable title="Example of an application (`./src/main.py` in the code block above)">

```dockerfile
def main():
   print("Hello, WizOS!")


if __name__ == "__main__":
   main()
```

 </Expandable>

2. Set the `WIZOS_CLIENT_ID` and `WIZOS_CLIENT_SECRET` environment variables to the service account's credentials by running the following commands:

```dockerfile
export WIZOS_CLIENT_ID=<YOUR SA API TOKEN CLIENT ID>
export WIZOS_CLIENT_SECRET=<YOUR SA API TOKEN CLIENT SECRET>
```

3. Build the container image (requires [authenticating to the WizOS registry](#pull-images)):

```dockerfile
docker build --secret id=WIZOS_CLIENT_ID,env=WIZOS_CLIENT_ID --secret id=WIZOS_CLIENT_SECRET,env=WIZOS_CLIENT_SECRET -t wiz-os-pull-test:v1.0.0 -f Dockerfile .
```

4. Run the container image:

```dockerfile
docker run wiz-os-pull-test:v1.0.0
```
