# Messages durability
require 'bunny'

conn = Bunny.new
conn.start

ch = conn.create_channel
# 1) durable: persist the queue even if server would be restarted
q  = ch.queue("hello", durable: true)
msg  = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

# 2) persistent: tells RabbitMQ to save the message to disk(in order not to lose it)
q.publish(msg, persistent: true)
puts " [x] Sent #{msg}"
