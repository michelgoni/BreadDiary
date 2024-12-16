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
    func test_photoSelection() async {
        let store = TestStore(
            initialState: RecipeDetailFeature.State(
                mode: .create,
                entry: Entry(
                    entryDate: Date(),
                    name: "Test Recipe",
                    id: UUID()
                )
            )
        ) {
            RecipeDetailFeature()
        }
        
        await store.send(.photoButtonTapped) {
            $0.destination = .photoPicker(PhotoPickerFeature.State())
        }
        
        let testImageData = Data([0, 1, 2, 3, 4])
        await store.send(.destination(.presented(.photoPicker(.delegate(.photoSelected(testImageData)))))) {
            $0.entry.image = testImageData
            $0.destination = nil
        }
    }
    
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

        XCTAssertEqual(store.state.entry.ingredients.count, 3)
        XCTAssertEqual(store.state.entry.ingredients[0].ingredient, "Flour")
        XCTAssertEqual(store.state.entry.ingredients[1].ingredient, "Water")
        XCTAssertEqual(store.state.entry.ingredients[2].ingredient, "Salt")
    }
}
