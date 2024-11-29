import ComposableArchitecture
import SwiftUI

struct FavoriteIconView: View {
    let store: StoreOf<FavoriteFeature>
    
    var body: some View {
        Button {
            store.send(.toggleFavorite)
        } label: {
            Image(systemName: store.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(store.isFavorite ? .red : .gray)
                .opacity(store.isUpdating ? 0.5 : 1.0)
                .animation(.spring(duration: 0.2), value: store.isFavorite)
        }
        .disabled(store.isUpdating)
    }
}

#Preview("Favorite") {
    FavoriteIconView(
        store: Store(
            initialState: FavoriteFeature.State(
                isFavorite: true,
                breadId: UUID()
            )
        ) {
            FavoriteFeature()
        }
    )
}

#Preview("Not Favorite") {
    FavoriteIconView(
        store: Store(
            initialState: FavoriteFeature.State(
                isFavorite: false,
                breadId: UUID()
            )
        ) {
            FavoriteFeature()
        }
    )
} 