import XCTest
import CBOR

final class CBORTests: XCTestCase {
    
    func testCanEncode() {
        // given
        let sut = CBOREncoder()
        let entity = Transaction()

        // when
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83F6F6F6")
    }
    
    func testCanAddUtxoIn() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(utxoIn: [], ix: 0)
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A10081824000F6F6")
    }

    func testAddEmptyPublicKeyAndSignature() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(publicKey: [], signature: [])
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83F6F6F6")
    }
    
    func testCanAddUtxoOut() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(utxoOut: [], ix: 0)
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A10181824000F6F6")
    }
    
    func testCanAddUtxoInAndOut() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(utxoIn: [], ix: 0)
        entity.add(utxoOut: [], ix: 0)
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A200818240000181824000F6F6")
    }
    
    func testCanAddTwoUtxoOut() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(utxoOut: [], ix: 0)
        entity.add(utxoOut: [], ix: 0)
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A10182824000824000F6F6")
    }
    
    func testCanAddIxToUtxoIn() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(utxoIn: [], ix: 1)
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A10081824001F6F6")
    }
    
    func testCanAddIxInHexToUtxoIn() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(utxoIn: [], ix: 10)
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A1008182400AF6F6")
    }
    
    func testCanAddUtxoDataToUtxoIn() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(utxoIn: [0], ix: 0)
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A1008182410000F6F6")
    }
    
    func testCanAddMediumUtxoDataToUtxoIn() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(utxoIn: [
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
        ], ix: 0)
        
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A1008182500000000000000000000000000000000000F6F6")
    }
    
    func testCanAddLargeUtxoDataToUtxoIn() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(utxoIn: [
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
        ], ix: 0)
        
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A10081825820000000000000000000000000000000000000000000000000000000000000000000F6F6")
    }
    
    func testCanAddUtxoDataWithSimpleValueToUtxoIn() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(utxoIn: [
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0
        ], ix: 0)
        
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A100818257000000000000000000000000000000000000000000000000F6F6")
    }
    
    func testCanAddUtxoDataWithAdditionalInformationToUtxoIn() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(utxoIn: [
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
        ], ix: 0)
        
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A1008182581800000000000000000000000000000000000000000000000000F6F6")
    }
    
    func testCanAddFee() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()
        
        // when
        entity.addFee(0)
        let result = sut.encode(entity)
        
        // then
        XCTAssertEqual(result, "83A10200F6F6")
    }

    func testCanAddFeeAndUtxoIn() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()
        
        // when
        entity.add(utxoIn: [
        ], ix: 0)
        
        entity.addFee(0)
        let result = sut.encode(entity)
        
        // then
        XCTAssertEqual(result, "83A200818240000200F6F6")
    }
    
    func testCanAddFeeWithSimpleValue() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()
        
        // when
        entity.addFee(1)
        let result = sut.encode(entity)
        
        // then
        XCTAssertEqual(result, "83A10201F6F6")
    }
    
    func testCanAddFeeWithNotSimpleValue() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()
        
        // when
        entity.addFee(24)
        let result = sut.encode(entity)
        
        // then
        XCTAssertEqual(result, "83A1021818F6F6")
    }
    
    func testCanAddFeeBeloveThan255() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()
        
        // when
        entity.addFee(255)
        let result = sut.encode(entity)
        
        // then
        XCTAssertEqual(result, "83A10218FFF6F6")
    }
    
    func testCanAddFeeAboveThan256() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()
        
        // when
        entity.addFee(256)
        let result = sut.encode(entity)
        
        // then
        XCTAssertEqual(result, "83A102190100F6F6")
    }
    
    func testCanAddFeeAboveThan511() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()
        
        // when
        entity.addFee(512)
        let result = sut.encode(entity)
        
        // then
        XCTAssertEqual(result, "83A102190200F6F6")
    }
    
    func testCanAddFeeAboveThanFFFF() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()
        
        // when
        entity.addFee(0xFF_FF + 1)
        let result = sut.encode(entity)
        
        // then
        XCTAssertEqual(result, "83A1021A00010000F6F6")
    }
    
    func testCanAddFeeFFFFFF() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()
        
        // when
        entity.addFee(0xFF_FF_FF)
        let result = sut.encode(entity)
        
        // then
        XCTAssertEqual(result, "83A1021A00FFFFFFF6F6")
    }
    
    func testCanAddFeeAboveFFFFFF() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()
        
        // when
        entity.addFee(0xFF_FF_FF + 1)
        let result = sut.encode(entity)
        
        // then
        XCTAssertEqual(result, "83A1021A01000000F6F6")
    }
    
    func testFullPayload() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(utxoIn: [
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
        ], ix: 0)
        entity.add(utxoOut: [
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0], ix: 0)
        entity.add(utxoOut: [
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0], ix: 0)
        entity.addFee(1024)
        entity.add(publicKey: [], signature: [])
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A30081825820000000000000000000000000000000000000000000000000000000000000000000018282582000000000000000000000000000000000000000000000000000000000000000000082582000000000000000000000000000000000000000000000000000000000000000000002190400F6F6")
    }
    
    func testCanAddUtxoInWithIx24() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(utxoIn: [
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0
        ], ix: 24)
        
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A10081825700000000000000000000000000000000000000000000001818F6F6")
    }
    
    func testCanSignEmptyPayloadWithSingleValues() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(
            publicKey: [0],
            signature: [0]
        )

        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83F6A100818241004100F6")
    }
    
    func testCanSignEmptyPayloadWithBasicValues() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(
            publicKey: [0],
            signature: [0, 0]
        )

        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83F6A10081824100420000F6")
    }
    
    func testCanSignEmptyPayloadWithComplexValues() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(
            publicKey: [
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0
            ],
            signature: [0, 0, 0]
        )

        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83F6A10081825820000000000000000000000000000000000000000000000000000000000000000043000000F6")
    }
    
}
