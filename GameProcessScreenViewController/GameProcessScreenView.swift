import Cocoa

class GameProcessScreenView: NSView {

    @IBOutlet weak var myConteiner: NSView!
    @IBOutlet weak var myCollection: NSCollectionView!
    
    @IBOutlet weak var enemyConteiner: NSView!
    @IBOutlet weak var enemyCollection: NSCollectionView!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        self.draw(on: myConteiner)
        self.draw(on: enemyConteiner)
    }
    
    private func draw(on view: NSView) {
        let path = NSBezierPath()
        self.drawHorisontalLine(to: path, on: view)
        self.drawVerticalLine(to: path, on: view)
        let layer = CAShapeLayer()
        layer.frame = view.bounds
        layer.path = path.cgPath
        layer.lineWidth = 2
        layer.strokeColor = NSColor.black.cgColor
        view.layer?.addSublayer(layer)
    }
    
    private func drawHorisontalLine(to path: NSBezierPath, on view: NSView) {
        let heigth = Double(view.bounds.size.height / 10)
        let frameWidth = view.frame.width
        var currentX = 0.0
        var currentY = 0.0
        (1...9).forEach { _ in
            currentY += heigth
            path.move(to: CGPoint(x: currentX, y: currentY))
            if currentX == 0.0 {
                currentX = frameWidth
            } else {
                currentX = 0.0
            }
            path.line(to: CGPoint(x: currentX, y: currentY))
        }
    }
    
    private func drawVerticalLine(to path: NSBezierPath, on view: NSView) {
        let width = Double(view.bounds.size.width / 10)
        let frameHeigth = view.frame.height
        var currentX = 0.0
        var currentY = 0.0
        (1...9).forEach { _ in
            currentX += width
            path.move(to: CGPoint(x: currentX, y: currentY))
            if currentY == 0.0 {
                currentY = frameHeigth
            } else {
                currentY = 0.0
            }
            path.line(to: CGPoint(x: currentX, y: currentY))
        }
    }
}
