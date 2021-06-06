
import UIKit
import QuartzCore

// delegate method
public protocol LineChartDelegate {
    func didSelectDataPoint(_ x: CGFloat, yValues: [CGFloat])
}

/**
 * LineChart
 */
open class LineChart: UIView {
    
    /**
     * Helpers class
     */
    fileprivate class Helpers {
        
        /**
         * Convert hex color to UIColor
         */
        fileprivate class func UIColorFromHex(_ hex: Int) -> UIColor {
            let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
            let blue = CGFloat((hex & 0xFF)) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
        
        /**
         * Lighten color.
         */
        fileprivate class func lightenUIColor(_ color: UIColor) -> UIColor {
            var h: CGFloat = 0
            var s: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            return UIColor(hue: h, saturation: s, brightness: b * 1.5, alpha: a)
        }
    }
    
    public struct Labels {
        public var visible: Bool = true
        public var values: [String] = []
    }
    
    public struct Grid {
        public var visible: Bool = true
        public var count: CGFloat = 10
        // #eeeeee
        public var color: UIColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
    }
    
    public struct Axis {
        public var visible: Bool = true
        // #607d8b
        public var color: UIColor = UIColor(red: 96/255.0, green: 125/255.0, blue: 139/255.0, alpha: 1)
        public var inset: CGFloat = 15
    }
    
    public struct Coordinate {
        // public
        public var labels: Labels = Labels()
        public var grid: Grid = Grid()
        public var axis: Axis = Axis()
        
        // private
        fileprivate var linear: LinearScale!
        fileprivate var scale: ((CGFloat) -> CGFloat)!
        fileprivate var invert: ((CGFloat) -> CGFloat)!
        fileprivate var ticks: (CGFloat, CGFloat, CGFloat)!
    }
    
    public struct Animation {
        public var enabled: Bool = true
        public var duration: CFTimeInterval = 1
    }
    
    public struct Dots {
        public var visible: Bool = true
        public var color: UIColor = UIColor.white
        public var innerRadius: CGFloat = 8
        public var outerRadius: CGFloat = 12
        public var innerRadiusHighlighted: CGFloat = 8
        public var outerRadiusHighlighted: CGFloat = 12
    }
    
    // default configuration
    open var area: Bool = true
    open var animation: Animation = Animation()
    open var dots: Dots = Dots()
    open var lineWidth: CGFloat = 2
    
    open var x: Coordinate = Coordinate()
    open var y: Coordinate = Coordinate()
    
    
    // values calculated on init
    fileprivate var drawingHeight: CGFloat = 0 {
        didSet {
            let max = getMaximumValue()
            let min = getMinimumValue()
            y.linear = LinearScale(domain: [min, max], range: [0, drawingHeight])
            y.scale = y.linear.scale()
            y.ticks = y.linear.ticks(Int(y.grid.count))
        }
    }
    fileprivate var drawingWidth: CGFloat = 0 {
        didSet {
            let data = dataStore[0]
            x.linear = LinearScale(domain: [0.0, CGFloat(data.count - 1)], range: [0, drawingWidth])
            x.scale = x.linear.scale()
            x.invert = x.linear.invert()
            x.ticks = x.linear.ticks(Int(x.grid.count))
        }
    }
    
    open var delegate: LineChartDelegate?
    
    // data stores
    fileprivate var dataStore: [[CGFloat]] = []
    fileprivate var dotsDataStore: [[DotCALayer]] = []
    fileprivate var lineLayerStore: [CAShapeLayer] = []
    
    fileprivate var removeAll: Bool = false
    
    // category10 colors from d3 - https://github.com/mbostock/d3/wiki/Ordinal-Scales
    open var colors: [UIColor] = [
        UIColor(red: 0.121569, green: 0.466667, blue: 0.705882, alpha: 1),
        UIColor(red: 1, green: 0.498039, blue: 0.054902, alpha: 1),
        UIColor(red: 0.172549, green: 0.627451, blue: 0.172549, alpha: 1),
        UIColor(red: 0.839216, green: 0.152941, blue: 0.156863, alpha: 1),
        UIColor(red: 0.580392, green: 0.403922, blue: 0.741176, alpha: 1),
        UIColor(red: 0.54902, green: 0.337255, blue: 0.294118, alpha: 1),
        UIColor(red: 0.890196, green: 0.466667, blue: 0.760784, alpha: 1),
        UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1),
        UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1),
        UIColor(red: 0.0901961, green: 0.745098, blue: 0.811765, alpha: 1)
    ]
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func draw(_ rect: CGRect) {
        
        if removeAll {
            let context = UIGraphicsGetCurrentContext()
            context?.clear(rect)
            return
        }
        
        self.drawingHeight = self.bounds.height - (2 * y.axis.inset)
        self.drawingWidth = self.bounds.width - (2 * x.axis.inset)
        
        // remove all labels
        for view: AnyObject in self.subviews {
            view.removeFromSuperview()
        }
        
        // remove all lines on device rotation
        for lineLayer in lineLayerStore {
            lineLayer.removeFromSuperlayer()
        }
        lineLayerStore.removeAll()
        
        // remove all dots on device rotation
        for dotsData in dotsDataStore {
            for dot in dotsData {
                dot.removeFromSuperlayer()
            }
        }
        dotsDataStore.removeAll()
        
        // draw grid
        if x.grid.visible && y.grid.visible { drawGrid() }
        
        // draw axes
        if x.axis.visible && y.axis.visible { drawAxes() }
        
        // draw labels
        if x.labels.visible { drawXLabels() }
        if y.labels.visible { drawYLabels() }
        
        // draw lines
        for (lineIndex, _) in dataStore.enumerated() {
            
            drawLine(lineIndex)
            
            // draw dots
            if dots.visible { drawDataDots(lineIndex) }
            
            // draw area under line chart
            if area { drawAreaBeneathLineChart(lineIndex) }
            
        }
        
    }
    
    
    
    /**
     * Get y value for given x value. Or return zero or maximum value.
     */
    fileprivate func getYValuesForXValue(_ x: Int) -> [CGFloat] {
        var result: [CGFloat] = []
        for lineData in dataStore {
            if x < 0 {
                result.append(lineData[0])
            } else if x > lineData.count - 1 {
                result.append(lineData[lineData.count - 1])
            } else {
                result.append(lineData[x])
            }
        }
        return result
    }
    
    
    
    /**
     * Handle touch events.
     */
    fileprivate func handleTouchEvents(_ touches: NSSet!, event: UIEvent) {
        if (self.dataStore.isEmpty) {
            return
        }
        let point: AnyObject! = touches.anyObject() as! AnyObject
        let xValue = point.location(in: self).x
        let inverted = self.x.invert(xValue - x.axis.inset)
        let rounded = Int(round(Double(inverted)))
        let yValues: [CGFloat] = getYValuesForXValue(rounded)
        highlightDataPoints(rounded)
        delegate?.didSelectDataPoint(CGFloat(rounded), yValues: yValues)
    }
    
    
    
    /**
     * Listen on touch end event.
     */
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchEvents(touches as! NSSet, event: event!)
    }
    
    
    
    /**
     * Listen on touch move event
     */
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchEvents(touches as! NSSet, event: event!)
    }
    
    
    
    /**
     * Highlight data points at index.
     */
    fileprivate func highlightDataPoints(_ index: Int) {
        for (lineIndex, dotsData) in dotsDataStore.enumerated() {
            // make all dots white again
            for dot in dotsData {
                dot.backgroundColor = dots.color.cgColor
            }
            // highlight current data point
            var dot: DotCALayer
            if index < 0 {
                dot = dotsData[0]
            } else if index > dotsData.count - 1 {
                dot = dotsData[dotsData.count - 1]
            } else {
                dot = dotsData[index]
            }
            dot.backgroundColor = Helpers.lightenUIColor(colors[lineIndex]).cgColor
        }
    }
    
    
    
    /**
     * Draw small dot at every data point.
     */
    fileprivate func drawDataDots(_ lineIndex: Int) {
        var dotLayers: [DotCALayer] = []
        var data = self.dataStore[lineIndex]
        
        for index in 0..<data.count {
            let xValue = self.x.scale(CGFloat(index)) + x.axis.inset - dots.outerRadius/2
            let yValue = self.bounds.height - self.y.scale(data[index]) - y.axis.inset - dots.outerRadius/2
            
            // draw custom layer with another layer in the center
            let dotLayer = DotCALayer()
            dotLayer.dotInnerColor = colors[lineIndex]
            dotLayer.innerRadius = dots.innerRadius
            dotLayer.backgroundColor = dots.color.cgColor
            dotLayer.cornerRadius = dots.outerRadius / 2
            dotLayer.frame = CGRect(x: xValue, y: yValue, width: dots.outerRadius, height: dots.outerRadius)
            self.layer.addSublayer(dotLayer)
            dotLayers.append(dotLayer)
            
            // animate opacity
            if animation.enabled {
                let anim = CABasicAnimation(keyPath: "opacity")
                anim.duration = animation.duration
                anim.fromValue = 0
                anim.toValue = 1