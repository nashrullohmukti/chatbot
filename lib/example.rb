require 'wit'

actions = {
  send: -> (request, response) {
    puts("#{response['text']}")
  },
  my_action: -> (request) {
    return request['context']
  },
}

server = Wit.new(access_token: '2MS3427JTZQPXOARPKEPU7YRWYTPIYTN', actions: actions)
payload = {
  "doc" => "A city that I like",
  "id" => "faforite_city",
  "values" => [{
      "value" => "Paris",
      "expressions" => [
        "Paris",
        "City of Light",
        "Capital of France"
      ]
    }]
}
rsp = server.post_entities(payload)
puts("#{rsp}")
