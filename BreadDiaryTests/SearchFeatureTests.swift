import XCTest
import ComposableArchitecture
@testable import BreadDiary

final class SearchFeatureTests: XCTestCase {
    
    @MainActor
    func test_searchTextChanged() async {
        // Given
        let clock = TestClock()
        
        let store = TestStore(
            initialState: SearchFeature.State(entries: IdentifiedArrayOf())
        ) {
            SearchFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        // When & Then
        await store.send(.searchTextChanged("Sour")) {
            $0.searchText = "Sour"
        }
        
        await clock.advance(by: .milliseconds(300))
        
        await store.receive(\.debouncedSearchTextChanged)
    }
    
    @MainActor
    func test_filterByRating() async {
        // Given
        let entries = IdentifiedArrayOf(uniqueElements: [
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
            ),
            Entry(
                entryDate: Date(),
                isFavorite: true,
                rating: 3,
                name: "Test Bread 3",
                id: UUID(),
                evaluation: 3
            )
        ])
        
        let store = TestStore(
            initialState: SearchFeature.State(entries: entries)
        ) {
            SearchFeature()
        }
        
        // When & Then
        await store.send(.ratingFilterChanged(4)) {
            $0.ratingFilter = 4
        }
        
        XCTAssertEqual(
            store.state.filteredEntries.count,
            2,
            "Should only show entries with rating >= 4"
        )
    }
    
    @MainActor
    func test_filterByFavorites() async {
        // Given
        let entries = IdentifiedArrayOf(uniqueElements: [
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
        ])
        
        let store = TestStore(
            initialState: SearchFeature.State(entries: entries)
        ) {
            SearchFeature()
        }
        
        // When & Then
        await store.send(.toggleFavoritesFilter) {
            $0.showFavoritesOnly = true
        }
        
        XCTAssertEqual(
            store.state.filteredEntries.count,
            1,
            "Should only show favorite entries"
        )
    }
    
    @MainActor
    func test_combinedFilters() async {
        // Given
        let clock = TestClock()
        let entries = IdentifiedArrayOf(uniqueElements: [
            Entry(
                entryDate: Date(),
                isFavorite: true,
                rating: 4,
                name: "Basic Sourdough",
                id: UUID(),
                evaluation: 4
            ),
            Entry(
                entryDate: Date(),
                isFavorite: true,
                rating: 5,
                name: "Sourdough Supreme",
                id: UUID(),
                evaluation: 5
            ),
            Entry(
                entryDate: Date(),
                isFavorite: false,
                rating: 5,
                name: "Baguette",
                id: UUID(),
                evaluation: 5
            )
        ])
        
        let store = TestStore(
            initialState: SearchFeature.State(entries: entries)
        ) {
            SearchFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        // When & Then
        // Add search text first (since it's applied first in the feature)
        await store.send(.searchTextChanged("Sour")) {
            $0.searchText = "Sour"
        }
        
        XCTAssertEqual(
            store.state.filteredEntries.count,
            2,
            "Should show entries containing 'Sour'"
        )
        
        // Then set rating filter
        await store.send(.ratingFilterChanged(5)) {
            $0.ratingFilter = 5
        }
        
        XCTAssertEqual(
            store.state.filteredEntries.count,
            1,
            "Should show entries with 5 stars containing 'Sour'"
        )
        
        // Finally enable favorites filter
        await store.send(.toggleFavoritesFilter) {
            $0.showFavoritesOnly = true
        }
        
        XCTAssertEqual(
            store.state.filteredEntries.count,
            1,
            "Should show only favorite entries with 5 stars containing 'Sour'"
        )
        
        await clock.advance(by: .milliseconds(300))
        await store.receive(\.debouncedSearchTextChanged)
    }
    
    @MainActor
    func test_emptyState() async {
        // Given
        let clock = TestClock()
        
        let store = TestStore(
            initialState: SearchFeature.State(entries: IdentifiedArrayOf())
        ) {
            SearchFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        // When & Then
        await store.send(.searchTextChanged("Any")) {
            $0.searchText = "Any"
        }
        
        XCTAssertTrue(
            store.state.filteredEntries.isEmpty,
            "Filtered entries should be empty when there are no entries"
        )
        
        await clock.advance(by: .milliseconds(300))
        await store.receive(\.debouncedSearchTextChanged)
        
        await store.send(.ratingFilterChanged(5)) {
            $0.ratingFilter = 5
        }
        
        XCTAssertTrue(
            store.state.filteredEntries.isEmpty,
            "Filtered entries should be empty when there are no entries"
        )
    }
    
    @MainActor
    func test_searchTextClearing() async {
        // Given
        let clock = TestClock()
        let entries = IdentifiedArrayOf(uniqueElements: [
            Entry(
                entryDate: Date(),
                isFavorite: true,
                rating: 4,
                name: "Sourdough",
                id: UUID(),
                evaluation: 4
            )
        ])
        
        let store = TestStore(
            initialState: SearchFeature.State(entries: entries)
        ) {
            SearchFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        // When & Then
        await store.send(.searchTextChanged("Sour")) {
            $0.searchText = "Sour"
        }
        
        await clock.advance(by: .milliseconds(300))
        await store.receive(\.debouncedSearchTextChanged)
        
        XCTAssertEqual(
            store.state.filteredEntries.count,
            1,
            "Should show entry containing 'Sour'"
        )
        
        await store.send(.searchTextChanged("")) {
            $0.searchText = ""
        }
        
        await clock.advance(by: .milliseconds(300))
        await store.receive(\.debouncedSearchTextChanged)
        
        XCTAssertEqual(
            store.state.filteredEntries.count,
            1,
            "Should show all entries when search text is cleared"
        )
    }
    
    @MainActor
    func test_filterRemoval() async {
        // Given
        let entries = IdentifiedArrayOf(uniqueElements: [
            Entry(
                entryDate: Date(),
                isFavorite: false,
                rating: 3,
                name: "Test Bread",
                id: UUID(),
                evaluation: 3
            )
        ])
        
        let store = TestStore(
            initialState: SearchFeature.State(entries: entries)
        ) {
            SearchFeature()
        }
        
        // When & Then
        await store.send(.ratingFilterChanged(5)) {
            $0.ratingFilter = 5
        }
        
        XCTAssertTrue(
            store.state.filteredEntries.isEmpty,
            "Should show no entries when rating filter is higher than all entries"
        )
        
        await store.send(.ratingFilterChanged(nil)) {
            $0.ratingFilter = nil
        }
        
        XCTAssertEqual(
            store.state.filteredEntries.count,
            1,
            "Should show all entries when rating filter is removed"
        )
    }
    
    @MainActor
    func test_caseInsensitiveSearch() async {
        // Given
        let clock = TestClock()
        let entries = IdentifiedArrayOf(uniqueElements: [
            Entry(
                entryDate: Date(),
                isFavorite: true,
                rating: 4,
                name: "Sourdough",
                id: UUID(),
                evaluation: 4
            )
        ])
        
        let store = TestStore(
            initialState: SearchFeature.State(entries: entries)
        ) {
            SearchFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        // When & Then
        await store.send(.searchTextChanged("sour")) {
            $0.searchText = "sour"
        }
        await clock.advance(by: .milliseconds(300))
        await store.receive(\.debouncedSearchTextChanged)
        
        XCTAssertEqual(
            store.state.filteredEntries.count,
            1,
            "Should find entry with case-insensitive search"
        )
        
        await store.send(.searchTextChanged("SOUR")) {
            $0.searchText = "SOUR"
        }
        
        XCTAssertEqual(
            store.state.filteredEntries.count,
            1,
            "Should find entry with case-insensitive search"
        )
        
        await clock.advance(by: .milliseconds(300))
        await store.receive(\.debouncedSearchTextChanged)
    }
    
    @MainActor
    func test_searchDebounceCancel() async {
        // Given
        let clock = TestClock()
        
        let store = TestStore(
            initialState: SearchFeature.State(entries: IdentifiedArrayOf())
        ) {
            SearchFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        // When & Then
        await store.send(.searchTextChanged("First")) {
            $0.searchText = "First"
        }
        
        await clock.advance(by: .milliseconds(300))
        await store.receive(\.debouncedSearchTextChanged)
        
        // Send another search before debounce triggers
        await store.send(.searchTextChanged("Second")) {
            $0.searchText = "Second"
        }
        
        // Advance clock to trigger debounce
        await clock.advance(by: .milliseconds(300))
        
        // Should only receive the debounced action for "Second"
        await store.receive(\.debouncedSearchTextChanged)
    }
}
