# Defold examples

This repository includes the Defold examples application and the tools used to explode the app to the examples section on https://www.defold.com/examples

## Dependencies

Node.js and Gulp:

```sh
$ brew install node
$ npm install gulp-cli -g
$ npm install
```

## Edit and preview

```sh
$ gulp watch
```

Builds all documentation for preview and opens a browser pointing to the build root. Edits to any .md manual or image is detected, rebuilt and reloaded in browser.

## Build and publish

```sh
$ ./publish_sh
```

Builds the HTML5 application with "bob". Publishing documentation to GCS is done with the `gsutil` which is part of the Google Cloud SDK. It's automatically installed if needed.
