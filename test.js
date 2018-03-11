var request = require('request');
var fontkit = require('fontkit');
var colors = require('colors');

// Returns the JSON font map for the specificed icon set
function getFontMap(name) {
    var map = require('./src/json/' + name + '-map.json');
    return map[name];
}

// Asserts that all of the characters in the font map have a valid character glyph for the given font
function assertGlyphs(font, mapName, assert) {
    var font = fontkit.openSync('dist/' + font + '.ttf')
    
    // Get map of ship icons
    var map = getFontMap(mapName);
    
    for (var name in map) {
        var character = map[name];
        var codePoint = character.charCodeAt();
        assert.ok(font.hasGlyphForCodePoint(codePoint), mapName + ": '" + name + "'' checking for valid glyph...")
    }

}

exports['test icon glyphs'] = function(assert) {
    assertGlyphs('xwing-miniatures', 'icons', assert);
};
 
exports['test ship glyphs'] = function(assert) {
    assertGlyphs('xwing-miniatures-ships', 'ships', assert);
};

exports['test ship names'] = function(assert, done) {

    // Get map of ship icons
    var shipMap = getFontMap('ships');

    // Get X-Wing database for ships
    request('https://github.com/guidokessels/xwing-data/raw/master/data/ships.js', function (error, response, body) {    

        var allShipData = JSON.parse(body);

        // Check that all ships in the database have an icon
        allShipData.forEach(function(shipData) {
            var name = shipData['xws'];

            // Some huge ships are encoded as [name]aft and [name]fore to represent front and back.
            // Only check these once.
            if (shipData['size'] == 'huge') {
                if (name.endsWith('fore')) {
                    name = name.substring(0, name.length - 4);
                } else if (name.endsWith('aft')) {
                    return;
                }
            }
            
            // This should only generate a warning
            if (shipMap[name] == undefined) {
                console.warn(("    WARNING: '" + name + "' missing ship icon.").yellow);
            }
            delete shipMap[name];
        });

        // Check that all icon names have a ship in the database
        // assert.equal(shipMap.length, 0, "The following ships do not exist in the x-wing database: " + Object.keys(shipMap))
        for (var name in shipMap) {
            assert.ok(false, "'" + name + "' is not in the x-wing ships database. Possible duplicate or typo?");
        }
        
        done();
    });
};

if (module == require.main) require('test').run(exports)