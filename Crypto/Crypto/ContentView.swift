import SwiftUI

struct GraphCoin: View {
    
    let title: String
    let lineCoordinates: [CGFloat]
    
    var body: some  View {
        LineChartController(lineCoordinates: lineCoordina