express = require("express")
levelgraph = require("levelgraph")
jsonld = require("levelgraph-jsonld")
app = express()
db = jsonld(levelgraph("../db"))

initData = require "./initData.js"
app.use require("body-parser")()

app.get "/groups", (req, res, next) ->

  # db.jsonld.del 'http://circles.app.enspiral.com/loomiocommunity', (err) ->
  #   console.log 'deleted '


  db.search [{subject: db.v('subj'), predicate: '@type', object: 'group'}], (err, solution) ->

    console.log 'err', err
    console.log 'solution', solution

    # if solution.length is 0
    #   db.jsonld.put initData[0], (err, obj) ->
    #     console.log 'err', err
    #     console.log 'obj', obj



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

  db.jsonld.del id, (err) ->
    console.log 'deleted ' + id

  res.json 200,
    name: "DELETE /groups/" + id


module.exports = app
