import SwiftUI

struct GraphCoin: View {
    
    let title: String
    let lineCoordinates: [CGFloat]
    
    var body: some  View {
        LineChartController(lineCoordinates: lineCoordinates, inline: false)
            .padding(.leading, 30)
        .navigationBarTitle(Text(title))
    }
}


struct Coin: Identifiable {
    let id, name, price, icon: String
    let lineCoordinates: [CGFloat]
}

struct ContentView: View {
    
    var rates : [Coin] = [
        Coin(id: "BTC", name: "Bitcoin", price: "9733.95", icon: "bitcoin", 