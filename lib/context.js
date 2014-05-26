(function() {
  module.exports = {
    "@language": "en",
    type: {
      "@id": "http://www.w3.org/1999/02/22-rdf-syntax-ns#type",
      "@type": "http://tools.ietf.org/html/rfc3987"
    },
    circles: "http://circles.app.enspiral.com/",
    foaf: "http://xmlns.com/foaf/0.1/",
    people: "http://people.app.enspiral.com/",
    relations: "http://relations.app.enspiral.com/",
    schema: "https://schema.org/",
    description: "schema:description",
    group: "foaf:group",
    image: "foaf:Image",
    name: "foaf:name",
    person: "foaf:Person",
    createdAt: {
      "@id": "relations:createdAt",
      "@type": "schema:DateTime"
    },
    modifiedAt: {
      "@id": "relations:createdAt",
      "@type": "schema:DateTime"
    },
    members: {
      "@id": "relations:members",
      "@type": "person"
    },
    subgroups: {
      "@id": "relations:subgroup",
      "@type": "group"
    },
    supergroups: {
      "@id": "relations:supergroup",
      "@type": "group"
    }
  };
}).call(this);
