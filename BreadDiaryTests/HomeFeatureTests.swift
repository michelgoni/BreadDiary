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
    func test_createRecipe() async {
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
        
        XCTAssertNotNil(store.state.destination)
        if case let .recipeDetail(detailState) = store.state.destination {
            XCTAssertEqual(detailState.mode, .create)
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
        
        store.exhaustivity = .off
        
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
    
    @MainActor
    func test_createAndSaveRecipe() async {
        let testEntry = Entry(
            entryDate: Date(),
            isFavorite: false,
            rating: 5,
            name: "New Test Bread",
            id: UUID(),
            evaluation: 5
        )
        
        let store = TestStore(
            initialState: HomeFeature.State(
                entries: [],
                destination: nil
            )
        ) {
            HomeFeature()
        } withDependencies: {
            $0.homeClient.save = { _ in }
            $0.homeClient.fetch = { [testEntry] }
        }
        
        store.exhaustivity = .off

        // Trigger the creation of a new recipe
        await store.send(.addNewRecipeTapped)

        // Send save action
        await store.send(.destination(.presented(.recipeDetail(.saveNewEntry))))
        
        // Send delegate action which triggers fetch
        await store.send(.destination(.presented(.recipeDetail(.delegate(.didSave)))))
        
        // Wait for fetch to complete
        await store.send(.fetchHomeData)
        await store.receive(\.homeDataResponse) {
            $0.entries = IdentifiedArray(uniqueElements: [testEntry])
        }

        // Verify the final state
        XCTAssertEqual(store.state.entries.count, 1)
        XCTAssertEqual(store.state.entries.first?.name, "New Test Bread")
    }
    
    @MainActor
    func test_sheetDismissal_afterSaving() async {
        let entry = Entry(
            entryDate: Date(),
            name: "Test Bread",
            id: UUID()
        )
        let entries = IdentifiedArrayOf<Entry>()
        
        let store = TestStore(
            initialState: HomeFeature.State(
                destination: .recipeDetail(.init(mode: .create, entry: entry))
            )
        ) {
            HomeFeature()
        } withDependencies: {
            $0.homeClient.fetch = { Array(entries) }
        }
        
        store.exhaustivity = .off
        
        await store.send(.destination(.presented(.recipeDetail(.delegate(.didSave))))) {
            $0.destination = nil
        }
        
        await store.receive(\.fetchHomeData) {
            $0.isLoading = true
        }
    }
    
    @MainActor
    func test_sheetDismissal_onManualDismiss() async {
        let entry = Entry(
            entryDate: Date(),
            name: "Test Bread",
            id: UUID()
        )
        
        let store = TestStore(
            initialState: HomeFeature.State(
                destination: .recipeDetail(.init(mode: .create, entry: entry))
            )
        ) {
            HomeFeature()
        }
        
        await store.send(.destination(.dismiss)) {
            $0.destination = nil
        }
    }
}
