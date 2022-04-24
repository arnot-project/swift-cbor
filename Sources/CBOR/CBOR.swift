import Foundation

public struct CBOREncoder {
    
    public init() {}
    
    public func encode(_ entity: Transaction) -> String {
        var result = "83"
        result += startingPoint(from: entity)
        result += buildUTXOs(from: entity)
        result += buildFee(from: entity)
        result += entity.scriptKeyHash == 0 ? "F6" : "80"
    
        return result + "F6"
    }
    
    private func startingPoint(from entity: Transaction) -> String {
        var count = 0
        if entity.utxoIn.count > 0 {
            count += 1
        }
        if entity.utxoOut.count > 0 {
            count += 1
        }
        if entity.fee != nil {
            count += 1
        }
        
        return count > 0 ? "A\(count)" : "F6"
    }
    
    private func buildUTXOs(from entity: Transaction) -> String {
        guard entity.utxoIn.count + entity.utxoOut.count > 0 else {
            return ""
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
            result += "82\(byteString(from: $0.data))\(unsignedInteger(from: $0.ix))"
        }
        return result
    }
    
    private func byteString(from data: [UInt8]) -> String {
        let majorType2 = 0b010_00000
        let header: String
        if isSimpleValue(data) {
            header = hex(majorType2 + data.count)
        } else {
            let additionalInformation =  24
            header = hex(majorType2 + additionalInformation) + hex(data.count)
        }
        let hexData = data.map { hex(Int($0)) }.joined()
        return "\(header)\(hexData)"
    }
    
    private func isSimpleValue(_ data: [UInt8]) -> Bool {
        data.count <= 23
    }
    
    private func buildFee(from entity: Transaction) -> String {
        guard let fee = entity.fee else {
            return ""
        }
        return "02\(unsignedInteger(from: fee))"
    }
    
    private func unsignedInteger(from value: Int) -> String {
        let majorType0 = 0b000_00000
        guard value > 23 else {
            return hex(majorType0 + value)
        }
        
        return "\(hex(majorType0 + 23 + padding(from: value)))\(hex(value))"
    }
    
    private func padding(from value: Int) -> Int {
        var buffor = 8
        var currentValue = value
        var pad = 0
        while currentValue > 0 {
            currentValue = value >> buffor
            buffor = buffor * 2
            pad += 1
        }
        return pad
    }
    
    private func hexSize(from value: Int) -> Int {
        var currentValue = value
        var buffor = 4
        var result = 1
        repeat {
            result = result * 2
            buffor = buffor * 2
            currentValue = value >> buffor
        } while currentValue > 0

        return result
    }
    
    private func hex(_ value: Int) -> String {
        let _digits = hexSize(from: value)
        return String(format:"%0\(_digits)X", value)
    }
}

public struct  Transaction {
    var utxoIn: [Utxo] = []
    var utxoOut: [Utxo] = []
    var scriptKeyHash: Int = 0
    var fee: Int?

    
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
    
    public mutating func addFee(_ fee: Int) {
        self.fee = fee
    }
}

struct Utxo {
    let data: [UInt8]
    let ix: Int
}
