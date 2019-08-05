# RedisApi
(STILL UNDER DEVELOPMENT.  API COULD CHANGE AND STILL NEED TO WRITE TESTS)

Library that provides Redis helper methods as a protocol for Vapor 3.0 projects so that
they can be easily integrated into other libraries.  My motivation for creating this 
was to

 - Make my projects independent of what Redis solution was being used
 - Provide the helper methods when using "MULTI"
 - Allow Redis to be stubbed if desired in testing scenarios

## Usage

The protocol provides most (always adding more) of the Redis standard commands.
Using the protocol is shown below

```swift
let redis: RedisApi = ... // Depends on integration

_ = redis.set(key: "foo", value: "bar").do { status in
    _ = redis.get(key: "foo").do { value in
        print(value) // Prints 'bar'
    }
}
```

The protocol includes support for MULTI/EXEC where the result can be retrieved either
when the call is made to the "multi" object OR when the responses are received.  An
example is shown below

```swift
redis.multi { conn in
    conn.set(key: "foo", value: "bar")
    conn.get(key: "foo").do { value in
        print(value) // Prints 'bar'
    }
}.flatten(on: container).do { (responses: [RedisApiData]) in
    let value = responses[1].redisToString
    print(value) // Prints 'bar'
}
```

## Integration

Several methods need to be implemented in order to integrate the protocol.  Examples
for different libraries are shown as follows

### RedisClient

Library is [here](https://github.com/vapor/redis)

**Package.swift**

```swift
// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyApp",
    products: [
        .library(name: "MyApp", targets: ["MyApp"]),
        ...
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        
        // ⚡️ Non-blocking, event-driven Redis client.t
        .package(url: "https://github.com/vapor/redis.git", .branch("backport-command-handler")),

        // Redis Api
        .package(url: "https://github.com/ericchapman/swift-nio-redis-api.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "MyApp", dependencies: ["RedisApi", "Redis", "Vapor"]),
        .testTarget(name: "MyAppTests", dependencies: ["MyApp"]),
    ]
)
```

**RedisWrapper.swift**

```swift
import Vapor
import Redis
import RedisApi

public class RedisWrapper: RedisApi {
    /// The redis connection for this client
    let redis: RedisClient
    
    /// The worker for this client
    let worker: Container

    /// Constructor
    ///
    init(on worker: Container, redis: RedisClient) {
        self.worker = worker
        self.redis = redis
    }
}

///------------------------------------- Wrap Redis Client --------------------------------

/// Implement 'RedisApiData' protocol
///
extension RedisData: RedisApiData {
    public var redisToArray: [RedisApiData]? { return self.array }
    public var redisToString: String? { return self.string }
    public var redisToInt: Int? { return self.int }
    public var redisToDouble: Double? {
        if let string = self.string {
            return Double(string)
        }
        return nil
    }
}

/// Implement 'RedisApi' protocol
///
extension RedisWrapper: RedisApi {
    public var eventLoop: EventLoop {
        return self.worker.eventLoop
    }
    
    public func send(command: String, args: [String]) -> Future<RedisApiData> {
        let data = ([command] + args).map { RedisData(bulk: $0) }
        return self.redis.send(RedisData.array(data)).map(to: RedisApiData.self, {
            (data: RedisData) -> RedisApiData in
            return data as RedisApiData
        })
    }
    
    public func send(pipeline commands: [[String]]) -> Future<[RedisApiData]> {
        let promise = self.eventLoop.newPromise([RedisApiData].self)
        
        // Dispatch the requests
        var futures = [Future<RedisData>]()
        for command in commands {
            let data = command.map { RedisData(bulk: $0) }
            futures.append(self.redis.send(RedisData.array(data)))
        }
        
        // Flatten them and return the array of responses
        _ = futures.flatten(on: self.worker).do { (response: [RedisData]) in
            promise.succeed(result: response)
        }
        
        return promise.futureResult
    }
}
```
