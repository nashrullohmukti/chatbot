class PagesController < ApplicationController

  def index
  end

  def chat
    require 'wit'

    actions = {
      send: -> (request, response) {
        puts("#{response['text']}")
      },
      my_action: -> (request) {
        return request['context']
      },
    }

    client = Wit.new(access_token: 'M4GB7SH2227PBRYN3KTQMJLEJ5NPN3CT', actions: actions)
    rsp    = client.converse("session_id_test", params[:question])
    @msg   = rsp["msg"]
  end
end
