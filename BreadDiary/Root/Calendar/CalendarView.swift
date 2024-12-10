import ComposableArchitecture
import SwiftUI

struct CalendarView: View {
    let store: StoreOf<CalendarFeature>
    
    var body: some View {
        VStack {
            Text("Calendar").font(.largeTitle)
            MultiDatePicker(
                "",
                selection: .constant(Set(store.recipeDates.map { Calendar.current.dateComponents([.year, .month, .day], from: $0) }))
            )
            .datePickerStyle(.graphical)
            .tint(.black)
            .frame(maxWidth: .infinity, maxHeight: 400)
            Divider()
                .background(.black)
                .frame(height: 2)
        }
        .padding()
    }
}

#Preview("Calendar") {
    CalendarView(
        store: Store(initialState: CalendarFeature.State.mockState()) {
            CalendarFeature()
        }
    )
}
