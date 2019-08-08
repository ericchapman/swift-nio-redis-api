import NIO

public protocol RedisApiClient: RedisApiSend {
    
    /// CLIENT GETNAME
    ///
    /// The CLIENT GETNAME returns the name of the current connection
    /// as set by CLIENT SETNAME
    ///
    /// [SPEC](https://redis.io/commands/client-getname)
    ///
    func clientGetname() -> EventLoopFuture<String?>
    
    /// CLIENT ID
    ///
    /// The command just returns the ID of the current connection
    ///
    /// [SPEC](https://redis.io/commands/client-id)
    ///
    func clientId() -> EventLoopFuture<Int>
    
    /// CLIENT KILL [ip:port] [ID client-id] [TYPE normal|master|slave|pubsub] [ADDR ip:port] [SKIPME yes/no]
    ///
    /// The CLIENT KILL command closes a given client connection
    ///
    /// [SPEC](https://redis.io/commands/client-kill)
    ///
    /// - note: Legacy format (REDIS < 2.8.12)
    ///
    @discardableResult
    func clientKill(ip: String, port: Int) -> EventLoopFuture<Bool>
    
    /// CLIENT KILL [ip:port] [ID client-id] [TYPE normal|master|slave|pubsub] [ADDR ip:port] [SKIPME yes/no]
    ///
    /// The CLIENT KILL command closes a given client connection
    ///
    /// [SPEC](https://redis.io/commands/client-kill)
    ///
    /// - note: Filter/Value format (REDIS >= 2.8.12)
    ///
    @discardableResult
    func clientKill(id: String?, type: RedisApiType.ClientType?, addr: (String, Int)?, skipMe: Bool?) -> EventLoopFuture<Int>
    
    /// CLIENT LIST [TYPE normal|master|replica|pubsub]
    ///
    /// The CLIENT LIST command returns information and statistics
    /// about the client connections server in a mostly human readable
    /// format
    ///
    /// [SPEC](https://redis.io/commands/client-list)
    ///
    func clientList(type: RedisApiType.ClientType?) -> EventLoopFuture<String>
    
    /// CLIENT PAUSE timeout
    ///
    /// CLIENT PAUSE is a connections control command able to suspend
    /// all the Redis clients for the specified amount of time (in
    /// milliseconds)
    ///
    /// [SPEC](https://redis.io/commands/client-pause)
    ///
    @discardableResult
    func clientPause(_ timeout: Int) -> EventLoopFuture<Bool>
    
    /// CLIENT REPLY ON|OFF|SKIP
    ///
    /// Sometimes it can be useful for clients to completely disable
    /// replies from the Redis server
    ///
    /// [SPEC](https://redis.io/commands/client-reply)
    ///
    @discardableResult
    func clientReply(_ reply: RedisApiType.ClientReply) -> EventLoopFuture<Bool>
    
    /// CLIENT SETNAME connection-name
    ///
    /// The CLIENT SETNAME command assigns a name to the current
    /// connection
    ///
    /// [SPEC](https://redis.io/commands/client-setname)
    ///
    @discardableResult
    func clientSetname(_ name: String) -> EventLoopFuture<Bool>
    
    /// CLIENT UNBLOCK client-id [TIMEOUT|ERROR]
    ///
    /// This command can unblock, from a different connection, a client
    /// blocked in a blocking operation, such as for instance BRPOP or
    /// XREAD or WAIT
    ///
    /// [SPEC](https://redis.io/commands/client-unblock)
    ///
    /// - note: Timeout version of call
    ///
    @discardableResult
    func clientUnblock(timeout clientId: String) -> EventLoopFuture<Bool>
    
    /// CLIENT UNBLOCK client-id [TIMEOUT|ERROR]
    ///
    /// This command can unblock, from a different connection, a client
    /// blocked in a blocking operation, such as for instance BRPOP or
    /// XREAD or WAIT
    ///
    /// [SPEC](https://redis.io/commands/client-unblock)
    ///
    /// - note: Error version of call
    ///
    @discardableResult
    func clientUnblock(error clientId: String) -> EventLoopFuture<Bool>
}

extension RedisApiClient {
    
    public func clientGetname() -> EventLoopFuture<String?> {
        return self.send(command: "CLIENT", args: ["GETNAME"])
    }
    
    public func clientId() -> EventLoopFuture<Int> {
        return self.send(command: "CLIENT", args: ["ID"])
    }
    
    @discardableResult
    public func clientKill(ip: String, port: Int) -> EventLoopFuture<Bool> {
        return self.send(command: "CLIENT", args: ["KILL", "\(ip):\(port)"])
    }
    
    @discardableResult
    public func clientKill(id: String?=nil, type: RedisApiType.ClientType?=nil, addr: (String, Int)?=nil, skipMe: Bool?=nil) -> EventLoopFuture<Int> {
        var args: [String] = ["KILL"]
        
        if let id = id { args += ["ID", id] }
        if let type = type { args += ["TYPE", type.string] }
        if let addr = addr { args += ["ADDR", "\(addr.0):\(addr.1)"] }
        if let skipMe = skipMe { args += ["SKIPME", skipMe ? "yes":"no"] }
        
        return self.send(command: "CLIENT", args: args)
    }
    
    public func clientList(type: RedisApiType.ClientType?=nil) -> EventLoopFuture<String> {
        var args: [String] = ["LIST"]
        
        if let type = type { args += ["TYPE", type.string] }
        
        return self.send(command: "CLIENT", args: args)
    }
    
    @discardableResult
    public func clientPause(_ timeout: Int) -> EventLoopFuture<Bool> {
        return self.send(command: "CLIENT", args: ["PAUSE", String(timeout)])
    }
    
    @discardableResult
    public func clientReply(_ reply: RedisApiType.ClientReply) -> EventLoopFuture<Bool> {
        return self.send(command: "CLIENT", args: ["REPLY", reply.string])
    }
    
    @discardableResult
    public func clientSetname(_ name: String) -> EventLoopFuture<Bool> {
        return self.send(command: "CLIENT", args: ["SETNAME", name])
    }
    
    @discardableResult
    public func clientUnblock(timeout clientId: String) -> EventLoopFuture<Bool> {
        return self.send(command: "CLIENT", args: ["UNBLOCK", clientId, "TIMEOUT"])
    }
    
    @discardableResult
    public func clientUnblock(error clientId: String) -> EventLoopFuture<Bool> {
        return self.send(command: "CLIENT", args: ["UNBLOCK", clientId, "ERROR"])
    }
}
