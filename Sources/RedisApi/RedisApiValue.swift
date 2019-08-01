import NIO

public protocol RedisApiValue: RedisApiSend {
    
    /// DEL key [key ...]
    ///
    /// Removes the specified keys
    ///
    /// [SPEC](https://redis.io/commands/del)
    ///
    @discardableResult
    func del(keys: [String]) -> EventLoopFuture<Int>
    
    /// EXISTS key [key ...]
    ///
    /// Returns if key exists
    ///
    /// [SPEC](https://redis.io/commands/exists)
    ///
    func exists(keys: [String]) -> EventLoopFuture<Int>
    
    /// EXPIRE key seconds
    ///
    /// Set a timeout on key
    ///
    /// [SPEC](https://redis.io/commands/expire)
    ///
    @discardableResult
    func expire(key: String, seconds: Int) -> EventLoopFuture<Int>
    
    /// GET key
    ///
    /// Get the value of key
    ///
    /// [SPEC](https://redis.io/commands/get)
    ///
    func get(key: String) -> EventLoopFuture<String?>
    
    /// INCRBY key increment
    ///
    /// Increments the number stored at key by increment
    ///
    /// [SPEC](https://redis.io/commands/incrby)
    ///
    @discardableResult
    func incrby(key: String, increment: Int) -> EventLoopFuture<Int>

    /// KEYS pattern
    ///
    /// Returns all keys matching pattern
    ///
    /// [SPEC](https://redis.io/commands/keys)
    ///
    func keys(pattern: String) -> EventLoopFuture<[String]>
    
    /// RENAME key newkey
    ///
    /// Renames key to newkey
    ///
    /// [SPEC](https://redis.io/commands/rename)
    ///
    @discardableResult
    func rename(key: String, newKey: String) -> EventLoopFuture<Bool>
    
    /// SET key value [expiration EX seconds|PX milliseconds] [NX|XX]
    ///
    /// Set key to hold the string value
    ///
    /// [SPEC](https://redis.io/commands/set)
    ///
    @discardableResult
    func set(key: String, value: String, ex: Int?, px: Int?, nx: Bool, xx: Bool) -> EventLoopFuture<Bool>
    
}

extension RedisApiValue {
    
    @discardableResult
    public func del(keys: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "DEL", args: keys)
    }
    
    public func exists(keys: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "EXISTS", args: keys)
    }
    
    @discardableResult
    public func expire(key: String, seconds: Int) -> EventLoopFuture<Int> {
        return self.send(command: "EXPIRE", args: [key, String(seconds)])
    }
    
    public func get(key: String) -> EventLoopFuture<String?> {
        return self.send(command: "GET", args: [key])
    }
    
    @discardableResult
    public func incrby(key: String, increment: Int) -> EventLoopFuture<Int> {
        return self.send(command: "INCRBY", args: [key, String(increment)])
    }

    public func keys(pattern: String) -> EventLoopFuture<[String]> {
        return self.send(command: "KEYS", args: [pattern])
    }
    
    @discardableResult
    public func rename(key: String, newKey: String) -> EventLoopFuture<Bool> {
        return self.send(command: "RENAME", args: [key, newKey])
    }
    
    @discardableResult
    public func set(key: String, value: String, ex: Int?=nil, px: Int?=nil, nx: Bool=false, xx: Bool=false) -> EventLoopFuture<Bool> {
        var args: [String] = [key, value]
        
        // Add the options
        if let ex = ex { args += ["EX", String(ex)] }
        if let px = px { args += ["PX", String(px)]  }
        if nx { args.append("NX") }
        if xx { args.append("XX") }
        
        return self.send(command: "SET", args: args)
    }
}
