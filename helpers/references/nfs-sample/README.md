# :facepalm:

I always forget:

```shell
chown -R 1000:1000 /path/to/nfs/export # should match what is in your pod definition
chmod -R 775 /path/to/nfs/export
```
