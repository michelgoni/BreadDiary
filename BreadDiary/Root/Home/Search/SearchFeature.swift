import ComposableArchitecture
import Foundation

@Reducer
struct SearchFeature {
    @ObservableState
    struct State: Equatable {
        var searchText: String = ""
        var entries: IdentifiedArrayOf<Entry>
        var ratingFilter: Int? = nil
        var showFavoritesOnly: Bool = false
        
        var filteredEntries: IdentifiedArrayOf<Entry> {
            var filtered = entries
            
            if !searchText.isEmpty {
                filtered = IdentifiedArrayOf(
                    uniqueElements: filtered.filter { entry in
                        entry.name.localizedCaseInsensitiveContains(searchText)
                    }
                )
            }
            
            if let minRating = ratingFilter {
                filtered = IdentifiedArrayOf(
                    uniqueElements: filtered.filter { entry in
                        entry.evaluation >= minRating
                    }
                )
            }
            
            if showFavoritesOnly {
                filtered = IdentifiedArrayOf(
                    uniqueElements: filtered.filter { entry in
                        entry.isFavorite
                    }
                )
            }
            
            return filtered
        }
    }
    
    enum Action {
        case searchTextChanged(String)
        case debouncedSearchTextChanged(String)
        case updateEntries(IdentifiedArrayOf<Entry>)
        case ratingFilterChanged(Int?)
        case toggleFavoritesFilter
    }
    
    @Dependency(\.continuousClock) var clock
    
    private enum CancelID {
        case debounce
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .searchTextChanged(text):
                state.searchText = text
                
                // Debounce the search text changes
                return .run { send in
                    try await clock.sleep(for: .milliseconds(300))
                    await send(.debouncedSearchTextChanged(text))
                }
                .cancellable(id: CancelID.debounce)
                
            case .debouncedSearchTextChanged:
                return .none
                
            case let .updateEntries(entries):
                state.entries = entries
                return .none
                
            case let .ratingFilterChanged(rating):
                state.ratingFilter = rating
                return .none
                
            case .toggleFavoritesFilter:
                state.showFavoritesOnly.toggle()
                return .none
            }
        }
    }
} 
