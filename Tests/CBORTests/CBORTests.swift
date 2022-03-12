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
        entity.add(utxoIn: [])
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
        entity.add(utxoOut: [])
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A10181824000F6F6")
    }
    
    func testCanAddUtxoInAndOut() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(utxoIn: [])
        entity.add(utxoOut: [])
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A200818240000181824000F6F6")
    }
    
    func testCanAddTwoUtxoOut() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.add(utxoOut: [])
        entity.add(utxoOut: [])
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A10182824000824000F6F6")
    }
}
