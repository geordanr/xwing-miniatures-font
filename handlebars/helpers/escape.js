module.exports = function(variable) {
    return variable.replace(/./g, function(character) {
		var escape = character.charCodeAt().toString(16);
		return '\\' + ('0000' + escape).slice(-4);
	});
};