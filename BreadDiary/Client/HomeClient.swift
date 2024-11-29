import ComposableArchitecture
import Foundation

enum HomeClientError: LocalizedError {
    case fileNotFound
    case encodingFailed
    case decodingFailed
    case saveFailed
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Bread entries file not found"
        case .encodingFailed:
            return "Failed to encode bread entries"
        case .decodingFailed:
            return "Failed to decode bread entries"
        case .saveFailed:
            return "Failed to save bread entries"
        }
    }
}

struct HomeClient {
    var fetch: () async throws -> [Entry]
    var save: ([Entry]) async throws -> Void
}

extension HomeClient: DependencyKey {
    static let liveValue = HomeClient(
        fetch: {
            let fileURL = FileManager.breadEntriesFileURL()
            
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                let initialEntries = [
                    Entry(
                        entryDate: Date(),
                        isFavorite: true,
                        rating: 4,
                        name: "Sourdough Bread",
                        id: UUID(),
                        evaluation: 4
                    ),
                    Entry(
                        entryDate: Date().addingTimeInterval(-86400),
                        isFavorite: false,
                        rating: 5,
                        name: "Baguette",
                        id: UUID(),
                        evaluation: 5
                    ),
                    Entry(
                        entryDate: Date().addingTimeInterval(-172800),
                        isFavorite: true,
                        rating: 3,
                        name: "Ciabatta",
                        id: UUID(),
                        evaluation: 3
                    ),
                    Entry(
                        entryDate: Date().addingTimeInterval(-259200),
                        isFavorite: false,
                        rating: 4,
                        name: "Rye Bread",
                        id: UUID(),
                        evaluation: 4
                    )
                ]
                
                do {
                    let data = try JSONEncoder().encode(initialEntries)
                    try data.write(to: fileURL)
                    return initialEntries
                } catch let encodingError as EncodingError {
                    throw HomeClientError.encodingFailed
                } catch {
                    throw HomeClientError.saveFailed
                }
            }
            
            do {
                let data = try Data(contentsOf: fileURL)
                let entries = try JSONDecoder().decode([Entry].self, from: data)
                return entries
            } catch let decodingError as DecodingError {
                throw HomeClientError.decodingFailed
            } catch {
                throw HomeClientError.fileNotFound
            }
        },
        save: { entries in
            do {
                let data = try JSONEncoder().encode(entries)
                try data.write(to: FileManager.breadEntriesFileURL())
            } catch let encodingError as EncodingError {
                throw HomeClientError.encodingFailed
            } catch {
                throw HomeClientError.saveFailed
            }
        }
    )
    
    static let mockValue = HomeClient(
        fetch: {
            return [
                Entry(
                    entryDate: Date(),
                    isFavorite: true,
                    rating: 4,
                    name: "Sourdough Bread",
                    id: UUID(),
                    evaluation: 4
                ),
                Entry(
                    entryDate: Date().addingTimeInterval(-86400),
                    isFavorite: false,
                    rating: 5,
                    name: "Baguette",
                    id: UUID(),
                    evaluation: 5
                ),
                Entry(
                    entryDate: Date().addingTimeInterval(-172800),
                    isFavorite: true,
                    rating: 3,
                    name: "Ciabatta",
                    id: UUID(),
                    evaluation: 3
                )
            ]
        },
        save: { _ in }
    )
    
    static let testValue = HomeClient(
        fetch: {
            return [
                Entry(
                    entryDate: Date(),
                    isFavorite: false,
                    rating: 4,
                    name: "Test Bread 1",
                    id: UUID(),
                    evaluation: 4
                ),
                Entry(
                    entryDate: Date(),
                    isFavorite: false,
                    rating: 5,
                    name: "Test Bread 2",
                    id: UUID(),
                    evaluation: 5
                )
            ]
        },
        save: { _ in }
    )
}

extension DependencyValues {
    var homeClient: HomeClient {
        get { self[HomeClient.self] }
        set { self[HomeClient.self] = newValue }
    }
}
