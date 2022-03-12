public struct CBOREncoder {
    
    public init() {}
    
    public func encode(_ entity: Transaction) -> String {
        var result = "83"
        result += startingPoint(from: entity)
        result += transactionsFirstPartBuilder(from: entity)
        result += entity.scriptKeyHash == 0 ? "F6" : "80"
    
        return result + "F6"
    }
    
    private func transactionsFirstPartBuilder(from entity: Transaction) -> String {
        var result = ""
        switch (entity.utxoIn, entity.utxoOut) {
        case (1, 0):
            result += "008\(entity.utxoIn)" + utxo()
            result += ""
        case (0, 1):
            result += ""
            result += "018\(entity.utxoOut)" + utxo()
        case (0, 2):
            result += ""
            result += "018\(entity.utxoOut)" + utxo() + utxo()
        case (1, 1):
            result += "008\(entity.utxoIn)" + utxo()
            result += "018\(entity.utxoOut)" + utxo()
        case (_, _):
            result += "F6"
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
