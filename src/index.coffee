express = require("express")
levelgraph = require("levelgraph")
jsonld = require("levelgraph-jsonld")
app = express()
db = jsonld(levelgraph("../db"))

initData = require "./initData.js"


app.get "/groups", (req, res, next) ->
  
  db.search [{subject: db.v('group')}], (err, solution) ->
    console.log 'err', err
    console.log 'solution', solution

    console.log 'initData', initData

  res.json 200,
    name: "GET /groups"
  return

app.post "/groups", (req, res, next) ->
  body = req.body
  #db.jsonld.put(body, function (err, obj) {})
  res.json 200,
    name: "POST /groups"
  return

app.get "/groups/:id", (req, res, next) ->
  id = req.params.id
  # use db.jsonld.get(id, context, function (err, obj) {})
  res.json 200,
    name: "GET /groups" + id
  return

app.put "/groups/:id", (req, res, next) ->
  id = req.params.id
  body = req.params.body
  # use db.jsonld.put(body, function (err, obj) {})
  res.json 200,
    name: "PUT /groups/" + id
  return

app.delete "/groups/:id", (req, res, next) ->
  id = req.params.id

  res.json 200,
    name: "DELETE /groups/" + id


module.exports = app
