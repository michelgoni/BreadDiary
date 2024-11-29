//
//  RatingsSection.swift
//  MyBreadTCADiary
//
//  Created by Michel Goñi on 21/11/24.
//

import ComposableArchitecture
import SwiftUI

struct RatingsSectionView: View {
    let store: StoreOf<RecipeDetailFeature>
    
    var body: some View {
        Section("Ratings") {
            RatingRow(title: "Crust", rating: .init(
                get: { store.entry.crustRating },
                set: { store.send(.ratingChanged(field: .crust, value: $0)) }
            ))
            RatingRow(title: "Crumb", rating: .init(
                get: { store.entry.crumbRating },
                set: { store.send(.ratingChanged(field: .crumb, value: $0)) }
            ))
            RatingRow(title: "Rise", rating: .init(
                get: { store.entry.bloomRating },
                set: { store.send(.ratingChanged(field: .rise, value: $0)) }
            ))
            RatingRow(title: "Scoring", rating: .init(
                get: { store.entry.scoreRating },
                set: { store.send(.ratingChanged(field: .scoring, value: $0)) }
            ))
            RatingRow(title: "Taste", rating: .init(
                get: { store.entry.tasteRating },
                set: { store.send(.ratingChanged(field: .taste, value: $0)) }
            ))
            RatingRow(title: "Overall", rating: .init(
                get: { store.entry.evaluation },
                set: { store.send(.ratingChanged(field: .overall, value: $0)) }
            ))
        }
    }
}

struct RatingsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        RatingsSectionView(
            store: Store(
                initialState: RecipeDetailFeature.State(
                    mode: .edit,
                    entry: Entry(
                        id: UUID(),
                        crustRating: 2,
                        crumbRating: 2,
                        bloomRating: 1,
                        scoreRating: 3,
                        tasteRating: 3,
                        evaluation: 2
                    )
                ),
                reducer: {
                    RecipeDetailFeature()
                }
            )
        )
    }
}
