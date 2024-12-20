import SwiftUI
import ComposableArchitecture

struct SortOptionsView: View {
    let store: StoreOf<HomeFeature>
    
    var body: some View {
        Menu {
            ForEach(HomeFeature.SortOption.allCases, id: \.self) { option in
                Button {
                    store.send(.sortOptionSelected(option))
                } label: {
                    HStack {
                        Text(option.rawValue)
                        if store.sortOption == option {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .foregroundColor(store.sortOption == .date ? .gray : .blue)
        }
    }
}

#Preview {
    SortOptionsView(
        store: Store(
            initialState: HomeFeature.State()
        ) {
            HomeFeature()
        }
    )
}
