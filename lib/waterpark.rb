require 'thread'

class WaterPark
  def initialize(opts={})
    @pools = {}
    @mutex_lock = Mutex.new
  end
  
  def add_pool(uid, host, port, opts={})
    @mutex_lock.synchronize do 
      @pools[uid] = SocketPool.new(host, port, opts)
    end

    return @pools[uid]
  end

  def remove_pool(uid, close_pool = true)
    @mutex_lock.synchronize do 
      pool = @pools.delete(uid)
      pool.close if close_pool
    end

    return !close_pool ? pool : nil
  end

  def get_pool(uid)
    return @pools[uid]
  end

  def get_all_pools
    return @pools
  end

  def merge(waterpark)
    @mutex_lock.synchronize do 
      merge_pools = waterpark.get_all_pools
      merge_pools.keys.each do |pool_key|
        @pools[pool_key] = waterpark.remove_pool(pool_key, false) if !@pools[pool_key] 
      end
    end
  end

  def checkout(uid)
    raise "No pool in the park with uid #{uid}" if !@pools[uid] 
    return @pools[uid].checkout 
  end

  def checkin(uid, sock, reset = false)
    raise "No pool in the park with uid #{uid}" if !@pools[uid]
    return @pools[uid].checkin(sock, reset)
  end

  def close
    @mutex_lock.synchronize do 
      pool_keys = @pools.keys
      pool_keys.each do |pk|
        remove_pool(pk, true)
      end
    end
  end
end
