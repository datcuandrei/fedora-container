# fedora-container

Personal `bootc` image to deploy on my infrastructure.

## Deployment
First we need to start the Podman machine in rootful mode:
```bash
podman machine stop
podman machine set --rootful
podman machine start
```

Next we can build the container itself:
```bash
podman build . # assuming you are in the project's directory
```

And then simply run the container:
```bash
podman run -dit <container_id>
```
By default, the entrypoint is `bash`. And as such, the container won't stop unless you explicitly do so. To interact with it:
```bash
podman exec -it <container> /bin/bash # or anything else; this will start a shell
```

**To build an image using `bootc-image-builder`**:
```bash
sudo podman run \
    --rm \
    -it \
    --privileged \
    --pull=newer \
    --security-opt label=type:unconfined_t \
    -v $(pwd)/output:/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    quay.io/centos-bootc/bootc-image-builder:latest \
    --type <enter_type> \
    --rootfs ext4 \
    --local \
    git.datcuandrei.com/datcuandrei/fedora-container:latest
```
where `<enter_type>` can be:
| Image type            | Target environment                                                                    |
|-----------------------|---------------------------------------------------------------------------------------|
| `ami`                 | [Amazon Machine Image](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) |
| `qcow2` **(default)** | [QEMU](https://www.qemu.org/)                                                         |
| `vmdk`                | [VMDK](https://en.wikipedia.org/wiki/VMDK) usable in vSphere, among others            |
| `anaconda-iso`        | An unattended Anaconda installer that installs to the first disk found.               |
| `raw`                 | Unformatted [raw disk](https://en.wikipedia.org/wiki/Rawdisk).         

> [!TIP]
> To learn more about `bootc-image-builder`, [click here](https://github.com/osbuild/bootc-image-builder/blob/main/README.md).
> Also, the default password for `root` and `adminusr` is `v3rYsTrong`.