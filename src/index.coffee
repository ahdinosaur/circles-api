express = require "express"
levelgraph = require "levelgraph"
urlencode = require "urlencode"
validator = require "validator"
Promise = require "bluebird"


jsonld = Promise.promisifyAll(require("levelgraph-jsonld"))
jsonldUtil = require("jsonld")


_ = Promise.promisifyAll(require("lodash"))
alias = require "./utils/alias"
hasType = require "./utils/hasType"


app = express()
db = jsonld(levelgraph("../db"))

initData = require "./initData"
context = require "./context"


app.use require("body-parser")()

#methods

addContext = (term, context, callback) ->
  doc = {}
  doc[term] = term
  doc['@context'] = context
  callback(null, doc)

addDefaultPrefix = (terms, context, callback) ->
  if validator.isURL terms[1]
    callback null, terms
  else if terms[1].indexOf(':') is -1
    prefix = context[terms[0]]["defaultPrefix"]
    terms[1] = prefix + ":" + terms[1]
    callback null, terms
  else
    callback null, terms


create = (data, params, callback) ->
  # alias type to @type
  data = alias(data, "type", "@type")
  # ensure @type has "foaf:Person"
  data = hasType(data, "foaf:group")
  # alias id to @id
  data = alias(data, "id", "@id")
  db.jsonld.put data, (err, group) ->
    # if error, return error
    return callback(err) if err
    # return group
    compact(group, context, callback)

expandGroupID = (id, context, callback) ->
  terms = ["group", id]
  addDefaultPrefix(terms, context)
    .then((terms) -> addContext(terms[1], context))
    .then(expand)
    .then((expanded) -> getKey(expanded[0]))
    .then((expandedIRI) -> 
      callback null, expandedIRI)

expandSimpleQuery = (query, context, callback) ->
  pair(query)
    .then((terms) -> addDefaultPrefix(terms, context))
    .map((term) -> addContext(term, context))
    .map((doc) -> expand(doc))
    .then(extractPredicateAndObject)
    .then((expanded) -> 
      simpleQuery =
        subject: db.v('@id')
        predicate: expanded.predicate
        object: expanded.object

      callback(null, simpleQuery))

extractPredicateAndObject = (terms, callback) ->
  expanded =
    predicate: Object.keys(terms[0][0])[0]
    object: Object.keys(terms[1][0])[0]
  callback(null, expanded)

find = (query, callback) ->
  console.log query
  db.search query, (error, groups) ->
    if error
      callback(error)
    else
      callback(null, groups)

get = (id, callback) ->
  db.jsonld.get id, {'@context': context}, (error, group) ->
    if error
      callback error
    else
      callback null, group

getKey = (obj, callback) ->
  key = Object.keys(obj)[0]
  callback(null, key)

pair = (obj, callback) ->
  key = Object.keys(obj)[0]
  value = obj[key]
  terms = [key, value]
  callback(null, terms)

update = (id, data, params, callback) ->
  # alias type to @type
  data = alias(data, "type", "@type")
  # ensure @type has "foaf:Person"
  data = hasType(data, "foaf:group")
  # alias id to @id
  data = alias(data, "id", "@id")
  # if id in route doesn't match id in data, return 400
  if data["@id"] isnt id
    err = new Error("id in route does not match id in data")
    err.status = 400
    return callback(err)
  # put group in database
  db.jsonld.put data, (err, group) ->
    # if error, return error
    return callback(err) if err
    # return group
    compact(group, context, callback)


#promisfy methods
addContext = Promise.promisify addContext
addDefaultPrefix = Promise.promisify addDefaultPrefix
compact = Promise.promisify jsonldUtil.compact
create = Promise.promisify create
expand = Promise.promisify jsonldUtil.expand
expandGroupID = Promise.promisify expandGroupID
expandSimpleQuery = Promise.promisify expandSimpleQuery 
extractPredicateAndObject = Promise.promisify extractPredicateAndObject
find = Promise.promisify find
get = Promise.promisify get
getKey = Promise.promisify getKey
pair = Promise.promisify pair
update = Promise.promisify update



#routes
app.get "/", (req, res, next) ->
  addTestData(res)
  #deleteTestData(res)

app.get "/groups", (req, res, next) ->
  query = req.query
  keys = Object.keys(query)
  if keys.length is 0
    defaultQuery =
      subject: db.v('@id')
      predicate: "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
      object: "foaf:group"

    find(defaultQuery)
      .then((groups) ->
        res.json 200, groups)
    return
  else if keys.length > 1
    res.json 400, "GET /groups? only accepts 1 parameter key-value pair"
    return
  else
    expandSimpleQuery(query, context)
      .then(find)
      .then((groups) ->
        res.json 200, groups)

app.post "/groups", (req, res, next) ->
  body = req.body
  create(body, null)
    .then((group) -> 
      console.log 'group from post', group
      res.json 201,
        group)
  return

app.get "/groups/:id", (req, res, next) ->
  id = urlencode.decode req.params.id
  expandGroupID(id, context)
    .then(get)
    .then((group) ->
      res.json 200, group)
  return

app.put "/groups/:id", (req, res, next) ->
  id = urlencode.decode req.params.id
  body = req.body
  expandGroupID(id, context)
    .then((expandedIRI) -> update(expandedIRI, body, null))
    .then((group) ->
      res.json 200, group)
  return



app.delete "/groups/:id", (req, res, next) ->
  id = req.params.id

  db.jsonld.del id, (error) ->
    console.log 'deleted ' + id

  res.json 200,
    name: "DELETE /groups/" + id

#TODO make better and more general
app.get "/groups/:id/members", (req, res, next) ->
  id = if validator.isURL(id) then req.params.id else "http://circles.app.enspiral.com/" + req.params.id 
  getMembers(res, id, context)




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





module.exports = app
