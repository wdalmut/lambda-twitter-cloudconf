# Twitter -> Raspberry Pi -> Twitter engagement

A user tweet the CloudConf account, the Raspberry Pi take a picture and upload it
on Amazon S3 and then AWS Lambda tweet it to the user!

## Use it

Compile it

```
grunt

# watch it
grunt watch
```

Prepare the ZIP package for lambda

```
grunt dist
```

Upload the zip package to AWS Lambda

