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

    func testAddScriptKeyHash() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.addScriptKeyHash()
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83F680F6")
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
}
