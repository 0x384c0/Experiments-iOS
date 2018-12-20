import Foundation

class TriangleView:UIView{
    @IBInspectable
    var triangleColor:UIColor = UIColor.black
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxY))
        context.closePath()
        context.setFillColor(triangleColor.cgColor)
        context.fillPath()
    }
}
