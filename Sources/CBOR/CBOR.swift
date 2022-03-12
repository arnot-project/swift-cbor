public struct CBOREncoder {
    
    public init() {}
    
    public func encode(_ entity: Transaction) -> String {
        var result = "83"
        switch (entity.utxoIn, entity.utxoOut) {
        case (1, 0):
            result += "A10081824000"
        case (0, 1):
            result += "A10181824000"
        case (0, 2):
            result += "A10182824000824000"
        case (0, 0):
            result += "F6"
        case (_, _):
            result += "A200818240000181824000"
        }
        result += entity.scriptKeyHash == 0 ? "F6" : "80"
    
        return result + "F6"
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
