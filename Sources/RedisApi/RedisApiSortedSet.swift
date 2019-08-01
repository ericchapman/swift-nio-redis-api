import NIO

public protocol RedisApiSortedSet: RedisApiSend {

    /// ZADD key [NX|XX] [CH] [INCR] score member [score member ...])
    ///
    /// Adds all the specified members with the specified scores to the
    /// sorted set stored at key
    ///
    /// [SPEC](https://redis.io/commands/zadd)
    ///
    @discardableResult
    func zadd(key: String, nx: Bool, xx: Bool, ch: Bool, incr: Bool, scoreMemberPairs: [(Double, String)]) -> EventLoopFuture<Int>
    
    /// ZCOUNT key min max
    ///
    /// Returns the number of elements in the sorted set at key with a
    /// score between min and max
    ///
    /// [SPEC](https://redis.io/commands/zcount)
    ///
    func zcount(key: String, min: String, max: String) -> EventLoopFuture<Int>
    
    /// ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT offset count]
    ///
    /// Returns all the elements in the sorted set at key with a score
    /// between min and max (including elements with score equal to min
    /// or max). The elements are considered to be ordered from low to
    /// high scores
    ///
    /// [SPEC](https://redis.io/commands/zrangebyscore)
    ///
    func zrangebyscore(key: String, min: String, max: String, limit: (Int, Int)?) -> EventLoopFuture<[String]>
    func zrangebyscore(withscores key: String, min: String, max: String, limit: (Int, Int)?) -> EventLoopFuture<[(Double, String)]>
    
    /// ZREM key member [member ...]
    ///
    /// Removes the specified members from the sorted set stored at key
    ///
    /// [SPEC](https://redis.io/commands/zrem)
    ///
    @discardableResult
    func zrem(key: String, members: [String]) -> EventLoopFuture<Int>
    
    /// ZREMRANGEBYSCORE key min max
    ///
    /// Removes all elements in the sorted set stored at key with a score
    /// between min and max (inclusive)
    ///
    /// [SPEC](https://redis.io/commands/zremrangebyscore)
    ///
    @discardableResult
    func zremrangebyscore(key: String, min: String, max: String) -> EventLoopFuture<Int>
    
}

extension RedisApiSortedSet {
    
    @discardableResult
    public func zadd(key: String, nx: Bool=false, xx: Bool=false, ch: Bool=false, incr: Bool=false, scoreMemberPairs: [(Double, String)]) -> EventLoopFuture<Int> {
        var args: [String] = [key]
        
        // Add the options
        if nx { args.append("NX") }
        if xx { args.append("XX") }
        if ch { args.append("CH") }
        if incr { args.append("INCR") }
        
        // Add the score/member pairs
        for (score, member) in scoreMemberPairs {
            args.append(String(score))
            args.append(member)
        }
        
        return self.send(command: "ZADD", args: args)
    }
    
    public func zcount(key: String, min: String, max: String) -> EventLoopFuture<Int> {
        return self.send(command: "ZCOUNT", args: [key, min, max])
    }
    
    public func zrangebyscore(key: String, min: String, max: String, limit: (Int, Int)?) -> EventLoopFuture<[String]> {
        var args: [String] = [key, min, max]
        
        // If limit, add it
        if let limit = limit {
            args.append("LIMIT")
            args.append(String(limit.0))
            args.append(String(limit.1))
        }
        
        return self.send(command: "ZRANGEBYSCORE", args: args)
    }
    
    public func zrangebyscore(withscores key: String, min: String, max: String, limit: (Int, Int)?) -> EventLoopFuture<[(Double, String)]> {
        var args: [String] = [key, min, max]
        
        // Add the "withscores" option
        args.append("WITHSCORES")
        
        // If limit, add it
        if let limit = limit {
            args.append("LIMIT")
            args.append(String(limit.0))
            args.append(String(limit.1))
        }
        
        return self.send(command: "ZRANGEBYSCORE", args: args)
    }
    
    @discardableResult
    public func zrem(key: String, members: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "ZREM", args: [key]+members)
    }
    
    @discardableResult
    public func zremrangebyscore(key: String, min: String, max: String) -> EventLoopFuture<Int> {
        return self.send(command: "ZREMRANGEBYSCORE", args: [key, min, max])
    }
}
