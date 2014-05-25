express = require "express"
levelgraph = require "levelgraph"
jsonld = require "levelgraph-jsonld"
validator = require "validator"
app = express()
db = jsonld(levelgraph("../db"))

initData = require "./initData.js"
context = require "./context.js"


app.use require("body-parser")()

callback = (err, data, res) ->
  if err
    res.json 404, {data: null, message: err}
  else
    res.json 200, {data: data, message: 'ok'}


app.get "/", (req, res, next) ->
  #addTestData(res)
  #deleteTestData(res)

app.get "/groups", (req, res, next) ->
  if Object.keys(req.query).length > 1
    res.json 400, {data: null, message: "GET /groups? only accepts 1 parameter"}
  else
    find(req.query, callback, res)

app.post "/groups", (req, res, next) ->
  body = req.body
  #db.jsonld.put(body, function (err, obj) {})
  res.json 200,
    name: "POST /groups"
  return

app.get "/groups/:id", (req, res, next) ->
  id = if validator.isURL(id) then req.params.id else "http://circles.app.enspiral.com/" + req.params.id 
  #getGroup(res, id, initData[0]["@context"])
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

  db.jsonld.del id, (error) ->
    console.log 'deleted ' + id

  res.json 200,
    name: "DELETE /groups/" + id


app.get "/groups/:id/members", (req, res, next) ->
  id = if validator.isURL(id) then req.params.id else "http://circles.app.enspiral.com/" + req.params.id 
  getMembers(res, id, context)


find = (params, callback, res) ->

  baseQuery =
    subject: db.v("@id")
    predicate: "http://relations.app.enspiral.com/class"
    object: "group"
  queries = [baseQuery]


  key = Object.keys(params)[0]
  query =
    subject: db.v('@id')
    predicate: 'http://relations.app.enspiral.com/members'
    object: queryObj[key]
  queries.push query

  console.log 'queries', queries
  searchLevelGraph(res, queries)

complexQuery = (res, queries, queryObj) ->



searchLevelGraph = (res, queries) ->
  db.search queries, (error, result) ->
    if error?
      res.json 304, {data: null, message: err}
    if result.length is 0
      res.json 200, {data: [], message: "not found"}
    else
      res.json 200, {data: result, message: 'ok'}
    return

getGroup = (res, id, context) ->
  db.jsonld.get id, {'@context': context}, (err, obj) ->
    res.json 200,
      data: obj
      message: 'ok' 

getMembers = (res, id, context) ->
  db.jsonld.get id, {'@context': context}, (err, obj) ->
    res.json 200,
      data: obj['relations:members']
      message: 'ok'   

addTestData = (res) ->
  initData.forEach (d,i) ->
    db.jsonld.put d, (err, obj) ->
      if i is initData.length-1
        res.json 200,
          data: initData
          message: 'test data added'

deleteTestData = (res) ->
  query =
    subject: db.v("@id")
    predicate: "http://relations.app.enspiral.com/class"
    object: "group"
  db.search [query], (error, result) ->
    result.forEach (d,i) ->
      db.jsonld.del d["@id"], (error) ->
        if i is result.length-1
          res.json 200, {data:[], message: "data base deleted"}



module.exports = app
