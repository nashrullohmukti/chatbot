require 'exception_notification/rails'


# require 'resque/failure/multiple'
# require 'resque/failure/redis'
# require 'exception_notification/resque'

# Resque::Failure::Multiple.classes = [Resque::Failure::Redis, ExceptionNotification::Resque]
# Resque::Failure.backend = Resque::Failure::Multiple


ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  # config.ignored_exceptions += %w{ActionView::TemplateError CustomError}

  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.
  config.ignore_if do |exception, options|
    not Rails.env.production?
  end

  # Notifiers =================================================================

  # Email notifier sends notifications by email.
  config.add_notifier :email, {
    :email_format         => :html,
    :email_prefix         => "[ERROR] ",
    :sender_address       => %{"Chatbot notifier" <no-reply@chatbot.com>},
    :exception_recipients => %w{ervina nasrul}.map { |name| "#{name}@41studio.com" }
  }

  # Campfire notifier sends notifications to your Campfire room. Requires 'tinder' gem.
  # config.add_notifier :campfire, {
  #   :subdomain => 'my_subdomain',
  #   :token => 'my_token',
  #   :room_name => 'my_room'
  # }

  # HipChat notifier sends notifications to your HipChat room. Requires 'hipchat' gem.
  # config.add_notifier :hipchat, {
  #   :api_token => 'my_token',
  #   :room_name => 'my_room'
  # }

  # Webhook notifier sends notifications over HTTP protocol. Requires 'httparty' gem.
  # config.add_notifier :webhook, {
  #   :url => 'http://example.com:5555/hubot/path',
  #   :http_method => :post
  # }

end
