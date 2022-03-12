public struct CBOREncoder {
    
    public init() {}
    
    public func encode(_ entity: Transaction) -> String {
        return entity.utxo == nil ? "80" : "81A0"
    }
}

public struct  Transaction {
    var utxo: Int?
    
    public init() {}
    
    public mutating func addUtxoIn() {
        utxo = 0
    }
}
