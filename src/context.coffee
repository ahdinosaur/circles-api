module.exports =
  "@language": "en"
  type: 
    "@id": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
    "@type":  "http://tools.ietf.org/html/rfc3987"

  # prefixes
  circles: "http://circles.app.enspiral.com/"
  foaf: "http://xmlns.com/foaf/0.1/"
  people: 
    "@id": "http://people.app.enspiral.com/"
    "@type": "foaf:Person"
  relations: "http://relations.app.enspiral.com/"
  schema: "https://schema.org/"
  
  #properties
  description: "schema:description"
  group: "foaf:group"
  image: "foaf:Image"
  name: "foaf:name"
  person: "foaf:Person"

  createdAt:
    "@id": "relations:createdAt"
    "@type": "schema:DateTime"

  modifiedAt:
    "@id": "relations:createdAt"
    "@type": "schema:DateTime"
  
  #relations
  members: 
    "@id": "relations:members"
    "@type": "person"
    "defaultPrefix": "people"
  subgroups:
    "@id": "relations:subgroup"
    "@type": "group"
  supergroups:
    "@id": "relations:supergroup"
    "@type": "group"



  