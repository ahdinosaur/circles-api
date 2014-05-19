(function() {
  var data;
  data = [
    {
      "@context": {
        "circles": "http://circles.app.enspiral.com/",
        "foaf": "http://xmlns.com/foaf/0.1/",
        "people": "http://people.app.enspiral.com/",
        "relations": "http://relations.app.enspiral.com/",
        "schema": "https://schema.org/",
        "description": "schema:description",
        "loomio": {
          "@id": "http://loomio.org",
          "@type": "foaf:OnlineAccount"
        },
        "cobudget": {
          "@id": "http://cobudget.enspiral.com",
          "@type": "foaf:OnlineAccount"
        },
        "accounts": "foaf:account",
        "accountName": "foaf:accountName",
        "createdAt": {
          "@id": "relations:createdat",
          "@type": "schema:DateTime"
        },
        "group": "foaf:Group",
        "image": "foaf:Image",
        "@language": "en",
        "members": {
          "@id": "relations:members",
          "@type": "person"
        },
        "name": "foaf:name",
        "person": "foaf:Person",
        "subgroups": "relations:subgroup",
        "supergroups": "relations:supergroups"
      },
      "@id": "circles:loomiocommunity",
      "@type": "group",
      "name": "Loomio Community",
      "createdAt": "2011-12-02T13:13",
      "description": "A public group for the whole community of Loomio users   and supporters to get together, discuss and collaborate.   Find out more about how this community works here:   https://www.loomio.org/discussions/5200",
      "members": [
        {
          "@id": "people:aaronthornton",
          "name": "Aaron Thornton",
          "accounts": [
            {
              "@id": "loomio",
              "accountName": "aaronthornton"
            }, {
              "@id": "cobudget",
              "accountName": "aaronthornton"
            }
          ]
        }
      ]
    }
  ];
  module.exports = data;
}).call(this);
