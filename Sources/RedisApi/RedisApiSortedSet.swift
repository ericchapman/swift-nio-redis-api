import NIO


public protocol RedisApiSortedSet: RedisApiSend {
    
    /// BZPOPMAX key [key ...] timeout
    ///
    /// BZPOPMAX is the blocking variant of the sorted set ZPOPMAX
    /// primitive
    ///
    /// [SPEC](https://redis.io/commands/bzpopmax)
    ///
    func bzpopmax(keys: [String], timeout: Int) -> EventLoopFuture<(String, String, String)?>
    
    /// BZPOPMIN key [key ...] timeout
    ///
    /// BZPOPMIN is the blocking variant of the sorted set ZPOPMIN
    /// primitive
    ///
    /// [SPEC](https://redis.io/commands/bzpopmin)
    ///
    func bzpopmin(keys: [String], timeout: Int) -> EventLoopFuture<(String, String, String)?>
    
    /// ZADD key [NX|XX] [CH] [INCR] score member [score member ...])
    ///
    /// Adds all the specified members with the specified scores to the
    /// sorted set stored at key
    ///
    /// [SPEC](https://redis.io/commands/zadd)
    ///
    @discardableResult
    func zadd(key: String, nx: Bool, xx: Bool, ch: Bool, incr: Bool, scoreMemberPairs: [(Double, String)]) -> EventLoopFuture<Int>
    
    /// ZCARD key
    ///
    /// Returns the sorted set cardinality (number of elements) of the
    /// sorted set stored at key
    ///
    /// [SPEC](https://redis.io/commands/zcard)
    ///
    func zcard(key: String) -> EventLoopFuture<Int>
    
    /// ZCOUNT key min max
    ///
    /// Returns the number of elements in the sorted set at key with a
    /// score between min and max
    ///
    /// [SPEC](https://redis.io/commands/zcount)
    ///
    func zcount(key: String, min: RedisApiType.DoubleMin, max: RedisApiType.DoubleMax) -> EventLoopFuture<Int>
    
    /// ZINCRBY key increment member
    ///
    /// Increments the score of member in the sorted set stored at key
    /// by increment
    ///
    /// [SPEC](https://redis.io/commands/zincrby)
    ///
    @discardableResult
    func zincrby(key: String, increment: Int, member: String) -> EventLoopFuture<Double>
    
    /// ZINTERSTORE destination numkeys key [key ...] [WEIGHTS weight [weight ...]] [AGGREGATE SUM|MIN|MAX]
    ///
    /// Computes the intersection of numkeys sorted sets given by the
    /// specified keys, and stores the result in destination
    ///
    /// [SPEC](https://redis.io/commands/zinterstore)
    ///
    @discardableResult
    func zinterstore(destination: String, keys: [String], weights: [Int]?, aggregate: RedisApiType.Aggregate?) -> EventLoopFuture<Int>
    
    /// ZLEXCOUNT key min max
    ///
    /// When all the elements in a sorted set are inserted with the same score, in
    /// order to force lexicographical ordering, this command returns the number of
    /// elements in the sorted set at key with a value between min and max
    ///
    /// [SPEC](https://redis.io/commands/zlexcount)
    ///
    func zlexcount(key: String, min: RedisApiType.LexicalMin, max: RedisApiType.LexicalMax) -> EventLoopFuture<Int>
    
    /// ZPOPMAX key [count]
    ///
    /// Removes and returns up to count members with the highest scores in the
    /// sorted set stored at key
    ///
    /// [SPEC](https://redis.io/commands/zpopmax)
    ///
    func zpopmax(key: String, count: Int?) -> EventLoopFuture<[String]>
    
    /// ZPOPMIN key [count]
    ///
    /// Removes and returns up to count members with the lowest scores in the
    /// sorted set stored at key
    ///
    /// [SPEC](https://redis.io/commands/zpopmin)
    ///
    func zpopmin(key: String, count: Int?) -> EventLoopFuture<[String]>
    
    /// ZRANGE key start stop [WITHSCORES]
    ///
    /// Returns the specified range of elements in the sorted set stored at key
    ///
    /// [SPEC](https://redis.io/commands/zrange)
    ///
    func zrange(key: String, start: Int, stop: Int) -> EventLoopFuture<[String]>
    
    /// ZRANGE key start stop [WITHSCORES]
    ///
    /// Returns the specified range of elements in the sorted set stored at key
    ///
    /// [SPEC](https://redis.io/commands/zrange)
    ///
    /// - note: WITHSCORES version of the command
    ///
    func zrange(key: String, start: Int, stop: Int) -> EventLoopFuture<[(String, Double)]>
    
    /// ZRANGEBYLEX key min max [LIMIT offset count]
    ///
    /// When all the elements in a sorted set are inserted with the same score,
    /// in order to force lexicographical ordering, this command returns all
    /// the elements in the sorted set at key with a value between min and max
    ///
    /// [SPEC](https://redis.io/commands/zrangelex)
    ///
    func zrangebylex(key: String, min: RedisApiType.LexicalMin, max: RedisApiType.LexicalMax, limit: (Int, Int)?) -> EventLoopFuture<[String]>
    
    /// ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT offset count]
    ///
    /// Returns all the elements in the sorted set at key with a score between
    /// min and max (including elements with score equal to min or max). The
    /// elements are considered to be ordered from low to high scores
    ///
    /// [SPEC](https://redis.io/commands/zrangebyscore)
    ///
    func zrangebyscore(key: String, min: RedisApiType.DoubleMin, max: RedisApiType.DoubleMax, limit: (Int, Int)?) -> EventLoopFuture<[String]>
    
    /// ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT offset count]
    ///
    /// Returns all the elements in the sorted set at key with a score between
    /// min and max (including elements with score equal to min or max). The
    /// elements are considered to be ordered from low to high scores
    ///
    /// [SPEC](https://redis.io/commands/zrangebyscore)
    ///
    /// - note: WITHSCORES version of the command
    ///
    func zrangebyscore(key: String, min: RedisApiType.DoubleMin, max: RedisApiType.DoubleMax, limit: (Int, Int)?) -> EventLoopFuture<[(String, Double)]>
    
    /// ZRANK key member
    ///
    /// Returns the rank of member in the sorted set stored at key, with the
    /// scores ordered from low to high
    ///
    /// [SPEC](https://redis.io/commands/zrank)
    ///
    func zrank(key: String, member: String) -> EventLoopFuture<Int>
    
    /// ZREM key member [member ...]
    ///
    /// Removes the specified members from the sorted set stored at key
    ///
    /// [SPEC](https://redis.io/commands/zrem)
    ///
    @discardableResult
    func zrem(key: String, members: [String]) -> EventLoopFuture<Int>
    
    /// ZREMRANGEBYLEX key min max
    ///
    /// When all the elements in a sorted set are inserted with the same score,
    /// in order to force lexicographical ordering, this command removes all
    /// elements in the sorted set stored at key between the lexicographical
    /// range specified by min and max
    ///
    /// [SPEC](https://redis.io/commands/zremrangebylex)
    ///
    @discardableResult
    func zremrangebylex(key: String, min: RedisApiType.LexicalMin, max: RedisApiType.LexicalMax) -> EventLoopFuture<Int>
    
    /// ZREMRANGEBYRANK key start stop
    ///
    /// Removes all elements in the sorted set stored at key with rank between
    /// start and stop
    ///
    /// [SPEC](https://redis.io/commands/zremrangebyrank)
    ///
    @discardableResult
    func zremrangebyrank(key: String, start: Int, stop: Int) -> EventLoopFuture<Int>
    
    /// ZREMRANGEBYSCORE key min max
    ///
    /// Removes all elements in the sorted set stored at key with a score
    /// between min and max (inclusive)
    ///
    /// [SPEC](https://redis.io/commands/zremrangebyscore)
    ///
    @discardableResult
    func zremrangebyscore(key: String, min: RedisApiType.DoubleMin, max: RedisApiType.DoubleMax) -> EventLoopFuture<Int>
    
    /// ZREVRANGE key start stop [WITHSCORES]
    ///
    /// Returns the specified range of elements in the sorted set stored at key
    ///
    /// [SPEC](https://redis.io/commands/zrevrange)
    ///
    func zrevrange(key: String, start: Int, stop: Int) -> EventLoopFuture<[String]>
    
    /// ZREVRANGE key start stop [WITHSCORES]
    ///
    /// Returns the specified range of elements in the sorted set stored at key
    ///
    /// [SPEC](https://redis.io/commands/zrevrange)
    ///
    /// - note: WITHSCORES version of the command
    ///
    func zrevrange(key: String, start: Int, stop: Int) -> EventLoopFuture<[(String, Double)]>
    
    /// ZREVRANGEBYLEX key max min [LIMIT offset count]
    ///
    /// When all the elements in a sorted set are inserted with the same score,
    /// in order to force lexicographical ordering, this command returns all the
    /// elements in the sorted set at key with a value between max and min
    ///
    /// [SPEC](https://redis.io/commands/zrevrangebylex)
    ///
    func zrevrangebylex(key: String, max: RedisApiType.DoubleMax, min: RedisApiType.DoubleMin, limit: (Int, Int)?) -> EventLoopFuture<[String]>
    
    /// ZREVRANGEBYSCORE key max min [WITHSCORES] [LIMIT offset count]
    ///
    /// Returns all the elements in the sorted set at key with a score between
    /// max and min (including elements with score equal to max or min)
    ///
    /// [SPEC](https://redis.io/commands/zrevrangebyscore)
    ///
    func zrevrangebyscore(key: String, max: RedisApiType.DoubleMax, min: RedisApiType.DoubleMin, limit: (Int, Int)?) -> EventLoopFuture<[String]>
    
    /// ZREVRANGEBYSCORE key max min [WITHSCORES] [LIMIT offset count]
    ///
    /// Returns all the elements in the sorted set at key with a score between
    /// max and min (including elements with score equal to max or min)
    ///
    /// [SPEC](https://redis.io/commands/zrevrangebyscore)
    ///
    /// - note: WITHSCORES version of the command
    ///
    func zrevrangebyscore(key: String, max: RedisApiType.DoubleMax, min: RedisApiType.DoubleMin, limit: (Int, Int)?) -> EventLoopFuture<[(String, Double)]>
    
    /// ZREVRANK key member
    ///
    /// Returns the rank of member in the sorted set stored at key, with the
    /// scores ordered from high to low
    ///
    /// [SPEC](https://redis.io/commands/zrevrank)
    ///
    func zrevrank(key: String, member: String) -> EventLoopFuture<Int>
    
    /// TODO: ZSCAN key cursor [MATCH pattern] [COUNT count]
    ///
    /// See SCAN for ZSCAN documentation
    ///
    /// [SPEC](https://redis.io/commands/zscan)
    ///
    
    /// ZSCORE key member
    ///
    /// Returns the score of member in the sorted set at key
    ///
    /// [SPEC](https://redis.io/commands/zscore)
    ///
    func zscore(key: String, member: String) -> EventLoopFuture<Double?>
    
    /// ZUNIONSTORE destination numkeys key [key ...] [WEIGHTS weight [weight ...]] [AGGREGATE SUM|MIN|MAX]
    ///
    /// Computes the union of numkeys sorted sets given by the specified keys,
    /// and stores the result in destination
    ///
    /// [SPEC](https://redis.io/commands/zunionstore)
    ///
    func zunionstore(destination: String, keys: [String], weights: [Int]?, aggregate: RedisApiType.Aggregate?) -> EventLoopFuture<Int>
}

extension RedisApiSortedSet {
    
    public func bzpopmax(keys: [String], timeout: Int) -> EventLoopFuture<(String, String, String)?> {
        return self.send(command: "BZPOPMAX", args: keys+[String(timeout)])
    }
    
    public func bzpopmin(keys: [String], timeout: Int) -> EventLoopFuture<(String, String, String)?> {
        return self.send(command: "BZPOPMIN", args: keys+[String(timeout)])
    }
    
    @discardableResult
    public func zadd(key: String, nx: Bool=false, xx: Bool=false, ch: Bool=false, incr: Bool=false, scoreMemberPairs: [(Double, String)]) -> EventLoopFuture<Int> {
        var args: [String] = [key]
        
        if nx { args.append("NX") }
        if xx { args.append("XX") }
        if ch { args.append("CH") }
        if incr { args.append("INCR") }
        for (score, member) in scoreMemberPairs { args += [String(score), member] }
        
        return self.send(command: "ZADD", args: args)
    }
    
    public func zcard(key: String) -> EventLoopFuture<Int> {
        return self.send(command: "ZCARD", args: [key])
    }
    
    public func zcount(key: String, min: RedisApiType.DoubleMin, max: RedisApiType.DoubleMax) -> EventLoopFuture<Int> {
        return self.send(command: "ZCOUNT", args: [key, min.string, max.string])
    }
    
    @discardableResult
    public func zincrby(key: String, increment: Int, member: String) -> EventLoopFuture<Double> {
        return self.send(command: "ZINCRBY", args: [key, String(increment), member])
    }
    
    @discardableResult
    public func zinterstore(destination: String, keys: [String], weights: [Int]?=nil, aggregate: RedisApiType.Aggregate?=nil) -> EventLoopFuture<Int> {
        var args: [String] = [destination, String(keys.count)]+keys
        
        if let weights = weights { args += ["WEIGHTS"] + weights.map { String($0) } }
        if let aggregate = aggregate { args += ["AGGREGATE", aggregate.string] }
        
        return self.send(command: "ZINTERSTORE", args: args)
    }
    
    public func zlexcount(key: String, min: RedisApiType.LexicalMin, max: RedisApiType.LexicalMax) -> EventLoopFuture<Int> {
        return self.send(command: "ZLEXCOUNT", args: [key, min.string, max.string])
    }
    
    public func zpopmax(key: String, count: Int?=nil) -> EventLoopFuture<[String]> {
        return self.send(command: "ZPOPMAX", args: [key, String(count ?? 1)])
    }
    
    public func zpopmin(key: String, count: Int?=nil) -> EventLoopFuture<[String]> {
        return self.send(command: "ZPOPMIN", args: [key, String(count ?? 1)])
    }
    
    public func zrange(key: String, start: Int, stop: Int) -> EventLoopFuture<[String]> {
        return self.send(command: "ZRANGE", args: [key, String(start), String(stop)])
    }
    
    public func zrange(key: String, start: Int, stop: Int) -> EventLoopFuture<[(String, Double)]> {
        return self.send(command: "ZRANGE", args: [key, String(start), String(stop), "WITHSCORES"])
    }
    
    public func zrangebylex(key: String, min: RedisApiType.LexicalMin, max: RedisApiType.LexicalMax, limit: (Int, Int)?) -> EventLoopFuture<[String]> {
        var args: [String] = [key, min.string, max.string]
        
        if let limit = limit { args += ["LIMIT", String(limit.0), String(limit.1)] }
        
        return self.send(command: "ZRANGEBYLEX", args: args)
    }
    
    public func zrangebyscore(key: String, min: RedisApiType.DoubleMin, max: RedisApiType.DoubleMax, limit: (Int, Int)?) -> EventLoopFuture<[String]> {
        var args: [String] = [key, min.string, max.string]
        
        if let limit = limit { args += ["LIMIT", String(limit.0), String(limit.1)] }
        
        return self.send(command: "ZRANGEBYSCORE", args: args)
    }
    
    public func zrangebyscore(key: String, min: RedisApiType.DoubleMin, max: RedisApiType.DoubleMax, limit: (Int, Int)?) -> EventLoopFuture<[(String, Double)]> {
        var args: [String] = [key, min.string, max.string, "WITHSCORES"]
        
        if let limit = limit { args += ["LIMIT", String(limit.0), String(limit.1)] }
        
        return self.send(command: "ZRANGEBYSCORE", args: args)
    }
    
    public func zrank(key: String, member: String) -> EventLoopFuture<Int> {
        return self.send(command: "ZRANK", args: [key, member])
    }
    
    @discardableResult
    public func zrem(key: String, members: [String]) -> EventLoopFuture<Int> {
        return self.send(command: "ZREM", args: [key]+members)
    }
    
    @discardableResult
    public func zremrangebylex(key: String, min: RedisApiType.LexicalMin, max: RedisApiType.LexicalMax) -> EventLoopFuture<Int> {
        return self.send(command: "ZREMRANGEBYLEX", args: [key, min.string, max.string])
    }
    
    @discardableResult
    public func zremrangebyrank(key: String, start: Int, stop: Int) -> EventLoopFuture<Int> {
        return self.send(command: "ZREMRANGEBYRANK", args: [key, String(start), String(stop)])
    }
    
    @discardableResult
    public func zremrangebyscore(key: String, min: RedisApiType.DoubleMin, max: RedisApiType.DoubleMax) -> EventLoopFuture<Int> {
        return self.send(command: "ZREMRANGEBYSCORE", args: [key, min.string, max.string])
    }
    
    public func zrevrange(key: String, start: Int, stop: Int) -> EventLoopFuture<[String]> {
        return self.send(command: "ZREVRANGE", args: [key, String(start), String(stop)])
    }
    
    public func zrevrange(key: String, start: Int, stop: Int) -> EventLoopFuture<[(String, Double)]> {
        return self.send(command: "ZREVRANGE", args: [key, String(start), String(stop), "WITHSCORES"])
    }
    
    public func zrevrangebylex(key: String, max: RedisApiType.DoubleMax, min: RedisApiType.DoubleMin, limit: (Int, Int)?) -> EventLoopFuture<[String]> {
        var args: [String] = [key, max.string, min.string]
        
        if let limit = limit { args += ["LIMIT", String(limit.0), String(limit.1)] }
        
        return self.send(command: "ZREVRANGEBYLEX", args: args)
    }
    
    public func zrevrangebyscore(key: String, max: RedisApiType.DoubleMax, min: RedisApiType.DoubleMin, limit: (Int, Int)?) -> EventLoopFuture<[String]> {
        var args: [String] = [key, max.string, min.string]
        
        if let limit = limit { args += ["LIMIT", String(limit.0), String(limit.1)] }
        
        return self.send(command: "ZREVRANGEBYSCORE", args: args)
    }
    
    public func zrevrangebyscore(key: String, max: RedisApiType.DoubleMax, min: RedisApiType.DoubleMin, limit: (Int, Int)?) -> EventLoopFuture<[(String, Double)]> {
        var args: [String] = [key, max.string, min.string, "WITHSCORES"]
        
        if let limit = limit { args += ["LIMIT", String(limit.0), String(limit.1)] }
        
        return self.send(command: "ZREVRANGEBYSCORE", args: args)
    }
    
    public func zrevrank(key: String, member: String) -> EventLoopFuture<Int> {
        return self.send(command: "ZREVRANK", args: [key, member])
    }
    
    public func zscore(key: String, member: String) -> EventLoopFuture<Double?> {
        return self.send(command: "ZSCORE", args: [key, member])
    }
    
    public func zunionstore(destination: String, keys: [String], weights: [Int]?, aggregate: RedisApiType.Aggregate?) -> EventLoopFuture<Int> {
        var args: [String] = [destination, String(keys.count)]+keys
        
        if let weights = weights { args += ["WEIGHTS"] + weights.map { String($0) } }
        if let aggregate = aggregate { args += ["AGGREGATE", aggregate.string] }
        
        return self.send(command: "ZUNIONSTORE", args: args)
    }
}
