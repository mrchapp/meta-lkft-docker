Run this with
```
docker run -it \
  -e MACHINE=hikey \
  -v /opt/oe/downloads:/oe/downloads \
  -v /opt/oe/sstate-cache:/oe/sstate-cache \
  -v $(pwd)/build:/oe/rpb/build \
  mrchapp/rpb-thud   bitbake rpb-console-image
```

Inside the image, these are the important directories:
```
/oe/
 + downloads/
 + sstate-cache/
 + rpb/build/
```

Since the instance is considered ephemeral, it's recommended to pass caches as
volume. The same goes for the build directory, as it can be reused.

If `/oe/rpb/build/pre` exists, it will be run before the commands passed to the
builder. Likewise, `/oe/rpb/build/post` will be called after running the
commands given as arguments to the Docker instance. For example:
```
echo "ls -1 | mail someone@example.com -s Finished." > $(pwd)/build/post
```
