require 'dotenv'
Dotenv.load

require "kafka"
require 'pusher'
kafka = Kafka.new(seed_brokers: ["localhost:9092"])

# Consumers with the same group id will form a Consumer Group together.
consumer = kafka.consumer(group_id: "my-consumer")

# It's possible to subscribe to multiple topics by calling `subscribe`
# repeatedly.
consumer.subscribe("domain_model_ack")

# This will loop indefinitely, yielding each message in turn.
consumer.each_message do |message|
  pusher_client = Pusher::Client.new(
      app_id: ENV['TEST_RUBY_KAFKA_PUSHER_APP_ID'],
      key: ENV['TEST_RUBY_KAFKA_PUSHER_KEY'],
      secret: ENV['TEST_RUBY_KAFKA_PUSHER_SECRET'],
      cluster: 'eu',
      encrypted: true
  )

  pusher_client.trigger('domain_model_ack', 'my_event', {
      message: message.value
  })
end

