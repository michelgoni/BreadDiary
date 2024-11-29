import ComposableArchitecture

@Reducer
struct CalendarFeature {
    @ObservableState
    struct State: Equatable {
        var title = "Calendar"
    }
    
    enum Action {
        // Add actions as needed
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // Handle actions
            }
        }
    }
}
