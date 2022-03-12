import XCTest
import CBOR

final class CBORTests: XCTestCase {
    
    func testCanInitialise() {
        // given
        let sut = CBOREncoder()
        let entity = Transaction()

        // when
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "80")
    }
    
    func testUtxoIn() {
        // given
        let sut = CBOREncoder()
        var entity = Transaction()
        entity.addUtxoIn()

        // when
        let result = sut.encode(entity)

        // then
        XCTAssertEqual(result, "81A0")
    }
}
