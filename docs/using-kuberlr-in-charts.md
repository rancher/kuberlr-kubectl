# Using Kuberlr in Charts

This doc goes over some special `kuberlr` based features that can be used when deploying it via a helm chart.
These are not required for use in your chart, rather are suggestions on how to uniformly (across rancher) implement `kuberlr` features as chart features.

## Using `kuberlr` automatic download feature

If you maintain a Rancher/SUSE project where the default `rancher/kuberlr-kubectl` image doesn't fit perfectly you may want to re-enable downloads.
Or at the very least expose that functionality to end-users via helm chart values.

Your chart likely already has our `kubectl` or `kuberlr-kubectl` image in use - that's likely under: `.Values.global.kubectl`.
If it's in a different spot use this example to apply to your situation:

```yaml
global:
  kubectl:
    repository: rancher/kuberlr-kubectl
    tag: v4.0.2
    pullPolicy: IfNotPresent
    # As long as kubectl image is using `rancher/kuberlr-kubectl` it can use kuberlr features.
    # kuberlrAllowDownload is disabled by default for most compatibility with air-gaps
    # When enabled it will allow kuberlr to download a compatible `kubectl` with the target cluster.
    # kuberlrAllowDownload: false
```

Then in your template that deploys the container with the `rancher/kuberlr-kubectl` image you need to add:

```yaml
        {{- if and .Values.global.kubectl (hasKey .Values.global.kubectl "kuberlrAllowDownload") }}
        env:
          - name: KUBERLR_ALLOWDOWNLOAD
            value: {{ .Values.global.kubectl.kuberlrAllowDownload | false }}
        {{- end }}
```

A more complete example would be:
```yaml
      - name: patch-sa-{{ $ns }}
        image: {{ template "system_default_registry" $ }}{{ $.Values.global.kubectl.repository }}:{{ $.Values.global.kubectl.tag }}
        imagePullPolicy: {{ $.Values.global.kubectl.pullPolicy }}
        {{- if and .Values.global.kubectl (hasKey .Values.global.kubectl "kuberlrAllowDownload") }}
        env:
          - name: KUBERLR_ALLOWDOWNLOAD
            value: {{ .Values.global.kubectl.kuberlrAllowDownload | false }}
        {{- end }}
        command: ["kubectl", "patch", "serviceaccount", "default", "-p", "{\"automountServiceAccountToken\": false}"]
        args: ["-n", "{{ $ns }}"]
```

