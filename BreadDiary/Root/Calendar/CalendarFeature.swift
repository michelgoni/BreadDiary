import ComposableArchitecture
import Foundation

@Reducer
struct CalendarFeature {
    @Dependency(\.homeClient) var homeClient
    
    @ObservableState
    struct State: Equatable {
        var selectedDate: Date = Date()
        var recipeDates: Set<DateComponents>
        var recipesByDate: [Date: Entry]
        var isLoading = false
        @Presents var destination: Destination.State?
        
        static func mockState() -> State {
            let calendar = Calendar.current
            let today = Date()
            
            // Create three specific dates
            let date1 = calendar.date(byAdding: .day, value: -2, to: today)!
            let date2 = calendar.date(byAdding: .day, value: -5, to: today)!
            let date3 = calendar.date(byAdding: .day, value: -7, to: today)!
            
            let dates = [date1, date2, date3]
            let dateComponents = Set(dates.map { calendar.dateComponents([.year, .month, .day], from: $0) })
            
            var recipesByDate: [Date: Entry] = [:]
            recipesByDate[date1] = Entry(entryDate: date1, name: "Sourdough Bread", id: UUID())
            recipesByDate[date2] = Entry(entryDate: date2, name: "Rye Bread", id: UUID())
            recipesByDate[date3] = Entry(entryDate: date3, name: "Whole Wheat Bread", id: UUID())
            
            return State(
                recipeDates: dateComponents,
                recipesByDate: recipesByDate
            )
        }
    }
    
    enum Action {
        case dateSelected(Date)
        case destination(PresentationAction<Destination.Action>)
        case recipeSelected(Entry)
        case fetchRecipes
        case recipesResponse(TaskResult<[Entry]>)
    }
    
    @Reducer
    struct Destination {
        enum State: Equatable {
            case recipeDetail(RecipeDetailFeature.State)
        }
        
        enum Action: Equatable {
            case recipeDetail(RecipeDetailFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.recipeDetail,
                  action: \.recipeDetail) {
                RecipeDetailFeature()
            }
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .dateSelected(date):
                state.selectedDate = date
                return .none
                
            case .destination:
                return .none
                
            case let .recipeSelected(recipe):
                state.destination = .recipeDetail(
                    RecipeDetailFeature.State(
                        mode: .edit,
                        entry: recipe
                    )
                )
                return .none
                
            case .fetchRecipes:
                state.isLoading = true
                return .run { send in
                    await send(.recipesResponse(TaskResult { try await homeClient.fetch() }))
                }
                
            case let .recipesResponse(.success(entries)):
                state.isLoading = false
                
                // Group entries by date
                var recipesByDate: [Date: Entry] = [:]
                var recipeDates = Set<DateComponents>()
                let calendar = Calendar.current
                
                for entry in entries {
                    let date = calendar.startOfDay(for: entry.entryDate)
                    recipesByDate[date] = entry
                    recipeDates.insert(calendar.dateComponents([.year, .month, .day], from: date))
                }
                
                state.recipesByDate = recipesByDate
                state.recipeDates = recipeDates
                return .none
                
            case .recipesResponse(.failure):
                state.isLoading = false
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}
