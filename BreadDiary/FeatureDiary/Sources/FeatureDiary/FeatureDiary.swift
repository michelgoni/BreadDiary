import SwiftUI
import Foundation
@available(iOS 16.0, *)

struct Device: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let iconName: String
}
@available(iOS 16.0, *)
enum DeviceRepository {
    static let all = [
        Device(name: "AirPods", iconName: "airpods"),
        Device(name: "AirPods Pro", iconName: "airpodspro"),
        Device(name: "AppleTV", iconName: "appletv"),
        Device(name: "Apple Watch", iconName: "applewatch"),
        Device(name: "HomePod", iconName: "homepod"),
        Device(name: "iPad", iconName: "ipad"),
        Device(name: "iPhone", iconName: "iphone"),
        Device(name: "iPod", iconName: "ipod"),
        Device(name: "Apple Pencil", iconName: "pencil.tip")
    ]
}
@available(iOS 16.0, *)
struct DeviceItem: View {
    let device: Device
    var body: some View {
        VStack {
            Image(systemName: device.iconName)
                .font(.title)
                .padding(.bottom, 8)
            Text(device.name)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .leading)
        .listRowInsets(EdgeInsets())
        .padding()
        .background(Color(white: 0.95))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
@available(iOS 16.0, *)
struct ContentView: View {
    // 1
    let devices = DeviceRepository.all
    // 2
    let columns = [
        GridItem(.flexible(minimum: 190), spacing: 20),
        GridItem(.flexible(minimum: 190), spacing: 20)
    ]
    var body: some View {
        NavigationStack {
            ScrollView {
                // 3
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(devices, content: DeviceItem.init)
                }
                .foregroundColor(.red)
                .padding(.all, 50)
                .navigationTitle("Devices")
                .navigationViewStyle(.stack)
            }
        }
    }
}

@available(iOS 16.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
    }
}
