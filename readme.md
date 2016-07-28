# HI THERE

This is my 

# Elm-0.17 Gulp Coffeescript Stylus Lodash Browserify Boilerplate

Its basically a template development environment with all of my favorite dependencies. It also might be useful to look at, if you are learning how to use Elm (especially you share my programming orientation).

How to get going..
```
> npm install
> elm package install
> gulp

then open up http://localhost:2996
```

package.json
``` json
{
  "name": "Elm-0.17-Gulp-Coffeescript-Stylus-Lodash-Browserify-Boilerplate",
  "version": "1.0.3",
  "description": "Elm-0.17 Gulp Coffeescript Stylus Lodash Browserify Boilerplate",
  "main": "gulpFile.coffee",
  "repository": {
    "type": "git",
    "url": "https://github.com/Chadtech/elm0.17-gulp-coffeescript-stylus-lodash-browserify-boilerplate"
  },
  "keywords": [
    "elm",
    "elmlang",
    "gulp",
    "boilerplate",
    "coffeescript",
    "lodash",
    "stylus",
    "browserify",
    "elm-0.17"
  ],
  "dependencies": {
    "body-parser": "^1.15.0",
    "browserify": "^13.0.0",
    "coffee-script": "^1.10.0",
    "coffeeify": "^2.0.1",
    "express": "^4.13.4",
    "gulp": "^3.9.1",
    "gulp-autowatch": "^1.0.2",
    "gulp-stylus": "^2.3.1",
    "lodash": "^4.6.1",
    "vinyl-buffer": "^1.0.0",
    "vinyl-source-stream": "^1.1.0"
  },
  "devDependencies": {},
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "start": "gulp"
  },
  "author": "Chadtech chadtech0@gmail.com",
  "license": "you can use it"
}


```

elm-package.json
``` json
{
  "version": "1.0.0",
  "summary": "Elm-0.17 Gulp Coffeescript Stylus Lodash Browserify Boilerplate",
  "repository": "https://github.com/Chadtech/elm0.17-gulp-coffeescript-stylus-lodash-browserify-boilerplate",
  "license": "you can use it",
  "source-directories": [
    "./src/elm"
  ],
  "exposed-modules": [],
    "dependencies": {
        "elm-lang/core": "4.0.3 <= v < 5.0.0",
        "elm-lang/html": "1.1.0 <= v < 2.0.0",
        "evancz/elm-http": "3.0.1 <= v < 4.0.0"
    },
    "elm-version": "0.17.1 <= v < 0.18.0"
}
```

**updates**
20160728 - Bringing Elm Package up to 17.1