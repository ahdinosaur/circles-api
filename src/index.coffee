express = require("express")
levelgraph = require("levelgraph")
jsonld = require("levelgraph-jsonld")
app = express()
db = jsonld(levelgraph("../db"))

initData = require "./initData.js"

test = 0

app.get "/groups", (req, res, next) ->
  
  #db.search
  console.log initData

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
