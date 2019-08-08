import NIO

public protocol RedisApiGeneral: RedisApiSend {
    
    /// BGREWRITEAOF
    ///
    /// Instruct Redis to start an Append Only File rewrite process
    ///
    /// [SPEC](https://redis.io/commands/bgrewriteaof)
    ///
    @discardableResult
    func bgrewriteaof() -> EventLoopFuture<Bool>
    
    /// BGSAVE
    ///
    /// Save the DB in background
    ///
    /// [SPEC](https://redis.io/commands/bgsave)
    ///
    @discardableResult
    func bgsave() -> EventLoopFuture<Bool>
    
    /// FLUSHALL [ASYNC]
    ///
    /// Delete all the keys of all the existing databases, not just
    /// the currently selected one
    ///
    /// [SPEC](https://redis.io/commands/flushall)
    ///
    @discardableResult
    func flushall(async: Bool) -> EventLoopFuture<Bool>
    
    /// FLUSHDB [ASYNC]
    ///
    /// Delete all the keys of the currently selected DB
    ///
    /// [SPEC](https://redis.io/commands/flushdb)
    ///
    @discardableResult
    func flushdb(async: Bool) -> EventLoopFuture<Bool>

    /// INFO [section]
    ///
    /// The INFO command returns information and statistics about
    /// the server in a format that is simple to parse by computers
    /// and easy to read by humans
    ///
    /// [SPEC](https://redis.io/commands/info)
    ///
    func info(section: String?) -> EventLoopFuture<String?>
}

extension RedisApiGeneral {
    
    @discardableResult
    public func bgrewriteaof() -> EventLoopFuture<Bool> {
        return self.send(command: "BGREWRITEAOF", args: [])
    }
    
    @discardableResult
    public func bgsave() -> EventLoopFuture<Bool> {
        return self.send(command: "BGSAVE", args: [])
    }
    
    @discardableResult
    public func flushall(async: Bool=false) -> EventLoopFuture<Bool> {
        var args: [String] = []
        
        if async { args += ["ASYNC"] }
        
        return self.send(command: "flushall", args: args)
    }
    
    @discardableResult
    public func flushdb(async: Bool=false) -> EventLoopFuture<Bool> {
        var args: [String] = []
        
        if async { args += ["ASYNC"] }
        
        return self.send(command: "flushdb", args: args)
    }
  
    public func info(section: String?=nil) -> EventLoopFuture<String?> {
        return self.send(command: "INFO", args: (section != nil ? [section!] : []))
    }

}
