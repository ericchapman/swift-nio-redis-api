import NIO

public protocol RedisApi: RedisApiGeneral, RedisApiValue, RedisApiList, RedisApiSet, RedisApiSortedSet, RedisApiHash {
    
    /// Returns the event loop
    var eventLoop: EventLoop { get }
    
    /// MULTI
    ///
    /// Marks the start of a transaction block. Subsequent commands will be
    /// queued for atomic execution using EXEC.
    ///
    /// [SPEC](https://redis.io/commands/multi)
    ///
    @discardableResult
    func multi(closure: (RedisApi) -> ()) -> [EventLoopFuture<RedisApiData>]
    
    /// Pipeline Helper
    ///
    /// [SPEC](https://redis.io/topics/pipelining)
    ///
    @discardableResult
    func pipeline(closure: (RedisApi) -> ()) -> [EventLoopFuture<RedisApiData>]

}

extension RedisApi {
    
    @discardableResult
    public func multi(closure: (RedisApi) -> ()) -> [EventLoopFuture<RedisApiData>] {
        return RedisApiMulti(on: self.eventLoop, parent: self).multi(closure: closure)
    }
    
    @discardableResult
    public func pipeline(closure: (RedisApi) -> ()) -> [EventLoopFuture<RedisApiData>] {
        return RedisApiTransaction(on: self.eventLoop, parent: self).pipeline(closure: closure)
    }
    
}
