var express = require('express');

var app = express();

app.use(function(req, res, next) {
    var data = '';
    req.setEncoding('utf8');
    req.on('data', function(chunk) {
       data += chunk;
    });
 
    req.on('end', function() {
        req.body = data;
        next();
    });
});

var text = "";

app.get("/", function(req, res) {
	res.send(text);
});

app.post("/", function(req, res) {
	text = req.body;
	res.send(200);
});

app.listen(8080);
