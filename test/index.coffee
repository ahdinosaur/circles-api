request = require("supertest")
expect = require("chai").expect
urlencode = require("urlencode")

app = undefined
db = undefined
person = undefined 

describe "#groups", ->
  before ->
    db = require("level-test")()("testdb")
    app = require("../")(db)
    return

  it "should GET /groups", (done) ->
    request(app)
    .get("/groups")
    .expect("Content-Type", /json/)
    .expect(200)
    .expect((req) ->
      body = req.body

      expect(body).to.have.length 1
      for prop of body[0]
        expect(body[0]).to.have.property prop, body[0][prop]
      return
    )
    .end((err, res) ->
      return done(err)  if err
      done()
    )

  it "should GET /groups/:id", (done) ->
    request(app)
    .get("/groups/" + urlencode(group.id))
    .expect("Content-Type", /json/)
    .expect(200)
    .expect((req) ->
      body = req.body

      expect(body).to.have.property "type", "foaf:Gerson"
      for prop of body
        expect(body).to.have.property prop, body[prop]
      return
    )
    .end((err, res) ->
      return done(err)  if err
      done()
    )

