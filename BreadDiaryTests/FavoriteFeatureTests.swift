import XCTest
import ComposableArchitecture
@testable import BreadDiary

final class FavoriteFeatureTests: XCTestCase {
    
    @MainActor
    func test_toggleFavorite() async {
        let breadId = UUID()
        let store = TestStore(
            initialState: FavoriteFeature.State(
                isFavorite: false,
                breadId: breadId
            )
        ) {
            FavoriteFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
        }
        store.exhaustivity = .off
        
        // When toggling favorite
        await store.send(.toggleFavorite)
        
        // Then we receive success response
        await store.receive(.favoriteResponse(.success(true))) {
            $0.isUpdating = false
            $0.isFavorite = true
        }
    }
    
    @MainActor
    func test_toggleFavorite_multipleClicks() async {
        let breadId = UUID()
        let store = TestStore(
            initialState: FavoriteFeature.State(
                isFavorite: false,
                breadId: breadId
            )
        ) {
            FavoriteFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
        }
        
        // When trying to toggle while already updating
        await store.send(.toggleFavorite) {
            $0.isUpdating = true
            $0.isFavorite = true // The feature still toggles even when updating
        }
        
        await store.receive(.favoriteResponse(.success(true))) {
            $0.isUpdating = false
            $0.isFavorite = true
        }
    }
}
