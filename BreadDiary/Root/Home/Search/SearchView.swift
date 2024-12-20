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
            
        }
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
