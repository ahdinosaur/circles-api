(function() {
  var app, db, express, getGroup, initData, jsonld, levelgraph, validator;
  express = require("express");
  levelgraph = require("levelgraph");
  jsonld = require("levelgraph-jsonld");
  validator = require("validator");
  app = express();
  db = jsonld(levelgraph("../db"));
  initData = require("./initData.js");
  app.use(require("body-parser")());
  app.get("/groups", function(req, res, next) {
    var query;
    query = {
      subject: db.v("subj"),
      predicate: "http://relations.app.enspiral.com/phyle",
      object: "group"
    };
    console.log(query);
    return db.search([query], function(err, solution) {
      console.log('solution', solution);
      if (err) {
        res.json(304, {
          data: null,
          message: err
        });
      } else {
        res.json(200, {
          data: solution,
          message: 'ok'
        });
      }
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
    id = validator.isURL(id) ? req.params.id : "http://circles.app.enspiral.com/" + req.params.id;
    getGroup(res, id, initData[0]["@context"]);
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
  getGroup = function(res, id, context) {
    return db.jsonld.get(id, {
      '@context': context
    }, function(err, obj) {
      return res.json(200, {
        data: obj,
        message: 'ok'
      });
    });
  };
  module.exports = app;
}).call(this);
