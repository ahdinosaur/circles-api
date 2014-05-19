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



  # query = 
  #   subject: db.v('subj')
  #   predicate: 'http://relations.app.enspiral.com/createdat'
  #   object: '2011-12-02T13:13'

  query =
    subject: db.v("subj")
    predicate: "http://relations.app.enspiral.com/phyle"
    object: "group"

  console.log query

  db.search [query], (err, solution) ->
    console.log 'solution', solution
    # add fake data if none present
    # if solution.length is 0
    #   initData.forEach (d,i) ->

    #     console.log d, i

    #     db.jsonld.put d, (err, obj) ->
    #       if err
    #         res.json 304,
    #           data: []
    #           message: err
    #       if i is initData.length-1
    #         res.json 200,
    #           data: initData
    #           message: 'fake data added'
    if err
      res.json 304,
        data: []
        message: err
    else
      res.json 200,
        data: solution
        message: 'ok' 
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
