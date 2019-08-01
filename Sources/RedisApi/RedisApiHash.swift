import NIO

public protocol RedisApiHash: RedisApiSend {
    
    /// HDEL key field [field ...]
    ///
    /// Removes the specified fields from the hash stored at key
    ///
    /// [SPEC](https://redis.io/commands/hdel)
    ///
    @discardableResult
    func hdel(key: String, fields: [String]) -> EventLoopFuture<Int>
    
    /// HEXISTS key field
    ///
    /// Returns if field is an existing field in the hash stored at key
    ///
    /// [SPEC](https://redis.io/commands/hexists)
    ///
    func hexists(key: String, field: String) -> EventLoopFuture<Int>
    
    /// HGET key field
    ///
    /// Returns the value associated with field in the hash stored at key
    ///
    /// [SPEC](https://redis.io/commands/hget)
    ///
    func hget(key: String, field: String) -> EventLoopFuture<String?>
    
    /// HGETALL key
    ///
    /// Returns all fields and values of the hash stored at key
    ///
    /// [SPEC](https://redis.io/commands/hgetall)
    ///
    func hgetall(key: String) -> EventLoopFuture<[String:String]>
    
    /// HINCRBY key field increment
    ///
    /// Increments the number stored at field in the hash stored at key by increment
    ///
    /// [SPEC](https://redis.io/commands/hincrby)
    ///
    @discardableResult
    func hincrby(key: String, field: String, increment: Int) -> EventLoopFuture<Int>
    
    /// HINCRBYFLOAT key field increment
    ///
    /// Increment the specified field of a hash stored at key, and representing a
    /// floating point number, by the specified increment
    ///
    /// [SPEC](https://redis.io/commands/hincrbyfloat)
    ///
    @discardableResult
    func hincrbyfloat(key: String, field: String, increment: Double) -> EventLoopFuture<String>
    
    /// HKEYS key
    ///
    /// Returns all field names in the hash stored at key
    ///
    /// [SPEC](https://redis.io/commands/hkeys)
    ///
    func hkeys(key: String) -> EventLoopFuture<[String]>
    
    /// HLEN key
    ///
    /// Returns the number of fields contained in the hash stored at key
    ///
    /// [SPEC](https://redis.io/commands/hlen)
    ///
    func hlen(key: String) -> EventLoopFuture<Int>
    
    /// HMGET key field [field ...]
    ///
    /// Returns the values associated with the specified fields in the hash
    /// stored at key
    ///
    /// [SPEC](https://redis.io/commands/hmget)
    ///
    func hmget(key: String, fields: [String]) -> EventLoopFuture<[String?]>
    
    /// HMSET key field value [field value ...]
    ///
    /// Sets the specified fields to their respective values in the
    /// hash stored at key
    ///
    /// [SPEC](https://redis.io/commands/hmset)
    ///
    @discardableResult
    func hmset(key: String, fieldValuePairs: [(String, String)]) -> EventLoopFuture<Bool>
    
    /// TODO: HSCAN key cursor [MATCH pattern] [COUNT count]
    ///
    /// See SCAN for HSCAN documentation
    ///
    /// [SPEC](https://redis.io/commands/hscan)
    ///
    
    /// HSET key field value
    ///
    /// Sets field in the hash stored at key to value
    ///
    /// [SPEC](https://redis.io/commands/hset)
    ///
    @discardableResult
    func hset(key: String, field: String, value: String) -> EventLoopFuture<Int>
    
    /// HSETNX key field value
    ///
    /// Sets field in the hash stored at key to value, only if field
    /// does not yet exist
    ///
    /// [SPEC](https://redis.io/commands/hsetnx)
    ///
    @discardableResult
    func hsetnx(key: String, field: String, value: String) -> EventLoopFuture<Int>
    
    /// HSTRLEN key field
    ///
    /// Returns the string length of the value associated with field in
    /// the hash stored at key
    ///
    /// [SPEC](https://redis.io/commands/hstrlen)
    ///
    func hstrlen(key: String, field: String) -> EventLoopFuture<Int>
    
    /// HVALS key
    ///
    /// Returns all values in the hash stored at key
    ///
    /// [SPEC](https://redis.io/commands/hvals)
    ///
    func hvals(key: String) -> EventLoopFuture<[String]>
}

extension RedisApiHash {
    
    @discardableResult
    public func hdel(key: String, fields: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "HDEL", args: [key]+fields)
    }
    
    public func hexists(key: String, field: String) -> EventLoopFuture<Int> {
        return self.send(command: "HEXISTS", args: [key, field])
    }
    
    public func hget(key: String, field: String) -> EventLoopFuture<String?> {
        return self.send(command: "HGET", args: [key, field])
    }
    
    public func hgetall(key: String) -> EventLoopFuture<[String:String]> {
        return self.send(command: "HGETALL", args: [key])
    }
    
    @discardableResult
    public func hincrby(key: String, field: String, increment: Int) -> EventLoopFuture<Int> {
        return self.send(command: "HINCRBY", args: [key, field, String(increment)])
    }
    
    @discardableResult
    public func hincrbyfloat(key: String, field: String, increment: Double) -> EventLoopFuture<String> {
        return self.send(command: "HINCRBYFLOAT", args: [key, field, String(increment)])
    }
    
    public func hkeys(key: String) -> EventLoopFuture<[String]> {
        return self.send(command: "HKEYS", args: [key])
    }
    
    public func hlen(key: String) -> EventLoopFuture<Int> {
        return self.send(command: "HLEN", args: [key])
    }
    
    public func hmget(key: String, fields: [String]) -> EventLoopFuture<[String?]> {
        return self.send(command: "HMGET", args: [key]+fields)
    }
    
    @discardableResult
    public func hmset(key: String, fieldValuePairs: [(String, String)]) -> EventLoopFuture<Bool> {
        var args: [String] = [key]
        
        // Add the score/member pairs
        for (field, value) in fieldValuePairs {
            args.append(field)
            args.append(value)
        }
        
        return self.send(command: "HMSET", args: args)
    }
    
    @discardableResult
    public func hset(key: String, field: String, value: String) -> EventLoopFuture<Int> {
        return self.send(command: "HSET", args: [key, field, value])
    }
    
    @discardableResult
    public func hsetnx(key: String, field: String, value: String) -> EventLoopFuture<Int> {
        return self.send(command: "HSETNX", args: [key, field, value])
    }
    
    public func hstrlen(key: String, field: String) -> EventLoopFuture<Int> {
        return self.send(command: "HSTRLEN", args: [key, field])
    }
    
    public func hvals(key: String) -> EventLoopFuture<[String]> {
        return self.send(command: "HVALS", args: [key])
    }
}
