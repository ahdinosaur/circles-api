express = require "express"
levelgraph = require "levelgraph"
jsonld = require "levelgraph-jsonld"
validator = require "validator"
async = require "async"
_ = require "lodash"
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
  addTestData(res)
  #deleteTestData(res)

app.get "/groups", (req, res, next) ->
  query = req.query
  if Object.keys(query).length is 0
    defaultQuery =
      subject: db.v('@id')
      predicate: "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
      object: "foaf:group"
    find(defaultQuery, res, callback)
  else if Object.keys(params).length > 1
    res.json 400, {data: null, message: "GET /groups? only accepts 1 parameter"}
  else
    async.waterfall([
      (callback) ->
        parseQuery(query, callback)
      ],
      (err, result) ->
        console.log 'result', result

      )


app.post "/groups", (req, res, next) ->
  body = req.body
  #db.jsonld.put(body, function (err, obj) {})
  res.json 200,
    name: "POST /groups"
  return

app.get "/groups/:id", (req, res, next) ->
  id = if validator.isURL(id) then req.params.id else "http://circles.app.enspiral.com/" + req.params.id 
  get(id, res, callback)
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

expandIRI = (term, context, callback) ->
  if context[term]?
    if validator.isURL(context[term])
      callback(null, context[term])
    else
      if context[term].indexOf ':' > -1
        shorthand = context[term].split(':')
        async.waterfall([
          (callback) ->
            expandIRI(shorthand[0], context, callback)
          ],
          (err, prefix) ->
            expanded = prefix + shorthand[1]
            callback(null, expanded)

          )
      else
        ##TODO
  else
    #TODO

parseQuery = (query, context, res, callback) ->




find = (query, res, callback) ->
  console.log query
  db.search query, (error, groups) ->
    if error
      callback(error)
    else
      callback(null, groups, res)



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

get = (id, res, callback) ->
  db.jsonld.get id, {'@context': context}, (error, result) ->
    if error
      callback(error, null, res)
    else
      callback(null, result, res)

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

  db.jsonld.del "http://circles.app.enspiral.com/loomiocommunity", (error) ->
    res.json 200, {data:[], message: "data base deleted"}


  # query =
  #   subject: db.v("@id")
  #   predicate: "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
  #   object: "foaf:group"
  # db.search [query], (error, result) ->
  #   result.forEach (d,i) ->
  #     db.jsonld.del d["@id"], (error) ->
  #       if i is result.length-1
  #         res.json 200, {data:[], message: "data base deleted"}



module.exports = app
