X-Wing Miniatures Font
======================

Vector font by [Hinny](https://github.com/Hinny), [armoredgear7](https://github.com/armoredgear7), and [ScottKarch](https://github.com/ScottKarch).

[List of symbols](https://geordanr.github.io/xwing-miniatures-font/)

## Usage

    <span>On a <i class="xwing-miniatures-font xwing-miniatures-font-hit"></i> or <i class="xwing-miniatures-font xwing-miniatures-font-crit"></i>, go <strong>kaboom!</strong></span>
    <i class="xwing-miniatures-ship xwing-miniatures-ship-tiephantom"></i>

## Install

### Webpack

If you want, add an alias to make requiring the CSS suck a bit less:

    resolve: {
        alias: {
            'XWingMiniaturesFont.css$': path.resolve(path.join(__dirname, 'node_modules', 'xwing-miniatures-font', 'xwing-miniatures.css'))
        }
    }

Then in your code somewhere:

    require('XWingMiniaturesFont.css')

### Bower

This font pack is available as a Bower package which supplies the TTFs and CSS files.

    npm install bower
    `npm bin`/bower install xwing-miniatures-font

And use `bower_components/xwing-miniatures-font/dist/xwing-miniatures.css`.

### Just Tell Me Where the Files Are

    npm install xwing-miniatures-font

Then find the TTFs and CSS in `node_modules/xwing-miniatures-font/dist`.

## Development

    npm install
    npm run build
