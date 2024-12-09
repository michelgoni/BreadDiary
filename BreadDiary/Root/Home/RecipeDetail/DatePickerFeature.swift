//
//  DatePickerFeature.swift
//  MyBreadTCADiary
//
//  Created by Michel Goñi on 18/11/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct DatePickerFeature {
    @ObservableState
    struct State: Equatable {
        var date: Date
        var field: RecipeDetailFeature.Action.TimeField
    }
    
    enum Action: Equatable {
        case dateChanged(Date)
        case doneButtonTapped
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case timeSelected(Date, RecipeDetailFeature.Action.TimeField)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .dateChanged(date):
                state.date = date
                return .none
                
            case .doneButtonTapped:
                return .send(.delegate(.timeSelected(state.date, state.field)))
                
            case .delegate:
                return .none
            }
        }
    }
}
