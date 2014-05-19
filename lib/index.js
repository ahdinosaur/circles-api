(function() {
  var app, db, express, initData, jsonld, levelgraph;
  express = require("express");
  levelgraph = require("levelgraph");
  jsonld = require("levelgraph-jsonld");
  app = express();
  db = jsonld(levelgraph("../db"));
  initData = require("./initData.js");
  app.use(require("body-parser")());
  app.get("/groups", function(req, res, next) {
    db.search([
      {
        subject: db.v('subj'),
        predicate: '@type',
        object: 'group'
      }
    ], function(err, solution) {
      console.log('err', err);
      return console.log('solution', solution);
    });
    res.json(200, {
      name: "GET /groups"
    });
  });
  app.post("/groups", function(req, res, next) {
    var body;
    body = req.body;
    res.json(200, {
      name: "POST /groups"
    });
  });
  app.get("/groups/:id", function(req, res, next) {
    var id;
    id = req.params.id;
    res.json(200, {
      name: "GET /groups" + id
    });
  });
  app.put("/groups/:id", function(req, res, next) {
    var body, id;
    id = req.params.id;
    body = req.params.body;
    res.json(200, {
      name: "PUT /groups/" + id
    });
  });
  app["delete"]("/groups/:id", function(req, res, next) {
    var id;
    id = req.params.id;
    db.jsonld.del(id, function(err) {
      return console.log('deleted ' + id);
    });
    return res.json(200, {
      name: "DELETE /groups/" + id
    });
  });
  module.exports = app;
}).call(this);
