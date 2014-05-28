request = require("supertest")
expect = require("chai").expect
urlencode = require("urlencode")

app = undefined
db = undefined
# group = undefined 

group =
  id: "http://circles.app.enspiral.com/loomiocommunity"
  prefixID: "circles:loomiocommunity"
  shortID: "loomiocommunity"
  name: "Loomio Community"

console.log 'encoded',urlencode(group.id)

request = request('http://localhost:5000')

describe "#groups", ->
  before ->
    # db = require("level-test")()("testdb")
    # app = require('../lib/index.js')(db)

    return

  # it "should POST /groups", (done) ->


  #   request(app)
  #   .post("/groups")
  #   .send(group)
  #   .expect("Content-Type", /json/)
  #   .expect(201).expect((req) ->
  #     body = req.body
  #     console.log 'test req.body', body

  #     expect(body).to.have.property "type", "foaf:gerson"
  #     for prop of body
  #       expect(body).to.have.property prop, body[prop]
  #     return
  #   )
  #   .end((err, res) ->
  #     return done(err) if err
  #     done()
  #   )


  it "should GET /groups", (done) ->
    request
    .get("/groups")
    .expect("Content-Type", /json/)
    .expect(200)
    .expect((req) ->
      body = req.body
      expect(body).to.have.length 1
      for prop of body[0]
        expect(body[0]).to.have.property prop, body[0][prop]
      return)
    .end((err, res) ->
      return done(err)  if err
      done())

  it "should GET /groups/:id", (done) ->
    request
    .get("/groups/" + urlencode(group.id) ) #'loomiocommunity')
    .expect("Content-Type", /json/)
    .expect(200)
    .expect((req) ->
      body = req.body
      console.log 'GET groups/:id body', body
      expect(body).to.have.property "@type", "foaf:group"
      for prop of body
        expect(body).to.have.property prop, body[prop]
      return)
    .end((err, res) ->
      return done(err)  if err
      done())

  it "should GET /groups/:prefix:id", (done) ->
    request
    .get("/groups/" + urlencode(group.prefixID) ) #'loomiocommunity')
    .expect("Content-Type", /json/)
    .expect(200)
    .expect((req) ->
      body = req.body
      console.log 'GET groups/:id body', body
      expect(body).to.have.property "@type", "foaf:group"
      for prop of body
        expect(body).to.have.property prop, body[prop]
      return)
    .end((err, res) ->
      return done(err)  if err
      done())

  it "should GET /groups/:shortID", (done) ->
    request
    .get("/groups/" + urlencode(group.shortID) ) #'loomiocommunity')
    .expect("Content-Type", /json/)
    .expect(200)
    .expect((req) ->
      body = req.body
      console.log 'GET groups/:id body', body
      expect(body).to.have.property "@type", "foaf:group"
      for prop of body
        expect(body).to.have.property prop, body[prop]
      return)
    .end((err, res) ->
      return done(err)  if err
      done())


