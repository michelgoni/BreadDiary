//
//  RecipeDetailTests.swift
//  BreadDiary
//
//  Created by Michel Goñi on 9/12/24.
//

import XCTest
import ComposableArchitecture
@testable import BreadDiary

final class RecipeDetailTests: XCTestCase {
    @MainActor
    func test_addingIngredients() async {
        let store = TestStore(
            initialState: RecipeDetailFeature.State(
                mode: .create,
                entry: Entry(
                    entryDate: Date(),
                    isFavorite: false,
                    rating: 0,
                    name: "Test Recipe",
                    id: UUID(),
                    evaluation: 0
                )
            )
        ) {
            RecipeDetailFeature()
        }
        store.exhaustivity = .off
        
        await store.send(.setIngredients("Flour\nWater\nSalt"))

        XCTAssertEqual(store.state.entry.ingredients.count, 3) // Check if 3 ingredients were added
        XCTAssertEqual(store.state.entry.ingredients[0].ingredient, "Flour")
        XCTAssertEqual(store.state.entry.ingredients[1].ingredient, "Water")
        XCTAssertEqual(store.state.entry.ingredients[2].ingredient, "Salt")
    }
}
