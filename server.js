var db = require('level')('db')
var app = require('./')(db);
app.listen(5000);