import ComposableArchitecture
import SwiftUI

struct CalendarView: View {
    let store: StoreOf<CalendarFeature>
    
    var body: some View {
            Text(store.title)
        }
}


#Preview("Calendar") {
    CalendarView(
        store: CalendarFeature.previewStore()
    )
}
