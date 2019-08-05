import NIO

public class RedisApiTransaction: RedisApi {
    var commands = [[String]]()
    var promises = [EventLoopPromise<RedisApiData>]()
    
    public let eventLoop: EventLoop
    let parent: RedisApi
    
    init(on eventLoop: EventLoop, parent: RedisApi) {
        self.eventLoop = eventLoop
        self.parent = parent
    }
    
    /// Override to queue the commands
    ///
    public func send(command: String, args: [String]) -> EventLoopFuture<RedisApiData> {
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
        closure(self)
        return []
    }
    
    /// Nesting doesn't make sense.  This will allow it and just add
    /// to the commands
    ///
    public func multi(closure: (RedisApi) -> ()) -> [EventLoopFuture<RedisApiData>] {
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
            // TODO: Response payload is ["OK", "QUEUED", ..., "QUEUED", [<RESULT1>, ..., <RESULTN>]]
            // We can check to make sure everything is OK.  Currently we are just jumping to the results
            
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
        
        return self.promises.map { $0.futureResult }
    }
}
