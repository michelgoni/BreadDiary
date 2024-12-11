import ComposableArchitecture
import Foundation

@Reducer
struct CalendarFeature {
    @ObservableState
    struct State: Equatable {
        var selectedDate = Date()
        var recipeDates: Set<DateComponents>
        var recipesByDate: [Date: String]
        
        static func mockState() -> State {
            let calendar = Calendar.current
            let today = Date()
            
            // Create three specific dates
            let date1 = calendar.date(byAdding: .day, value: -2, to: today)!
            let date2 = calendar.date(byAdding: .day, value: -5, to: today)!
            let date3 = calendar.date(byAdding: .day, value: -7, to: today)!
            
            let dates = [date1, date2, date3]
            let dateComponents = Set(dates.map { calendar.dateComponents([.year, .month, .day], from: $0) })
            
            return State(
                recipeDates: dateComponents,
                recipesByDate: [
                    date1: "Sourdough Bread",
                    date2: "Rye Bread",
                    date3: "Whole Wheat Bread"
                ]
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
