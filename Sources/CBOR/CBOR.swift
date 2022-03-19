import Foundation

public struct CBOREncoder {
    
    public init() {}
    
    public func encode(_ entity: Transaction) -> String {
        var result = "83"
        result += startingPoint(from: entity)
        result += buildUTXOs(from: entity)
        result += entity.scriptKeyHash == 0 ? "F6" : "80"
    
        return result + "F6"
    }
    
    private func startingPoint(from entity: Transaction) -> String {
        if entity.utxoIn.count  > 0 && entity.utxoOut.count > 0 {
            return "A2"
        } else if entity.utxoIn.count > 0 || entity.utxoOut.count > 0 {
            return "A1"
        }
        
        return ""
    }
    
    private func buildUTXOs(from entity: Transaction) -> String {
        guard  entity.utxoIn.count + entity.utxoOut.count > 0 else {
            return "F6"
        }
        var result = ""
        result += utxo(entity.utxoIn, index: 0)
        result += utxo(entity.utxoOut, index: 1)
        
        return result
    }
    
    private func utxo(_ utxo: [Utxo], index: Int) -> String {
        guard utxo.count > 0 else {
            return ""
        }
        var result = "0\(index)8\(utxo.count)"
        utxo.forEach {
            let ix = String(format:"%02X", $0.ix)
            result += "82\(abc($0.data))\(ix)"
        }
        return result
    }
    
    private func abc(_ data: [UInt8]) -> String {
        let majorType2 = 0x40
        let leadingString: String
        if isSimpleValue(data) {
            leadingString = hex(majorType2 + data.count)
        } else {
            let additionalInformation =  24
            leadingString = hex(majorType2 + additionalInformation) + hex(data.count)
        }
        let hexData = data.map { hex(Int($0)) }.joined()
        return "\(leadingString)\(hexData)"
    }
    
    private func isSimpleValue(_ data: [UInt8]) -> Bool {
        data.count <= 23
    }
    
    private func hex(_ value: Int) -> String {
        String(format:"%02X", value)
    }

}

public struct  Transaction {
    var utxoIn: [Utxo] = []
    var utxoOut: [Utxo] = []
    var scriptKeyHash: Int = 0
    
    public init() {}

    public mutating func add(utxoIn utxo: [UInt8], ix: Int) {
        utxoIn.append(Utxo(data: utxo, ix: ix))
    }
    
    public mutating func add(utxoOut utxo: [UInt8], ix: Int) {
        utxoOut.append(Utxo(data: utxo, ix: ix))
    }

    public mutating func addScriptKeyHash() {
        scriptKeyHash += 1
    }
}

struct Utxo {
    let data: [UInt8]
    let ix: Int
}
