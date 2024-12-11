import ComposableArchitecture
import Foundation

@Reducer
struct CalendarFeature {
    @ObservableState
    struct State: Equatable {
        var selectedDate: Date = Date() // Default to the current date
        var recipeDates: Set<DateComponents>
        var recipesByDate: [Date: String]
        
        static func mockState() -> State {
            let calendar = Calendar.current
            let today = Date()
            
            // Create three specific dates
            let date1 = calendar.date(byAdding: .day, value: -2, to: today)! // 2 days ago
            let date2 = calendar.date(byAdding: .day, value: -5, to: today)! // 5 days ago
            let date3 = calendar.date(byAdding: .day, value: -7, to: today)! // 7 days ago
            
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
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .dateSelected(date):
                state.selectedDate = date
                return .none
            }
        }
    }
}
