require 'bunny'

conn = Bunny.new
conn.start

ch = conn.create_channel
q  = ch.queue("hello")
msg  = ARGV.empty? ? "Hello World!" : ARGV.join(" ")
p msg

q.publish(msg, persistent: true)
puts " [x] Sent #{msg}"
