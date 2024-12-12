import ComposableArchitecture
import XCTest
@testable import BreadDiary

@MainActor
final class CalendarFeatureTests: XCTestCase {
    
    func test_selectDate_updatesSelectedDate() async {
        
        let store = TestStore(
            initialState: CalendarFeature.State(
            selectedDate: Date(),
            recipeDates: Set<DateComponents>(),
            recipesByDate: [:]
        )) {
            CalendarFeature()
        }
        
        let newDate = Date(timeIntervalSince1970: 1640995200)
        
        await store.send(.dateSelected(newDate)) {
            $0.selectedDate = newDate
        }
    }
    
    func test_fetchRecipes_success() async {
        let date1 = Date(timeIntervalSince1970: 1640995200) // 2022-01-01
        let date2 = Date(timeIntervalSince1970: 1641081600) // 2022-01-02
        
        let mockEntries = [
            Entry(entryDate: date1, name: "Test Recipe 1", id: UUID()),
            Entry(entryDate: date2, name: "Test Recipe 2", id: UUID())
        ]
        
        let store = TestStore(
            initialState: CalendarFeature.State(
            selectedDate: Date(),
            recipeDates: Set<DateComponents>(),
            recipesByDate: [:]
        )) {
            CalendarFeature()
        } withDependencies: {
            $0.homeClient.fetch = { mockEntries }
        }
        
        await store.send(.fetchRecipes) {
            $0.isLoading = true
        }
        
        await store.receive(\.recipesResponse) {
            $0.isLoading = false
            var expectedRecipesByDate: [Date: Entry] = [:]
            var expectedRecipeDates = Set<DateComponents>()
            let calendar = Calendar.current
            
            for entry in mockEntries {
                let date = calendar.startOfDay(for: entry.entryDate)
                expectedRecipesByDate[date] = entry
                expectedRecipeDates.insert(calendar.dateComponents([.year, .month, .day], from: date))
            }
            
            $0.recipesByDate = expectedRecipesByDate
            $0.recipeDates = expectedRecipeDates
        }
    }
    
    func test_fetchRecipes_failure() async {
        let store = TestStore(
            initialState: CalendarFeature.State(
            selectedDate: Date(),
            recipeDates: Set<DateComponents>(),
            recipesByDate: [:]
        )) {
            CalendarFeature()
        } withDependencies: {
            $0.homeClient.fetch = { throw HomeClientError.fileNotFound }
        }
        
        await store.send(.fetchRecipes) {
            $0.isLoading = true
        }
        
        await store.receive(\.recipesResponse) {
            $0.isLoading = false
        }
    }
    
    func test_selectRecipe_opensRecipeDetail() async {
        let recipe = Entry(
            entryDate: Date(),
            name: "Test Recipe",
            id: UUID()
        )
        
        let store = TestStore(
            initialState: CalendarFeature.State(
            selectedDate: Date(),
            recipeDates: Set<DateComponents>(),
            recipesByDate: [:]
        )) {
            CalendarFeature()
        }
        
        await store.send(.recipeSelected(recipe)) {
            $0.destination = .recipeDetail(
                RecipeDetailFeature.State(
                    mode: .edit,
                    entry: recipe
                )
            )
        }
    }

}
