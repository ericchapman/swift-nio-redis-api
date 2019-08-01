import NIO

public protocol RedisApiGeneral: RedisApiSend {
  
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
 
    public func info(section: String?=nil) -> EventLoopFuture<String?> {
        return self.send(command: "INFO", args: (section != nil ? [section!] : []))
    }

}
