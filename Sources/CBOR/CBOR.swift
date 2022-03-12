public struct CBOREncoder {
    
    public init() {}
    
    public func encode(_ entity: Transaction) -> String {
        var result = "83"
        result += entity.utxo == 0 ? "F6" : "A0"
        result += entity.scriptKeyHash == 0 ? "F6" : "80"
    
        return result + "F6"
    }
}

public struct  Transaction {
    var utxo: Int = 0
    var scriptKeyHash: Int = 0
    
    public init() {}

    public mutating func addUtxo() {
        utxo += 1
    }

    public mutating func addScriptKeyHash() {
        scriptKeyHash += 1
    }
}
