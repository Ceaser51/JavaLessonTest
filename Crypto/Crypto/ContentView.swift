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
        Coin(id: "XRP", name: "Ripple", price: "0.30", icon: "ripple", lineCoordinates: [2.0,1.0,4.0,7.0,5.0,6.0,3.0]),
        Coin(id: "TRX", name: "Tron", price: "0.02", icon: "tron", lineCoordinates: [0.12,0.41,0.74,0.37,0.15,0.96,0.23]),
        Coin(id: "ETH", name: "Ethereum", price: "78.70", icon: "ethereum", lineCoordinates: [20.0