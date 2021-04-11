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
        Coin(id: "ETH", name: "Ethereum", price: "78.70", icon: "ethereum", lineCoordinates: [20.00,10.00,40.00,70.00,50.00,60.00,30.0])
    ]
    
    var myWallet: [Coin] = [
    Coin(id: "BTC", name: "Bitcoin", price: "1000.0", icon: "bitcoin", lineCoordinates: [2000,1000,4000,7000,5000,6000,3000]),
    Coin(id: "LTC", name: "Litecoin", price: "2000.0", icon: "litecoin", lineCoordinates: [20,10,40,70,50,60,30]),
    Coin(id: "TRX", name: "Tron", price: "133.7", icon: "tron",
        lineCoordinates: [0.02,0.01,0.04,0.07,0.05,0.06,0.03]),
    ]
    
    var body: some View {
        
        NavigationView {
            
            VStack {

                LineChartController(lineCoordinates: [3,2,6], inline: true)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150)
                    .padding()
                
                Text("Your crypto balance")
                Text("$3133.7")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                
                List {
                    
                    Section(header: Text("My Wallet")) {
                        ForEach(myWallet) { coin in
                            HStack {
                                Image(coin.icon)
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .leading)
                                    
                                Text("\(coin.name) (\(coin.id))")
                                Spacer()
                                Text(coin.price).fontWeight(.bold)
                            }
                        }
                    }
                    
                    Section(header: Text("Current Prices")) {
                        ForEach(rates) { coin in
                            
                            NavigationLink(destination: GraphCoin(title: coin.name, lineCoordinates: coin.lineCoordinates)) {

                                HStack {
                                    Image(coin.icon)
                                        .resizable()
                                        .frame(width: 30, height: 30, alignment: .leading)
                                    
                                    Text("\(coin.name) (\(coin.id))")
                                    Spacer()
                                    Text(coin.price).fontWeight(.bold)
                                }
                            }
                        }
                    }
                }.listStyle(GroupedListStyle())
            }
            
            .navigationBarTitle(Text("Dashboard"))
            .navigationBarHidden(true)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
