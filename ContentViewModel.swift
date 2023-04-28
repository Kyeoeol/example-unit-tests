import Foundation
import Combine


protocol DataFetchable {
    func fetchData() -> AnyPublisher<String?, Error>
}

@MainActor
class ContentViewModel: ObservableObject {
    
    @Published var data: String?
    
    private var cancellable = Set<AnyCancellable>()
    private let dataFetcher: DataFetchable
    
    
    
    init(dataFetcher: DataFetchable) {
        self.dataFetcher = dataFetcher
    }
    
    
    
    func fetchData() {
        dataFetcher.fetchData()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Data fetched successfully.")
                    case .failure(let error):
                        print("Error fetching data:", error)
                    }
                },
                receiveValue: { data in
                    self.data = data
                }
            )
            .store(in: &cancellable)
    }
    
}
