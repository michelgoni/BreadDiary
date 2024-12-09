import ComposableArchitecture
import Foundation

@Reducer
struct CalendarFeature {
    @ObservableState
    struct State: Equatable {
        var recipeDates: [Date] = []
        var selectedDate: Date?
        
        static func mockState() -> State {
            var state = State()
            // Create some mock dates for today and tomorrow
            let dayBeforeYesterday = Calendar.current.date(byAdding: .day, value: -5, to: Date())!
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            state.recipeDates = [Date(), yesterday, dayBeforeYesterday]
            return state
        }
    }
    
    enum Action: Equatable {
        case dateSelected(Date)
        case loadRecipeDates
        case recipeDatesLoaded([Date])
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .dateSelected(date):
                state.selectedDate = date
                return .none
                
            case .loadRecipeDates:
                return .none  // Here you would load the actual recipe dates from your data source
                
            case let .recipeDatesLoaded(dates):
                state.recipeDates = dates
                return .none
            }
        }
    }

    static func previewStore() -> StoreOf<CalendarFeature> {
        Store(initialState: CalendarFeature.State.mockState()) {
            CalendarFeature()
        }
    }
}
