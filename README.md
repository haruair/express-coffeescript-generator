express-coffeescript-generator
==============================
[express-generator](https://github.com/expressjs/generator) for coffeescript.

[![Build Status](https://travis-ci.org/haruair/express-coffeescript-generator.svg)](https://travis-ci.org/haruair/express-coffeescript-generator)

## Installation

```bash
$ npm install -g express-coffeescript-generator
```

## Quick Start

The quickest way to get started with express is to utilize the executable `express-cs(1)` to generate an application as shown below:

Create the app:

```bash
$ express-cs /tmp/foo && cd /tmp/foo
```

Install dependencies:

```bash
$ npm install
```

Rock and Roll

```bash
$ npm start
```

## Command Line Options

This generator can also be further configured with the following command line flags.

    -h, --help          output usage information
    -V, --version       output the version number
    -e, --ejs           add ejs engine support (defaults to jade)
        --hbs           add handlebars engine support
    -H, --hogan         add hogan.js engine support
    -c, --css <engine>  add stylesheet <engine> support (less|stylus|compass) (defaults to plain css)
        --git           add .gitignore
    -f, --force         force on non-empty directory

## License

[MIT](LICENSE)
