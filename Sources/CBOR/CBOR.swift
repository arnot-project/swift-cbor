public struct CBOREncoder {
    
    public init() {}
    
    public func encode(_ entity: Transaction) -> String {
        var result = "83"
        result += startingPoint(from: entity)
        result += buildUTXOs(from: entity)
        result += entity.scriptKeyHash == 0 ? "F6" : "80"
    
        return result + "F6"
    }
    
    private func buildUTXOs(from entity: Transaction) -> String {
        guard  entity.utxoIn + entity.utxoOut > 0 else {
            return "F6"
        }
        var result = ""
        result += utxo(ofSize: entity.utxoIn, index: 0)
        result += utxo(ofSize: entity.utxoOut, index: 1)
        
        return result
    }
    
    private func utxo(ofSize size: Int, index: Int) -> String {
        guard size > 0 else {
            return ""
        }
        var result = "0\(index)8\(size)"
        (0..<size).forEach { _ in
            result += utxo()
        }
        return result
    }
    
    private func startingPoint(from entity: Transaction) -> String {
        if entity.utxoIn > 0 && entity.utxoOut > 0 {
            return "A2"
        } else if entity.utxoIn > 0 || entity.utxoOut > 0 {
            return "A1"
        }
        
        return ""
    }
    
    private func utxo() -> String {
        "824000"
    }
}

public struct  Transaction {
    var utxoIn: Int = 0
    var utxoOut: Int = 0
    var scriptKeyHash: Int = 0
    
    public init() {}

    public mutating func add(utxoIn utxo: [UInt8]) {
        utxoIn += 1
    }
    
    public mutating func add(utxoOut utxo: [UInt8]) {
        utxoOut += 1
    }

    public mutating func addScriptKeyHash() {
        scriptKeyHash += 1
    }
}
