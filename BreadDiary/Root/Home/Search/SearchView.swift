import ComposableArchitecture
import SwiftUI

struct SearchView: View {
    let store: StoreOf<SearchFeature>
    @State private var isSearching = false
    
    var body: some View {
        VStack(spacing: 16) {
            SearchBar(
                text: .init(
                    get: { store.searchText },
                    set: { 
                        isSearching = true
                        store.send(.searchTextChanged($0))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isSearching = false
                        }
                    }
                ),
                placeholder: "Search bread recipe",
                isLoading: isSearching
            )
            
            FilterView(store: store)
        }
    }
}

private struct FilterView: View {
    let store: StoreOf<SearchFeature>
    
    var body: some View {
        VStack(spacing: 12) {
            Menu {
                Button("All Ratings") {
                    store.send(.ratingFilterChanged(nil))
                }
                ForEach(1...5, id: \.self) { rating in
                    Button {
                        store.send(.ratingFilterChanged(rating))
                    } label: {
                        HStack {
                            Text("\(rating)+ Stars")
                            if store.ratingFilter == rating {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(store.ratingFilter.map { "\($0)+ Stars" } ?? "All Ratings")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundColor(.secondary)
                        .imageScale(.small)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
            Button {
                store.send(.toggleFavoritesFilter)
            } label: {
                HStack {
                    Image(systemName: store.showFavoritesOnly ? "heart.fill" : "heart")
                        .foregroundColor(store.showFavoritesOnly ? .red : .secondary)
                    Text("Favorites Only")
                        .foregroundColor(store.showFavoritesOnly ? .primary : .secondary)
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(store.showFavoritesOnly ? Color(.systemGray6) : Color.clear)
                .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }
}

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    var isLoading: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
            
            if !text.isEmpty {
                if isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .transition(.opacity)
                } else {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .transition(.opacity)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

#Preview("SearchBar Empty") {
    SearchBar(text: .constant(""), placeholder: "Search bread recipe")
}

#Preview("SearchBar With Text") {
    SearchBar(text: .constant("Sourdough"), placeholder: "Search bread recipe")
}

#Preview("SearchBar Loading") {
    SearchBar(
        text: .constant("Sour"), 
        placeholder: "Search bread recipe",
        isLoading: true
    )
}
