require 'wit'

actions = {
  send: -> (request, response) {
    puts("sending... #{response['text']}")
  },
  my_action: -> (request) {
    return request['context']
  },
}

client = Wit.new(access_token: 'M4GB7SH2227PBRYN3KTQMJLEJ5NPN3CT', actions: actions)
rsp = client.get_entities()
puts("#{rsp}")
