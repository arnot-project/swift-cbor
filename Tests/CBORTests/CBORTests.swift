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
    
    func testCanAddUtxo() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()

        // when
        entity.addUtxo()
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "83A0F6F6")
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
}
