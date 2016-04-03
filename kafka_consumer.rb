require "kafka"
require 'pusher'
kafka = Kafka.new(seed_brokers: ["localhost:9092"])

# Consumers with the same group id will form a Consumer Group together.
consumer = kafka.consumer(group_id: "my-consumer")

# It's possible to subscribe to multiple topics by calling `subscribe`
# repeatedly.
consumer.subscribe("test_ack")

# This will loop indefinitely, yielding each message in turn.
consumer.each_message do |message|
  pusher_client = Pusher::Client.new(
      app_id: 'app_id',
      key: 'key',
      secret: 'secret',
      cluster: 'eu',
      encrypted: true
  )

  pusher_client.trigger('test_ack', 'my_event', {
      message: message.value
  })
end

