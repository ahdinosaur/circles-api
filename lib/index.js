(function() {
  var addTestData, app, callback, complexQuery, context, db, deleteTestData, express, find, getGroup, getMembers, initData, jsonld, levelgraph, searchLevelGraph, validator;
  express = require("express");
  levelgraph = require("levelgraph");
  jsonld = require("levelgraph-jsonld");
  validator = require("validator");
  app = express();
  db = jsonld(levelgraph("../db"));
  initData = require("./initData.js");
  context = require("./context.js");
  app.use(require("body-parser")());
  callback = function(err, data, res) {
    if (err) {
      return res.json(404, {
        data: null,
        message: err
      });
    } else {
      return res.json(200, {
        data: data,
        message: 'ok'
      });
    }
  };
  app.get("/", function(req, res, next) {});
  app.get("/groups", function(req, res, next) {
    if (Object.keys(req.query).length > 1) {
      return res.json(400, {
        data: null,
        message: "GET /groups? only accepts 1 parameter"
      });
    } else {
      return find(req.query, callback, res);
    }
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
    db.jsonld.del(id, function(error) {
      return console.log('deleted ' + id);
    });
    return res.json(200, {
      name: "DELETE /groups/" + id
    });
  });
  app.get("/groups/:id/members", function(req, res, next) {
    var id;
    id = validator.isURL(id) ? req.params.id : "http://circles.app.enspiral.com/" + req.params.id;
    return getMembers(res, id, context);
  });
  find = function(params, callback) {
    var baseQuery, key, queries, query;
    baseQuery = {
      subject: db.v("@id"),
      predicate: "http://relations.app.enspiral.com/class",
      object: "group"
    };
    queries = [baseQuery];
    key = Object.keys(queryObj)[0];
    query = {
      subject: db.v('@id'),
      predicate: 'http://relations.app.enspiral.com/members',
      object: queryObj[key]
    };
    queries.push(query);
    console.log('queries', queries);
    return searchLevelGraph(res, queries);
  };
  complexQuery = function(res, queries, queryObj) {};
  searchLevelGraph = function(res, queries) {
    return db.search(queries, function(error, result) {
      if (error != null) {
        res.json(304, {
          data: null,
          message: err
        });
      }
      if (result.length === 0) {
        res.json(200, {
          data: [],
          message: "not found"
        });
      } else {
        res.json(200, {
          data: result,
          message: 'ok'
        });
      }
    });
  };
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
  getMembers = function(res, id, context) {
    return db.jsonld.get(id, {
      '@context': context
    }, function(err, obj) {
      return res.json(200, {
        data: obj['relations:members'],
        message: 'ok'
      });
    });
  };
  addTestData = function(res) {
    return initData.forEach(function(d, i) {
      return db.jsonld.put(d, function(err, obj) {
        if (i === initData.length - 1) {
          return res.json(200, {
            data: initData,
            message: 'test data added'
          });
        }
      });
    });
  };
  deleteTestData = function(res) {
    var query;
    query = {
      subject: db.v("@id"),
      predicate: "http://relations.app.enspiral.com/class",
      object: "group"
    };
    return db.search([query], function(error, result) {
      return result.forEach(function(d, i) {
        return db.jsonld.del(d["@id"], function(error) {
          if (i === result.length - 1) {
            return res.json(200, {
              data: [],
              message: "data base deleted"
            });
          }
        });
      });
    });
  };
  module.exports = app;
}).call(this);
