# Chart Implementation Examples and Best Practice

The goal of this image is to replace `rancher/kubectl` as the primary `kubectl` image for Rancher projects.
This document will cover the best-practices that already exist around using `rancher/kubectl` - so still apply here - and the new ones for `rancher/kuberlr-kubectl` features.

## Required Chart Global Values

Because this chart replaces the older `rancher/kubectl` we must continue to use the existing globals.
This means all charts using this should continue using the following global values block:

```yaml
global:
  kubectl:
     repository: rancher/kuberlr-kubectl
     tag: <tag>
     pullPolicy: IfNotPresent
     allowDownload: false
```

### Notable Features

- **`tag`**: you should select the tag that matches the _Rancher minor version_ your branch targets
- **`allowDownload`**: A flag to signal to the internal `kuberlr` binary if it should fetch missing `kubectl` binary from the internet.
  - By default, for Rancher projects this should have a value of `false` and  you should ensure you target the correct image tag for your Rancher minor version. 

If your project is a bit of an exception and doesn't target specific Rancher minor versions, then it may be best to always use the newest `tag` and set `allowDownload` to true.
However, you should keep note of the `kubectl` versions bundled with the latest image tag and document that for your users to be aware of.
This way they are not surprised if they try using it on a non-bundled version within an air-gap and see errors; as `kuberlr` will not be able to fetch binaries in an air-gap.

## Example Chart Template

To easily manage the image across varying charts the use of `global` values is preferred to custom value fields.
However, this does not exclude the use of custom value fields as long as they respect global values.
For instance, if the image is used in an upgrade job then while you can define the image there it should prefer global values.

An example of this would be what's seen in `rancher-monitoring` chart:

```yaml
# values.yaml

## Global values
global:
  kubectl:
     repository: rancher/kuberlr-kubectl
     tag: v1.0.0-rc.1
     pullPolicy: IfNotPresent
     allowDownload: false

## Upgrades
upgrade:
  ## Run upgrade scripts before an upgrade or rollback via a Job hook
  enabled: true
  ## Image to use to run the scripts
  image:
    repository: rancher/kuberlr-kubectl
    tag: v1.0.0-rc.1
```

Here we see an example where global values are set for `kubectl` in general and for an `upgrade` section.
Notably, the upgrade job here is a standalone field because it used `rancher/shell` but was able to migrate to `rancher/kuberlr-kubectl`.

```yaml
# template/hardened.yaml (just the important part)
spec:
  template:
    spec:
      containers:
      {{- range $_, $ns := $namespaces }}
      - name: patch-sa-{{ $ns }}
        image: {{ template "system_default_registry" $ }}{{ $.Values.global.kubectl.repository }}:{{ $.Values.global.kubectl.tag }}
        imagePullPolicy: {{ $.Values.global.kubectl.pullPolicy }}
        command: ["kubectl", "patch", "serviceaccount", "default", "-p", "{\"automountServiceAccountToken\": false}"]
        args: ["-n", "{{ $ns }}"]
        env:
          - name: KUBERLR_ALLOWDOWNLOAD
            value: {{ default false $.Values.global.kubectl.allowDownload | quote }}
      {{- end }}
```

Here is the main example that used (and always has) the global `kubectl` values - this is the standard example.

This example exists in a loop due to chart requirements, but the basic example is good to follow.
Keep in mind that the `$` prefix is necessary in a loop to access the root scope and can be used outside of loops too.

```yaml
# template/upgrade/job.yaml (just the important part)
spec:
  template:
    metadata:
      name: {{ template "kube-prometheus-stack.fullname" . }}-upgrade
      labels:
        app: {{ template "kube-prometheus-stack.fullname" . }}-upgrade
    spec:
      containers:
        - name: run-scripts
          image: {{ template "system_default_registry" . }}{{ default .Values.upgrade.image.repository $.Values.global.kubectl.repository }}:{{ default .Values.upgrade.image.tag  $.Values.global.kubectl.tag }}
          imagePullPolicy: {{ $.Values.global.kubectl.pullPolicy }}
          command:
            - /bin/sh
            - -c
            - >
              for s in $(find /etc/scripts -type f); do 
                echo "Running $s...";
                cat $s | bash
              done;
          env:
            - name: KUBERLR_ALLOWDOWNLOAD
              value: {{ default false $.Values.global.kubectl.allowDownload | quote }}
```

Finally, we come back to the `upgrade` example which previously used `rancher/shell`.

In this case the values will default to the local values if the globals are unset - this ensures that the globals take precedence over the locals.
Because it used shell in the past there is no existing field for `allowDownload`