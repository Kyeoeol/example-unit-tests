import XCTest
import Combine
@testable import MyTestApp


class ContentViewModelTests: XCTestCase {
    
    @MainActor
    func testFetchData() {
        // Given
        let dataFetcher = MockDataFetcher()
        let viewModel = ContentViewModel(dataFetcher: dataFetcher)
        let expectation = expectation(
            description: "Data fetched and decoded successfully."
        )
        
        // When
        viewModel.fetchData()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if let data = viewModel.data {
                XCTAssertNotNil(data, "Data should not be nil")
                expectation.fulfill()
            }
            else {
                XCTFail("Failed to fetch data")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
}


// MARK: Mock
class MockDataFetcher: DataFetchable {
    
    func fetchData() -> AnyPublisher<String?, Error> {
        let data = "Hello, Playground!"
        return Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
