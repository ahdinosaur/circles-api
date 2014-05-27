express = require "express"
levelgraph = require "levelgraph"

validator = require "validator"
Promise = require "bluebird"


jsonld = Promise.promisifyAll(require("levelgraph-jsonld"))
jsonldUtil = require("jsonld")

expand = Promise.promisify(jsonldUtil.expand)

_ = require "lodash"
app = express()
db = jsonld(levelgraph("../db"))

initData = require "./initData.js"
context = require "./context.js"


app.use require("body-parser")()




find = (query, callback) ->
  console.log query
  db.search query, (error, groups) ->
    if error
      callback(error)
    else
      callback(null, groups)
  return

addContext = (doc, context, callback) ->
  doc['@context'] = context
  console.log 'doc', doc
  callback(null, doc)
  return



find = Promise.promisify find
addContext = Promise.promisify addContext


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

    find(defaultQuery)
      .then((groups) ->
        res.json 200, groups)
    return
  else if Object.keys(query).length > 1
    res.json 400, "GET /groups? only accepts 1 parameter"
    return
  else
    addContext(query, context)
      .then(expand)
      # .then (doc) -> jsonldUtil.expand(doc, (err, expanded) ->
      #   console.log err
      #   console.log expanded

      #   )
      .then((expanded) -> console.log(JSON.stringify(expanded)))


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
