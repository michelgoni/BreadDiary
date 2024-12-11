import ComposableArchitecture
import SwiftUI

struct CalendarView: View {
    let store: StoreOf<CalendarFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("Calendar").font(.largeTitle)
                DatePicker(
                    "",
                    selection: viewStore.binding(
                        get: \.selectedDate,
                        send: { .dateSelected($0) }
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
                    let selectedComponents = calendar.dateComponents([.year, .month, .day], from: viewStore.selectedDate)
                    
                    if let recipe = viewStore.recipesByDate.first(where: { calendar.dateComponents([.year, .month, .day], from: $0.key) == selectedComponents })?.value {
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
}

#Preview("Calendar") {
    CalendarView(
        store: Store(initialState: CalendarFeature.State.mockState()) {
            CalendarFeature()
        }
    )
}
