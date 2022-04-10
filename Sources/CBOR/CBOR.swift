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
            let ix = String(format:"%02X", $0.ix)
            result += "82\(appendingHeader(to: $0.data))\(ix)"
        }
        return result
    }
    
    private func appendingHeader(to data: [UInt8]) -> String {
        let majorType2 = 0x40
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
        return "02\(appendingHeader(to: fee))"
    }
    
    private func appendingHeader(to value: Int) -> String {
        guard value > 23 else {
            return hex(value)
        }
        
        return "\(hex(23 + numberOfAdditionalBytes(from: value)))\(hex(value))"
    }
    
    private func numberOfAdditionalBytes(from value: Int) -> Int {
        guard value > 0 else { return 1 }
        var bytes = 0
        var currentValue = value
        while currentValue > 0 {
            currentValue = currentValue >> 8
            bytes += 1
        }
        return bytes
    }
    
    private func hex(_ value: Int) -> String {
        let _digits = numberOfAdditionalBytes(from: value)
        let realDigit = digitsInPowerOfTwo(from: _digits)
        return String(format:"%0\(realDigit * 2)X", value)
    }
    
    private func digitsInPowerOfTwo(from value: Int) -> Int {
        guard value > 1 else {
            return 1
        }
        var digit = 2
        while digit < value {
            digit = digit << 1
        }
        return digit
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
