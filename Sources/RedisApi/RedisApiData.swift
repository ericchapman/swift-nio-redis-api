public protocol RedisApiData {
    
    /// --------------------------- Methods to Define -------------------------------
    
    var redisToArray: [RedisApiData]? { get }
    var redisToString: String? { get }
    var redisToInt: Int? { get }
    var redisToDouble: Double? { get }
    
    /// -----------------------------------------------------------------------------
    
    var redisToBool: Bool { get }
    var redisToStringArray: [String] { get }
    var redisToOptionalStringArray: [String?] { get }
    var redisToStringStringTuple: (String, String)? { get }
    var redisToStringStringTupleArray: [(String, String)] { get }
    var redisToStringStringDictionary: [String:String] { get }
    var redisToStringStringStringTuple: (String, String, String)? { get }
    var redisToDoubleStringTuple: (Double, String)? { get }
    var redisToDoubleStringTupleArray: [(Double, String)] { get }
}

extension RedisApiData {
    
    public var redisToBool: Bool {
        return self.redisToString == "OK" || (self.redisToInt ?? 0) > 0
    }
    
    public var redisToStringArray: [String] {
        return (self.redisToArray ?? []).map { $0.redisToString ?? "" }
    }
    
    public var redisToOptionalStringArray: [String?] {
        return (self.redisToArray ?? []).map { $0.redisToString }
    }
    
    public var redisToStringStringTuple: (String, String)? {
        if let values = self.redisToArray, values.count == 2 {
            return (values[0].redisToString ?? "", values[1].redisToString ?? "")
        }
        return nil
    }
    
    public var redisToStringStringTupleArray: [(String, String)] {
        var results = [(String, String)]()
        if let values = self.redisToArray, values.count % 2 == 0 {
            for i in 0..<values.count/2 {
                results.append((
                    values[2*i].redisToString ?? "",
                    values[2*i+1].redisToString ?? ""
                ))
            }
        }
        return results
    }
    
    public var redisToStringStringDictionary: [String:String] {
        var results = [String:String]()
        if let values = self.redisToArray, values.count % 2 == 0 {
            for i in 0..<values.count/2 {
                results[values[2*i].redisToString ?? ""] = values[2*i+1].redisToString ?? ""
            }
        }
        return results
    }
    
    public var redisToStringStringStringTuple: (String, String, String)? {
        if let values = self.redisToArray, values.count == 3 {
            return (values[0].redisToString ?? "", values[1].redisToString ?? "", values[2].redisToString ?? "")
        }
        return nil
    }
    
    public var redisToDoubleStringTuple: (Double, String)? {
        if let values = self.redisToArray, values.count == 2 {
            return (values[0].redisToDouble ?? 0.0, values[1].redisToString ?? "")
        }
        return nil
    }
    
    public var redisToDoubleStringTupleArray: [(Double, String)] {
        var results = [(Double, String)]()
        if let values = self.redisToArray, values.count % 2 == 0 {
            for i in 0..<values.count/2 {
                results.append((
                    values[2*i].redisToDouble ?? 0.0,
                    values[2*i+1].redisToString ?? ""
                ))
            }
        }
        return results
    }
}
