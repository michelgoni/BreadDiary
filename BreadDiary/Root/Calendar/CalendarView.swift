import ComposableArchitecture
import SwiftUI

struct CalendarView: View {
    let store: StoreOf<CalendarFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text(viewStore.title)
        }
    }
}
