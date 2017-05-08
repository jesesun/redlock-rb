require './redlock.rb'
require '../redis-rb-cluster/cluster.rb'

#dlm = Redlock.new("redis://127.0.0.1:6379","redis://127.0.0.1:6380","redis://127.0.0.1:6381")
if ARGV.length != 2
    startup_nodes = [
        {:host => "10.0.2.4", :port => 7000},
        {:host => "10.0.2.5", :port => 7000},
        {:host => "10.0.2.6", :port => 7000}
    ]
else
    startup_nodes = [
        {:host => ARGV[0], :port => ARGV[1].to_i}
    ]
end

rc = RedisCluster.new(startup_nodes,32,:timeout => 0.1)

dlm = Redlock.new(rc)

#    my_lock = dlm.lock("foo",1000)
#    dlm.unlock(my_lock)
while 1
    my_lock = dlm.lock("foo",1000)
    if my_lock
        puts "Acquired by client #{dlm}"
        dlm.unlock(my_lock)
    else
        puts "Error, lock not acquired"
    end
end
