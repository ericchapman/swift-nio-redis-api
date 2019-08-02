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
    
    /// SDIFF key [key ...]
    ///
    /// Returns the members of the set resulting from the difference between
    /// the first set and all the successive sets
    ///
    /// [SPEC](https://redis.io/commands/sdiff)
    ///
    func sdiff(keys: [String]) -> EventLoopFuture<[String]>
    
    /// SDIFFSTORE destination key [key ...]
    ///
    /// This command is equal to SDIFF, but instead of returning the resulting
    /// set, it is stored in destination
    ///
    /// [SPEC](https://redis.io/commands/sdiffstore)
    ///
    @discardableResult
    func sdiffstore(destination: String, keys: [String]) -> EventLoopFuture<Int>
    
    /// SINTER key [key ...]
    ///
    /// Returns the members of the set resulting from the intersection of all
    /// the given sets
    ///
    /// [SPEC](https://redis.io/commands/sinter)
    ///
    func sinter(keys: [String]) -> EventLoopFuture<[String]>
    
    /// SINTERSTORE destination key [key ...]
    ///
    /// This command is equal to SINTER, but instead of returning the resulting
    /// set, it is stored in destination
    ///
    /// [SPEC](https://redis.io/commands/sinterstore)
    ///
    @discardableResult
    func sinterstore(destination: String, keys: [String]) -> EventLoopFuture<Int>
    
    /// SISMEMBER key member
    ///
    /// Returns if member is a member of the set stored at key
    ///
    /// [SPEC](https://redis.io/commands/sismember)
    ///
    func sismember(key: String, member: String) -> EventLoopFuture<Int>
    
    /// SMEMBERS key
    ///
    /// Returns all the members of the set value stored at key
    ///
    /// [SPEC](https://redis.io/commands/smembers)
    ///
    func smembers(key: String) -> EventLoopFuture<[String]>
    
    /// SMOVE source destination member
    ///
    /// Move member from the set at source to the set at destination
    ///
    /// [SPEC](https://redis.io/commands/smove)
    ///
    @discardableResult
    func smove(source: String, destination: String, member: String) -> EventLoopFuture<Int>
    
    /// SPOP key [count]
    ///
    /// Removes and returns one or more random elements from the set value
    /// store at key
    ///
    /// [SPEC](https://redis.io/commands/spop)
    ///
    func spop(key: String, count: Int?) -> EventLoopFuture<[String]>
    
    /// SRANDMEMBER key [count]
    ///
    /// When called with just the key argument, return a random element
    /// from the set value stored at key
    ///
    /// [SPEC](https://redis.io/commands/srandmember)
    ///
    func srandmember(key: String, count: Int?) -> EventLoopFuture<[String]>
    
    /// SREM key member [member ...]
    ///
    /// Remove the specified members from the set stored at key
    ///
    /// [SPEC](https://redis.io/commands/srem)
    ///
    @discardableResult
    func srem(key: String, members: [String]) -> EventLoopFuture<Int>
    
    /// TODO: SSCAN key cursor [MATCH pattern] [COUNT count]
    ///
    /// See SCAN for SSCAN documentation
    ///
    /// [SPEC](https://redis.io/commands/sscan)
    ///
    
    /// SUNION key [key ...]
    ///
    /// Returns the members of the set resulting from the union of all
    /// the given sets
    ///
    /// [SPEC](https://redis.io/commands/sunion)
    ///
    func sunion(keys: [String]) -> EventLoopFuture<[String]>
    
    /// SUNIONSTORE destination key [key ...]
    ///
    /// This command is equal to SUNION, but instead of returning the resulting
    /// set, it is stored in destination
    ///
    /// [SPEC](https://redis.io/commands/sunionstore)
    ///
    @discardableResult
    func sunionstore(destination: String, keys: [String]) -> EventLoopFuture<Int>
}

extension RedisApiSet {
    
    @discardableResult
    public func sadd(key: String, members: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "SADD", args: [key]+members)
    }
    
    public func scard(key: String) -> EventLoopFuture<Int> {
        return self.send(command: "SCARD", args: [key])
    }
    
    public func sdiff(keys: [String]) -> EventLoopFuture<[String]> {
        return self.send(command: "SDIFF", args: keys)
    }
    
    @discardableResult
    public func sdiffstore(destination: String, keys: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "SDIFFSTORE", args: [destination]+keys)
    }
    
    public func sinter(keys: [String]) -> EventLoopFuture<[String]> {
        return self.send(command: "SINTER", args: keys)
    }
    
    public func sinterstore(destination: String, keys: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "SINTERSTORE", args: [destination]+keys)
    }
    
    public func sismember(key: String, member: String) -> EventLoopFuture<Int> {
        return self.send(command: "SISMEMBER", args: [key, member])
    }
    
    public func smembers(key: String) -> EventLoopFuture<[String]> {
        return self.send(command: "SMEMBERS", args: [key])
    }
    
    @discardableResult
    public func smove(source: String, destination: String, member: String) -> EventLoopFuture<Int> {
        return self.send(command: "SMOVE", args: [source, destination, member])
    }
    
    public func spop(key: String, count: Int?=nil) -> EventLoopFuture<[String]> {
        var args: [String] = [key]
        
        // Add the count
        if let count = count {
            args.append(String(count))
        }
        
        return self.send(command: "SPOP", args: args)
    }
    
    public func srandmember(key: String, count: Int?=nil) -> EventLoopFuture<[String]> {
        var args: [String] = [key]
        
        // Add the count
        if let count = count {
            args.append(String(count))
        }
        
        return self.send(command: "SRANDMEMBER", args: args)
    }
    
    @discardableResult
    public func srem(key: String, members: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "SREM", args: [key]+members)
    }
    
    public func sunion(keys: [String]) -> EventLoopFuture<[String]> {
        return self.send(command: "SUNION", args: keys)
    }
    
    @discardableResult
    public func sunionstore(destination: String, keys: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "SUNIONSTORE", args: [destination]+keys)
    }
    
}
