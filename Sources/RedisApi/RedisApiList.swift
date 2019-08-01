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
    
    /// RPUSH key value [value ...]
    ///
    /// Insert all the specified values at the tail of the list stored at key
    ///
    /// [SPEC](https://redis.io/commands/rpush)
    ///
    @discardableResult
    func rpush(key: String, values: [String]) -> EventLoopFuture<Int>
    
    
}

extension RedisApiList {
    
    public func blpop(keys: [String], timeout: Int) -> EventLoopFuture<(String, String)?> {
        return self.send(command: "BLPOP", args: keys + [String(timeout)])
    }
    
    public func brpop(keys: [String], timeout: Int) -> EventLoopFuture<(String, String)?> {
        return self.send(command: "BRPOP", args: keys + [String(timeout)])
    }

    public func llen(key: String) -> EventLoopFuture<Int> {
        return self.send(command: "LLEN", args: [key])
    }
    
    public func lpop(key: String) -> EventLoopFuture<String?> {
        return self.send(command: "LPOP", args: [key])
    }
    
    @discardableResult
    public func lpush(key: String, values: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "LPUSH", args: [key]+values)
    }
    
    public func lrange(key: String, start: Int, stop: Int) -> EventLoopFuture<[String]> {
        return self.send(command: "LRANGE", args: [key, String(start), String(stop)])
    }
    
    @discardableResult
    public func lrem(key: String, count: Int, value: String) -> EventLoopFuture<Int> {
        return self.send(command: "LREM", args: [key, String(count), value])
    }
    
    @discardableResult
    public func ltrim(key: String, start: Int, stop: Int) -> EventLoopFuture<Bool> {
        return self.send(command: "LTRIM", args: [key, String(start), String(stop)])
    }
    
    public func rpop(key: String) -> EventLoopFuture<String?> {
        return self.send(command: "RPOP", args: [key])
    }
    
    @discardableResult
    public func rpush(key: String, values: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "RPUSH", args: [key]+values)
    }
    
}
