import SwiftUI
import UIKit

struct LineChartController: UIViewRepresentable {
    
    let lineCoordinates: [CGFloat]
    let inline: Bool
    
    func updateUIView(_ uiView: LineChart, context: UIViewRepresentableContext<LineChartController>) {
        
    }
    
    func makeUIView(context: Context) -> LineChart {
