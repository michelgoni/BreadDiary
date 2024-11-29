import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    let store: StoreOf<HomeFeature>
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchView(
                    store: store.scope(
                        state: \.searchState,
                        action: \.search
                    )
                )
                
                Group {
                    switch (store.isLoading, store.searchState.filteredEntries.isEmpty) {
                    case (true, _):
                        ProgressView()
                            .scaleEffect(1.5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case (false, true):
                        if store.searchState.searchText.isEmpty {
                            Text("No bread entries yet")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            Text("No matches found")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    case (false, false):
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(store.searchState.filteredEntries) { entry in
                                    BreadEntryCard(
                                        entry: entry.toBreadEntry(),
                                        store: Store(
                                            initialState: FavoriteFeature.State(
                                                isFavorite: entry.isFavorite,
                                                breadId: entry.id
                                            )
                                        ) {
                                            FavoriteFeature()
                                        }
                                    )
                                    .onTapGesture {
                                        store.send(.showRecipeDetail(entry))
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("My Bread Diary")
            .sheet(
                store: store.scope(
                    state: \.$destination,
                    action: \.destination
                ),
                state: \.recipeDetail,
                action: { .recipeDetail($0) }
            ) { store in
                NavigationStack {
                    RecipeDetailView(store: store)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        store.send(.addNewRecipeTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview("With Entries") {
    HomeView(store: HomeFeature.previewStoreWithEntries())
}

#Preview("Loading State") {
    HomeView(store: HomeFeature.previewStore(isLoading: true))
}

#Preview("Empty State") {
    HomeView(store: HomeFeature.previewStore(isLoading: false))
}
