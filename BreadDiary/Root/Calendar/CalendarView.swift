import ComposableArchitecture
import SwiftUI

struct CalendarView: View {
    let store: StoreOf<CalendarFeature>
    
    var body: some View {
        VStack {
            Text("Calendar").font(.largeTitle)
            DatePicker(
                "",
                selection: Binding(
                    get: { store.selectedDate },
                    set: { store.send(.dateSelected($0)) }
                ),
                in: ...Date(),
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .tint(.black)
            .frame(maxWidth: .infinity, maxHeight: 400)
            
            Divider()
                .background(.black)
                .frame(height: 2)
            
            VStack(alignment: .leading) {
                let calendar = Calendar.current
                let selectedComponents = calendar.dateComponents([.year, .month, .day], from: store.selectedDate)
                
                if let recipe = store.recipesByDate.first(where: { calendar.dateComponents([.year, .month, .day], from: $0.key) == selectedComponents })?.value {
                    Text("• \(recipe)")
                        .padding(.vertical, 4)
                } else {
                    Text("No recipe for this date")
                        .padding(.vertical, 4)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
            .frame(maxWidth: .infinity, alignment: .leading)
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
