require 'bunny'

conn = Bunny.new
conn.start

ch = conn.create_channel
q  = ch.queue("hello", durable: true)

# This tells RabbitMQ not to give more than one message to a worker at a time.
# Or, in other words, don't dispatch a new message to a worker until it has processed and acknowledged the previous one.
# Instead, it will dispatch it to the next worker that is not still busy.
ch.prefetch(1)

puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"

begin
  q.subscribe(manual_ack: true, block: true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"
    # imitate some work
    sleep body.count(".").to_i
    puts " [x] Done"

    ch.ack(delivery_info.delivery_tag)
  end
rescue Interrupt
  conn.close
end
