# Kubectl Test Chart
This chart facilitates testing of RC versions of `rancher/kuberlr-kubectl` image.

Specifically this allows us to create, test and QA an RC version of the image without needing to involve dependent charts.
The goal being that we shouldn't need to "mix processes" and utilize another project for testing this project.

## What does this test for?
To correctly provide a validation w/o using consuming charts, we need to ensure this chart does the same type of stuff.
Additionally, we should ensure that when it does those actions it will create loud and obvious errors when failure happens.

Some examples of scenarios this should cover:
- Post upgrade jobs (like BRO, Monitoring),
- Creating a `ServiceAccount` (with appropriate bindings) and using that for upgrade task (like BRO),
- Storing upgrade scripts in a `ConfigMap` and then running them on upgrade (like Monitoring)

As we find more specific use-cases within Rancher that existing scenarios do not cover, we should create issues to track adding new tests.

## How does (or will) this work?

This chart will be packaged as a release artifact with each GitHub release.
In turn every tag going forward will have a direct 1:1 chart that can be used for testing and QA of that tag.

Eng will create a new RC and upon success of the action, they will inform QA (via the related issue) that the RC is ready for testing.
Once QA picks up the issue for testing they will fetch the debug/QA chart from the release and install via CLI.
Then they will subsequently "upgrade" to the same version to trigger any upgrade specific jobs.

After each phase QA will be able to verify the resources and jobs in the testing namespace.
As long as they do not observe any errors - just as they would expect for a production chart - the RC has passed.
Then once the `rancher/kuberlr-kubectl` tag has been un-RC'd any consuming charts can update to the new stable tag.