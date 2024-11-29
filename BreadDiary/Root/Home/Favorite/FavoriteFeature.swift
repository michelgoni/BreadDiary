import ComposableArchitecture
import Foundation

@Reducer
struct FavoriteFeature {
    @ObservableState
    struct State: Equatable {
        var isFavorite: Bool
        var isUpdating: Bool = false
        let breadId: UUID
        
        init(isFavorite: Bool, breadId: UUID) {
            self.isFavorite = isFavorite
            self.breadId = breadId
        }
    }
    
    enum Action: Equatable {
        case toggleFavorite
        case favoriteResponse(TaskResult<Bool>)
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .toggleFavorite:
                state.isUpdating = true
                let newValue = !state.isFavorite
                
                // Optimistically update UI
                state.isFavorite = newValue
                
                // Simulate API call
                return .run { [breadId = state.breadId] send in
                    try await clock.sleep(for: .milliseconds(500))
                    await send(.favoriteResponse(.success(newValue)))
                }
                
            case let .favoriteResponse(.success(isFavorite)):
                state.isUpdating = false
                state.isFavorite = isFavorite
                return .none
                
            case .favoriteResponse(.failure):
                state.isUpdating = false
                // Revert optimistic update
                state.isFavorite.toggle()
                return .none
            }
        }
    }
} 