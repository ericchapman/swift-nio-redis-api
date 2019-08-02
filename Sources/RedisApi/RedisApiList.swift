import NIO

public protocol RedisApiList: RedisApiSend {
    
    /// BLPOP key [key ...] timeout
    /// BLPOP is a blocking list pop primitive
    ///
    /// [SPEC](https://redis.io/commands/blpop)
    ///
    func blpop(keys: [String], timeout: Int) -> EventLoopFuture<(String, String)?>
    
    /// BRPOP key [key ...] timeout
    ///
    /// BRPOP is a blocking list pop primitive
    ///
    /// [SPEC](https://redis.io/commands/brpop)
    ///
    func brpop(keys: [String], timeout: Int) -> EventLoopFuture<(String, String)?>
    
    /// BRPOPLPUSH source destination timeout
    ///
    /// BRPOPLPUSH is the blocking variant of RPOPLPUSH
    ///
    /// [SPEC](https://redis.io/commands/brpoplpush)
    ///
    func brpoplpush(source: String, destination: String, timeout: Int) -> EventLoopFuture<String?>
    
    /// LINDEX key index
    ///
    /// Returns the element at index index in the list stored at key
    ///
    /// [SPEC](https://redis.io/commands/lindex)
    ///
    func lindex(key: String, index: Int) -> EventLoopFuture<String?>
    
    /// LINSERT key BEFORE|AFTER pivot value
    ///
    /// Inserts value in the list stored at key either before or after
    /// the reference value pivot
    ///
    /// [SPEC](https://redis.io/commands/linsert)
    ///
    @discardableResult
    func linsert(key: String, before pivot: String, value: String) -> EventLoopFuture<Int>
    @discardableResult
    func linsert(key: String, after pivot: String, value: String) -> EventLoopFuture<Int>
    
    /// LLEN key
    ///
    /// Returns the length of the list stored at key
    ///
    /// [SPEC](https://redis.io/commands/llen)
    ///
    func llen(key: String) -> EventLoopFuture<Int>
    
    /// LPOP key
    ///
    /// Removes and returns the first element of the list stored at key
    ///
    /// [SPEC](https://redis.io/commands/lpop)
    ///
    func lpop(key: String) -> EventLoopFuture<String?>
    
    /// LPUSH key value [value ...]
    ///
    /// Insert all the specified values at the head of the list stored at key
    ///
    /// [SPEC](https://redis.io/commands/lpush)
    ///
    @discardableResult
    func lpush(key: String, values: [String]) -> EventLoopFuture<Int>
    
    /// LPUSHX key value
    ///
    /// Inserts value at the head of the list stored at key, only if
    /// key already exists and holds a list
    ///
    /// [SPEC](https://redis.io/commands/lpushx)
    ///
    @discardableResult
    func lpushx(key: String, value: String) -> EventLoopFuture<Int>
    
    /// LRANGE key start stop
    ///
    /// Returns the specified elements of the list stored at key
    ///
    /// [SPEC](https://redis.io/commands/lrange)
    ///
    func lrange(key: String, start: Int, stop: Int) -> EventLoopFuture<[String]>
    
    /// LREM key count value
    ///
    /// Removes the first count occurrences of elements equal to value
    /// from the list stored at key
    ///
    /// [SPEC](https://redis.io/commands/lrem)
    ///
    @discardableResult
    func lrem(key: String, count: Int, value: String) -> EventLoopFuture<Int>
    
    /// LSET key index value
    ///
    /// Sets the list element at index to value. For more information
    /// on the index argument, see LINDEX
    ///
    /// [SPEC](https://redis.io/commands/lset)
    ///
    @discardableResult
    func lset(key: String, index: Int, value: String) -> EventLoopFuture<Bool>
    
    /// LTRIM key start stop
    ///
    /// Trim an existing list so that it will contain only the specified
    /// range of elements specified
    ///
    /// [SPEC](https://redis.io/commands/ltrim)
    ///
    @discardableResult
    func ltrim(key: String, start: Int, stop: Int) -> EventLoopFuture<Bool>
    
    /// RPOP key
    ///
    /// Removes and returns the last element of the list stored at key
    ///
    /// [SPEC](https://redis.io/commands/rpop)
    ///
    func rpop(key: String) -> EventLoopFuture<String?>
    
    /// RPOPLPUSH source destination
    ///
    /// Atomically returns and removes the last element (tail) of the
    /// list stored at source, and pushes the element at the first element
    /// (head) of the list stored at destination
    ///
    /// [SPEC](https://redis.io/commands/rpushlpush)
    ///
    func rpoplpush(source: String, destination: String) -> EventLoopFuture<String?>
    
    /// RPUSH key value [value ...]
    ///
    /// Insert all the specified values at the tail of the list stored at key
    ///
    /// [SPEC](https://redis.io/commands/rpush)
    ///
    @discardableResult
    func rpush(key: String, values: [String]) -> EventLoopFuture<Int>
    
    /// RPUSHX key value
    ///
    /// Inserts value at the tail of the list stored at key, only if
    /// key already exists and holds a list
    ///
    /// [SPEC](https://redis.io/commands/rpushx)
    ///
    @discardableResult
    func rpushx(key: String, value: String) -> EventLoopFuture<Int>
}

extension RedisApiList {
    
    public func blpop(keys: [String], timeout: Int) -> EventLoopFuture<(String, String)?> {
        return self.send(command: "BLPOP", args: keys + [String(timeout)])
    }
    
    public func brpop(keys: [String], timeout: Int) -> EventLoopFuture<(String, String)?> {
        return self.send(command: "BRPOP", args: keys + [String(timeout)])
    }
    
    public func brpoplpush(source: String, destination: String, timeout: Int) -> EventLoopFuture<String?> {
        return self.send(command: "BRPOPLPUSH", args: [source, destination, String(timeout)])
    }

    public func llen(key: String) -> EventLoopFuture<Int> {
        return self.send(command: "LLEN", args: [key])
    }
    
    public func lindex(key: String, index: Int) -> EventLoopFuture<String?> {
        return self.send(command: "LINDEX", args: [key, String(index)])
    }
    
    @discardableResult
    public func linsert(key: String, before pivot: String, value: String) -> EventLoopFuture<Int> {
        return self.send(command: "LINSERT", args: [key, "BEFORE", pivot, value])
    }
    
    @discardableResult
    public func linsert(key: String, after pivot: String, value: String) -> EventLoopFuture<Int> {
        return self.send(command: "LINSERT", args: [key, "AFTER", pivot, value])
    }
    
    public func lpop(key: String) -> EventLoopFuture<String?> {
        return self.send(command: "LPOP", args: [key])
    }
    
    @discardableResult
    public func lpush(key: String, values: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "LPUSH", args: [key]+values)
    }
    
    @discardableResult
    public func lpushx(key: String, value: String) -> EventLoopFuture<Int> {
        return self.send(command: "LPUSHX", args: [key, value])
    }
    
    public func lrange(key: String, start: Int, stop: Int) -> EventLoopFuture<[String]> {
        return self.send(command: "LRANGE", args: [key, String(start), String(stop)])
    }
    
    @discardableResult
    public func lrem(key: String, count: Int, value: String) -> EventLoopFuture<Int> {
        return self.send(command: "LREM", args: [key, String(count), value])
    }
    
    @discardableResult
    public func lset(key: String, index: Int, value: String) -> EventLoopFuture<Bool> {
        return self.send(command: "LSET", args: [key, String(index), value])
    }
    
    @discardableResult
    public func ltrim(key: String, start: Int, stop: Int) -> EventLoopFuture<Bool> {
        return self.send(command: "LTRIM", args: [key, String(start), String(stop)])
    }
    
    public func rpop(key: String) -> EventLoopFuture<String?> {
        return self.send(command: "RPOP", args: [key])
    }
    
    public func rpoplpush(source: String, destination: String) -> EventLoopFuture<String?> {
        return self.send(command: "RPOPLPUSH", args: [source, destination])
    }
    
    @discardableResult
    public func rpush(key: String, values: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "RPUSH", args: [key]+values)
    }
    
    @discardableResult
    public func rpushx(key: String, value: String) -> EventLoopFuture<Int> {
        return self.send(command: "RPUSHX", args: [key, value])
    }
}
