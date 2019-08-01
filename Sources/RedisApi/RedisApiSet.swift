import NIO

public protocol RedisApiSet: RedisApiSend {

    /// SADD key member [member ...]
    ///
    /// Add the specified members to the set stored at key
    ///
    /// [SPEC](https://redis.io/commands/sadd)
    ///
    @discardableResult
    func sadd(key: String, members: [String]) -> EventLoopFuture<Int>
    
    /// SCARD key
    ///
    /// Returns the set cardinality (number of elements) of the set stored
    /// at key
    ///
    /// [SPEC](https://redis.io/commands/scard)
    ///
    func scard(key: String) -> EventLoopFuture<Int>
    
    /// SMEMBERS key
    ///
    /// Returns all the members of the set value stored at key
    ///
    /// [SPEC](https://redis.io/commands/smembers)
    ///
    func smembers(key: String) -> EventLoopFuture<[String]>
    
    /// SPOP key [count]
    ///
    /// Removes and returns one or more random elements from the set value
    /// store at key
    ///
    /// [SPEC](https://redis.io/commands/spop)
    ///
    func spop(key: String, count: Int?) -> EventLoopFuture<[String]>
    
    /// SREM key member [member ...]
    ///
    /// Remove the specified members from the set stored at key
    ///
    /// [SPEC](https://redis.io/commands/srem)
    ///
    @discardableResult
    func srem(key: String, members: [String]) -> EventLoopFuture<Int>
    
}

extension RedisApiSet {
    
    @discardableResult
    public func sadd(key: String, members: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "SADD", args: [key]+members)
    }
    
    public func scard(key: String) -> EventLoopFuture<Int> {
        return self.send(command: "SCARD", args: [key])
    }
    
    
    public func smembers(key: String) -> EventLoopFuture<[String]> {
        return self.send(command: "SMEMBERS", args: [key])
    }
    
    public func spop(key: String, count: Int?=nil) -> EventLoopFuture<[String]> {
        var args: [String] = [key]
        
        // Add the count
        if let count = count {
            args.append(String(count))
        }
        
        return self.send(command: "SPOP", args: args)
    }
    
    @discardableResult
    public func srem(key: String, members: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "SREM", args: [key]+members)
    }
    
}
