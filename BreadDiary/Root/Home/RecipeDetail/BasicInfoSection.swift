//
//  BasicInfoSection.swift
//  MyBreadTCADiary
//
//  Created by Michel Goñi on 21/11/24.
//

import ComposableArchitecture
import SwiftUI

struct BasicInfoSectionView: View {
    let store: StoreOf<RecipeDetailFeature>
    
    var body: some View {
        Section("Basic Info") {
            TextField(
                "Bread Name",
                text: .init(
                    get: { store.entry.name },
                    set: { store.send(.nameChanged($0)) }
                )
            )
            
            DatePicker(
                "Date",
                selection: .init(
                    get: { store.entry.entryDate },
                    set: { store.send(.dateChanged($0)) }
                ),
                displayedComponents: [.date]
            )
            // Ingredients list will go here
        }
    }
}


#Preview {
    BasicInfoSectionView(store: Store(initialState: RecipeDetailFeature.State(mode: .edit,
                                                                              entry: Entry(id: UUID())), reducer: { 
        RecipeDetailFeature()
    }))
}
