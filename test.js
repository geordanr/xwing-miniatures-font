var fetch = require('node-fetch')
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

function canonicalize(s) {
    return s.toLowerCase().replace(/[^a-z0-9]/g, '')
}

exports['test ship names'] = function(assert, done) {
    // Epic ships to ignore (for now)
    let ignoredEpicShips = new Set([
            "cr90corvette",
            "croccruiser",
            "gozanticlasscruiser",
            "gr75mediumtransport",
            "raiderclasscorvette",
        ]),
        knownMissingShips = new Set([
            "tiesffighter",
        ]),
        fontShipNames = new Set(Object.keys(getFontMap('ships'))),
        xwdataUrlBase = 'https://raw.githubusercontent.com/guidokessels/xwing-data2/master/'

    // Get all ship JSON paths
    fetch(xwdataUrlBase + 'data/manifest.json')
    .then(resp => resp.json())
    .then(manifest => {
        let shipfiles = []
        for (let factionData of manifest.pilots) {
            shipfiles = shipfiles.concat(factionData.ships)
        }
        // Fetch ship data in parallel
        return Promise.all(shipfiles.map(path =>
            fetch(xwdataUrlBase + path)
            .then(r => r.json())
            .then(shipdata => canonicalize(shipdata.name))
        ))
    })
    .then(dataShipNames => {
        // TODO: huge ships, when they arrive
        dataShipNames = new Set(dataShipNames)
        for (let name of dataShipNames) {
            if (!fontShipNames.has(name)) {
                console.warn((`    WARNING: '${name}' missing ship icon.`).yellow);
            }
        }
        for (let name of fontShipNames) {
            if (!dataShipNames.has(name) && !ignoredEpicShips.has(name)) {
                if (knownMissingShips.has(name)) {
                    console.warn((`    WARNING: icon exists for '${name}' which is known not to exist in xwing-data2`).yellow)
                } else {
                    assert.ok(false, `'${name}' is not in the x-wing ships database. Possible duplicate or typo?`);
                }
            }
        }
    })
    .catch(err => {
        assert.ok(false, `failed fetching ship data from xwing-data2: ${err}`)
        done()
    })
};

if (module == require.main) require('test').run(exports)