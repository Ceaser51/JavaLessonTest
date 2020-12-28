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
        Coin(id: "BTC", name: "Bitcoin", price: "9733.95", icon: "bitcoin", lineCoordinates: [2000,8000,4000,9000,5000,6000,3000]),
        Coin(id: "LTC", name: "Litecoin", price: "78.70", icon: "litecoin", lineCoordinates: [20,10,40,70,50,60,30]),
        Coin(id: "XRP", na