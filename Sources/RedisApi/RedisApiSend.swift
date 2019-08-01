import Core

public protocol RedisApiSend {
   
    /// Method to send commands
    ///
    /// - note: The method should also handle returning the errors
    ///
    /// - parameters:
    ///   - command - The Redis commands
    ///   - args - The arguments associated with the command
    ///
    /// - returns: Redis response
    ///
    func send(command: String, args: [String]) -> EventLoopFuture<RedisApiData>
    
    /// Method to send pipeline of commands
    ///
    /// - note: The method should also handle returning the errors
    ///
    /// - parameters:
    ///   - command - The Redis commands
    ///   - args - The arguments associated with the command
    ///
    /// - returns: Redis responser fo each command
    ///
    func send(pipeline commands: [[String]]) -> EventLoopFuture<[RedisApiData]>
}

extension RedisApiSend {

    func send(command: String, args: [String]) -> EventLoopFuture<String?> {
        return self.send(command: command, args: args).map(to: String?.self) {
            (data: RedisApiData) -> String? in
            return data.redisToString
        }
    }
    
    func send(command: String, args: [String]) -> EventLoopFuture<String> {
        return self.send(command: command, args: args).map(to: String.self) {
            (data: RedisApiData) -> String in
            return data.redisToString ?? ""
        }
    }
    
    func send(command: String, args: [String]) -> EventLoopFuture<Int?> {
        return self.send(command: command, args: args).map(to: Int?.self) {
            (data: RedisApiData) -> Int? in
            return data.redisToInt
        }
    }
    
    func send(command: String, args: [String]) -> EventLoopFuture<Int> {
        return self.send(command: command, args: args).map(to: Int.self) {
            (data: RedisApiData) -> Int in
            return data.redisToInt ?? 0
        }
    }
    
    func send(command: String, args: [String]) -> EventLoopFuture<Bool> {
        return self.send(command: command, args: args).map(to: Bool.self) {
            (data: RedisApiData) -> Bool in
            return data.redisToBool
        }
    }
    
    func send(command: String, args: [String]) -> EventLoopFuture<[String]> {
        return self.send(command: command, args: args).map(to: [String].self) {
            (data: RedisApiData) -> [String] in
            return data.redisToStringArray
        }
    }
    
    func send(command: String, args: [String]) -> EventLoopFuture<[String?]> {
        return self.send(command: command, args: args).map(to: [String?].self) {
            (data: RedisApiData) -> [String?] in
            return data.redisToOptionalStringArray
        }
    }
    
    func send(command: String, args: [String]) -> EventLoopFuture<(String, String)?> {
        return self.send(command: command, args: args).map(to: (String, String)?.self) {
            (data: RedisApiData) -> (String, String)? in
            return data.redisToStringStringTuple
        }
    }
    
    func send(command: String, args: [String]) -> EventLoopFuture<[(String, String)]> {
        return self.send(command: command, args: args).map(to: [(String, String)].self) {
            (data: RedisApiData) -> [(String, String)] in
            return data.redisToStringStringTupleArray
        }
    }
    
    func send(command: String, args: [String]) -> EventLoopFuture<[String:String]> {
        return self.send(command: command, args: args).map(to: [String:String].self) {
            (data: RedisApiData) -> [String:String] in
            return data.redisToStringStringDictionary
        }
    }
    
    func send(command: String, args: [String]) -> EventLoopFuture<(Double, String)?> {
        return self.send(command: command, args: args).map(to: (Double, String)?.self) {
            (data: RedisApiData) -> (Double, String)? in
            return data.redisToDoubleStringTuple
        }
    }
    
    func send(command: String, args: [String]) -> EventLoopFuture<[(Double, String)]> {
        return self.send(command: command, args: args).map(to: [(Double, String)].self) {
            (data: RedisApiData) -> [(Double, String)] in
            return data.redisToDoubleStringTupleArray
        }
    }
}
