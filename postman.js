const newman = require('newman'); // require newman in your project
 
// call newman.run to pass `options` object and wait for callback
newman.run({
    collection: require('./space_x.json'),
    reporters: 'cli'
}, function (err) {
    if (err) { throw err; }
    console.log('\nCollection run complete!\n');
});