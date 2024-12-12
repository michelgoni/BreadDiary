import ComposableArchitecture
import Foundation

@Reducer
struct CalendarFeature {
    @ObservableState
    struct State: Equatable {
        var selectedDate: Date = Date()
        var recipeDates: Set<DateComponents>
        var recipesByDate: [Date: String]
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
            
            var recipesByDate: [Date: String] = [:]
            recipesByDate[date1] = "Sourdough Bread"
            recipesByDate[date2] = "Rye Bread"
            recipesByDate[date3] = "Whole Wheat Bread"
            
            return State(
                recipeDates: dateComponents,
                recipesByDate: recipesByDate
            )
        }
    }
    
    enum Action {
        case dateSelected(Date)
        case destination(PresentationAction<Destination.Action>)
        case recipeSelected(String)
    }
    
    struct Destination: Reducer {
        enum State: Equatable {
            case recipeDetail(RecipeDetailFeature.State)
        }
        
        enum Action: Equatable {
            case recipeDetail(RecipeDetailFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.recipeDetail,
                  action: /Action.recipeDetail) {
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
                        entry: .init(name: recipe, id: UUID())
                    )
                )
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}
