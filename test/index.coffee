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
  members: [
    {
      "@id": "people:aaronthornton"
      name: "Aaron Thornton"
    },
    {
      "@id": "people:simontegg"
      name: "Simon Tegg"
    }
  ]


bestGroup =
  id: "http://circles.app.enspiral.com/bestgroup"
  name: "Best Group"

describe "#groups", ->
  before ->
    db = require("level-test")()("testdb")
    app = require('../')(db)
    request = request(app)
    return

  it "should POST /groups", (done) ->
    request
    .post("/groups")
    .send(group)
    .expect("Content-Type", /json/)
    .expect(201).expect((req) ->
      body = req.body
      ## why is it an array?
      expect(body[0]).to.have.property "@type", "foaf:group"
      for prop of body
        expect(body).to.have.property prop, body[prop]
      return)
    .end((err, res) ->
      return done(err) if err
      done())

  it "should GET /groups", (done) ->
    request
    .get("/groups")
    .expect("Content-Type", /json/)
    .expect(200)
    .expect((req) ->
      body = req.body
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
      expect(body).to.have.property "@type", "foaf:group"
      for prop of body
        expect(body).to.have.property prop, body[prop]
      return)
    .end((err, res) ->
      return done(err)  if err
      done())

  it "should GET /groups/:shortID", (done) ->
    request
    .get("/groups/" + urlencode(group.shortID) )
    .expect("Content-Type", /json/)
    .expect(200)
    .expect((req) ->
      body = req.body
      expect(body).to.have.property "@type", "foaf:group"
      for prop of body
        expect(body).to.have.property prop, body[prop]
      return)
    .end((err, res) ->
      return done(err)  if err
      done())

  it "should PUT /groups/:id", (done) ->
    request
    .put("/groups/" + urlencode(group.id))
    .send(group)
    .expect("Content-Type", /json/)
    .expect(200)
    .expect((req) ->
      body = req.body
      console.log body
      
      expect(body[0]).to.have.property "@type", "foaf:group"
      for prop of body
        expect(body).to.have.property prop, body[prop]
      return)
    .end((err, res) ->
      return done(err)  if err
      done())  

  #TODO
  it "should GET /groups/:id/members", (done) ->
    request
    .get("/groups/" + urlencode(group.id) + "/members")
    .expect("Content-Type", /json/)
    .expect(200)
    .expect((req) ->
      body = req.body
      console.log body, 'members'
      expect(body).to.contain.keys '@id', "name"
      return)
    .end((err, res) ->
      return done(err)  if err
      done())


  it "should DELETE /groups/:id", (done) ->
    request
    .del("/groups/" + urlencode(group.id))
    .expect(204)
    .end((err, res) ->
      return done(err) if err
      done()
    )

  it "should not GET deleted id", (done) ->
    request
    .get("/groups/" + urlencode(group.id))
    .expect("Content-Type", /json/)
    .expect(404)
    .end((err, res) ->
      return done(err)  if err
      done()
    )





