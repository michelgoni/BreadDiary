import XCTest
import ComposableArchitecture
@testable import BreadDiary

final class HomeFeatureTests: XCTestCase {
    
    @MainActor
    func test_loadingEntries_success() async {
        // Given
        let entries = [
            Entry(
                entryDate: Date(),
                isFavorite: true,
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
        
        let store = TestStore(
            initialState: HomeFeature.State()
        ) {
            HomeFeature()
        } withDependencies: {
            $0.homeClient.fetch = { entries }
        }
        
        // When & Then
        await store.send(.fetchHomeData) {
            $0.isLoading = true
        }
        
        await store.receive(\.homeDataResponse.success) {
            $0.isLoading = false
            $0.entries = IdentifiedArray(uniqueElements: entries)
        }
        
        await store.receive(\.search.updateEntries) {
            $0.searchState.entries = $0.entries
        }
    }
    
    @MainActor
    func test_loadingEntries_failure() async {
        // Given
        struct FetchError: Error {}
        
        let store = TestStore(
            initialState: HomeFeature.State()
        ) {
            HomeFeature()
        } withDependencies: {
            $0.homeClient.fetch = { throw FetchError() }
        }
        
        // When & Then
        await store.send(.fetchHomeData) {
            $0.isLoading = true
        }
        
        await store.receive(\.homeDataResponse.failure) {
            $0.isLoading = false
        }
    }
    
    @MainActor
    func test_addNewRecipe() async {
        let store = TestStore(
            initialState: HomeFeature.State(
                entries: [],
                destination: nil
            )
        ) {
            HomeFeature()
        }
        store.exhaustivity = .off
        await store.send(.addNewRecipeTapped)
        
        // Then verify only the important parts of state
        XCTAssertNotNil(store.state.destination)
        if case let .recipeDetail(detailState) = store.state.destination {
            XCTAssertEqual(detailState.mode, .create)
            // Entry should exist but we don't care about its specific UUID/Date values
            XCTAssertNotNil(detailState.entry)
        } else {
            XCTFail("Expected recipe detail destination")
        }
    }
    
    @MainActor
    func test_showRecipeDetail() async {
        // Given
        let entry = Entry(
            entryDate: Date(),
            isFavorite: true,
            rating: 4,
            name: "Test Bread",
            id: UUID(),
            evaluation: 4
        )
        
        let store = TestStore(
            initialState: HomeFeature.State(
                entries: [entry]
            )
        ) {
            HomeFeature()
        }
        
        // When & Then
        await store.send(.showRecipeDetail(entry)) {
            $0.destination = .recipeDetail(
                RecipeDetailFeature.State(
                    mode: .edit,
                    entry: entry
                )
            )
        }
    }
    
    @MainActor
    func test_dismissRecipeDetail() async {
        let entry = Entry(
            entryDate: Date(),
            isFavorite: true,
            rating: 4,
            name: "Test Bread",
            id: UUID(),
            evaluation: 4
        )
        
        let store = TestStore(
            initialState: HomeFeature.State(
                entries: [entry],
                destination: .recipeDetail(
                    RecipeDetailFeature.State(
                        mode: .edit,
                        entry: entry
                    )
                )
            )
        ) {
            HomeFeature()
        }
        
        await store.send(.destination(.dismiss)) {
            $0.destination = nil
        }
    }
    
    @MainActor
    func test_toggleFavorite() async {
        let entry = Entry(
            entryDate: Date(),
            isFavorite: false,
            rating: 4,
            name: "Test Bread",
            id: UUID(),
            evaluation: 4
        )
        
        let store = TestStore(
            initialState: HomeFeature.State(
                entries: [entry]
            )
        ) {
            HomeFeature()
        }
        store.exhaustivity = .off
        
        await store.send(.toggleFavorite(entry)) {
            $0.entries[id: entry.id]?.isFavorite = true
        }
        
        await store.receive(\.search.updateEntries)
    }
    
    @MainActor
    func test_updateRecipe() async {
        let id = UUID()
        let originalEntry = Entry(
            entryDate: Date(),
            isFavorite: false,
            rating: 4,
            name: "Original Bread",
            id: id,
            evaluation: 4
        )
        
        let updatedEntry = Entry(
            entryDate: Date(),
            isFavorite: false,
            rating: 5,
            name: "Updated Bread",
            id: id,
            evaluation: 5
        )
        
        let store = TestStore(
            initialState: HomeFeature.State(
                entries: [originalEntry]
            )
        ) {
            HomeFeature()
        }
        store.exhaustivity = .off
        
        await store.send(.updateRecipe(updatedEntry)) {
            $0.entries[id: id] = updatedEntry
        }
        
        await store.receive(\.search.updateEntries)
    }
    
    @MainActor
    func test_deleteRecipe() async {
        let entry = Entry(
            entryDate: Date(),
            isFavorite: true,
            rating: 4,
            name: "Test Bread",
            id: UUID(),
            evaluation: 4
        )
        
        let store = TestStore(
            initialState: HomeFeature.State(
                entries: [entry]
            )
        ) {
            HomeFeature()
        }
        
        await store.send(.deleteEntry(entry)) {
            $0.entries.remove(entry)
        }
        
        await store.receive(\.search.updateEntries) {
            $0.searchState.entries = []
        }
    }
}
