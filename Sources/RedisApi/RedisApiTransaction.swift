import NIO

/// Class that provides an abstraction for "MULTI/EXEC" commands
///
/// This class has support for "nesting" multi blocks and will behave
/// as follows
///
/// In this example, the futures are flattened to their results
///
///     //
///     // MULTI
///     // SET foo 1
///     // GET foo
///     // EXEC
///     //
///     redis.multi { multi in
///         multi.set(key: "foo", value: "1")
///         multi.get(key: "foo")
///     }.flatten(on: worker).do { results in
///         print(results) // [true, "1"]
///     }
///
/// In this example, the multi is executed and then the multi becomes
/// a normal connection
///
///     //
///     // MULTI
///     // SET foo 1
///     // GET foo
///     // EXEC
///     //
///     // INCRBY foo 2
///     //
///     redis.multi { multi in
///         multi.set(key: "foo", value: "1")
///         multi.get(key: "foo").do {
///             multi.incrby(key: "foo", increment: 2).do { result in
///                 print(result) // "3"
///             }
///         }
///     }.flatten(on: worker).do { results in
///         print(results) // [true, "1"]
///     }
///
/// In this example, a new multi is created nested inside the first multi
///
///     //
///     // MULTI
///     // SET foo 1
///     // GET foo
///     // EXEC
///     //
///     // MULTI
///     // INCRBY foo 2
///     // EXPIRE foo 20
///     // EXEC
///     //
///     redis.multi { multi in
///         multi.set(key: "foo", value: "1")
///         multi.get(key: "foo").do {
///             multi.multi { newMulti in
///                 newMulti.incrby(key: "foo", increment: 2).do { result in
///                     print(result) // "3"
///                 }
///                 newMulti.expire(key: "foo", seconds: 20)
///             }.flatten(on: worker).do { results in
///                 print(results) // ["3", "1"]
///             }
///         }
///     }.flatten(on: worker).do { results in
///         print(results) // [true, "1"]
///     }
///
///
public class RedisApiTransaction: RedisApi {
    var commands = [[String]]()
    var promises = [EventLoopPromise<RedisApiData>]()
    var executed = false
    
    public let eventLoop: EventLoop
    let parent: RedisApi
    
    init(on eventLoop: EventLoop, parent: RedisApi) {
        self.eventLoop = eventLoop
        self.parent = parent
    }
    
    /// Override to queue the commands
    ///
    public func send(command: String, args: [String]) -> EventLoopFuture<RedisApiData> {
        if self.executed {
            return self.parent.send(command: command, args: args)
        }
        
        self.commands.append([command]+args)
        
        // Create a promise and return the future
        let promise = self.eventLoop.newPromise(of: RedisApiData.self)
        promises.append(promise)
        
        // Return the future
        return promise.futureResult
    }
    
    /// Override to call the parents
    ///
    public func send(pipeline commands: [[String]]) -> EventLoopFuture<[RedisApiData]> {
        return self.parent.send(pipeline: commands)
    }
    
    /// Nesting doesn't make sense.  This will allow it and just add
    /// to the commands
    ///
    public func pipeline(closure: (RedisApi) -> ()) -> [EventLoopFuture<RedisApiData>] {
        if self.executed {
            return self.parent.pipeline(closure: closure)
        }
        
        closure(self)
        return []
    }
    
    /// Nesting doesn't make sense.  This will allow it and just add
    /// to the commands
    ///
    public func multi(closure: (RedisApi) -> ()) -> [EventLoopFuture<RedisApiData>] {
        if self.executed {
            return self.parent.multi(closure: closure)
        }
        
        closure(self)
        return []
    }
    
    /// This method executes the transaction
    ///
    public func execute() -> [EventLoopFuture<RedisApiData>] {
        // Call the pipeline method and parse the responses
        _ = self.send(pipeline: self.commands).do { (data: [RedisApiData]) in
            // Fulfill the promises
            for (index, promise) in self.promises.enumerated() {
                promise.succeed(result: data[index])
            }
            
            // Clear the old commands
            self.commands.removeAll()
            self.promises.removeAll()
        }
        
        // Set true that this executed
        self.executed = true
        
        return self.promises.map { $0.futureResult }
    }
    
}

public class RedisApiMulti: RedisApiTransaction {
    
    /// Override to execute a multi transaction
    ///
    public override func execute() -> [EventLoopFuture<RedisApiData>] {
        // Wrap request with "MULTI/EXEC" keywords
        let multiExecCommands = [["MULTI"]] + self.commands + [["EXEC"]]
        
        // Call the pipeline method and parse the responses
        _ = self.send(pipeline: multiExecCommands).do { (data: [RedisApiData]) in
            // Response payload is ["OK", "QUEUED", ..., "QUEUED", [<RESULT1>, ..., <RESULTN>]]
            // TODO: We can check to make sure everything is OK.  Currently we are just jumping to the results
            
            // The results are stored in an array at the end of the request
            let results = data[1+self.promises.count].redisToArray ?? []
            
            // Fulfill the promises
            for (index, promise) in self.promises.enumerated() {
                promise.succeed(result: results[index])
            }
            
            // Clear the old commands
            self.commands.removeAll()
            self.promises.removeAll()
        }
        
        // Set true that this executed
        self.executed = true
        
        return self.promises.map { $0.futureResult }
    }
}

