import ComposableArchitecture
import SwiftUI

struct BreadEntryCard: View {
    let entry: BreadEntry
    let store: StoreOf<FavoriteFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageURL = entry.imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color(uiColor: .systemGray5))
                }
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Rectangle()
                    .fill(Color(uiColor: .systemGray5))
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            HStack {
                Text(entry.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Spacer()
                
                FavoriteIconView(store: store)
            }
            
            HStack {
                Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < entry.rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

#Preview("Favorite") {
    let entry = BreadEntry(
        name: "Sourdough Bread",
        isFavorite: true,
        date: Date(),
        rating: 4
    )
    
    return BreadEntryCard(
        entry: entry,
        store: Store(
            initialState: FavoriteFeature.State(
                isFavorite: entry.isFavorite,
                breadId: entry.id
            )
        ) {
            FavoriteFeature()
        }
    )
    .padding()
    .background(Color(uiColor: .systemGray6))
}

#Preview("Not Favorite") {
    let entry = BreadEntry(
        name: "Sourdough Bread",
        isFavorite: false,
        date: Date(),
        rating: 1
    )
    
    return BreadEntryCard(
        entry: entry,
        store: Store(
            initialState: FavoriteFeature.State(
                isFavorite: entry.isFavorite,
                breadId: entry.id
            )
        ) {
            FavoriteFeature()
        }
    )
    .padding()
    .background(Color(uiColor: .systemGray6))
}
