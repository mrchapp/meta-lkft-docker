Run this with
```
docker run -it \
  -e MACHINE=intel-corei7-64 \
  -e KERNEL_RECIPE=linux-generic-stable-rc \
  -e KERNEL_VERSION=4.19 \
  -e SRCREV_kernel=178574b66509c9ff7df4ad26c84a8884567e93b4 \
  -v /opt/oe/downloads:/oe/downloads \
  -v /opt/oe/sstate-cache:/oe/sstate-cache \
  -v $(pwd)/build:/oe/build-lkft \
  mrchapp/lkft-rocko   bitbake rpb-console-image-lkft
```

Inside the image, these are the important directories:
```
/oe/
 + build-lkft/
 + downloads/
 + sstate-cache/
```

Since the instance is considered ephemeral, it's recommended to pass caches as volume. The same goes for the build directory, as it can be reused.

If `/oe/build-lkft/pre` exists, it will be run before the commands passed to the builder. Likewise, `/oe/build-lkft/post` will be called after running the commands given as arguments to the Docker instance. For example:

```
echo "ls -1 | mail someone@example.com -s Finished." > $(pwd)/build/post
```
