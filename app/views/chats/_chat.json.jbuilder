json.extract! chat, :id, :question, :answer, :state, :category_id, :created_at, :updated_at
json.url chat_url(chat, format: :json)
