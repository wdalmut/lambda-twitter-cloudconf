# Twitter -> Raspberry Pi -> Twitter engagement

A user tweet the CloudConf account, the Raspberry Pi take a picture and upload it
on Amazon S3 and then AWS Lambda tweet it to the user!

## Use it

Compile it

```
grunt
```

Create the Zip package

```
zip -r --exclude=node_modules/grunt* w.zip src/twitter.js node_modules/ config.json
```

Upload the zip package to AWS Lambda

