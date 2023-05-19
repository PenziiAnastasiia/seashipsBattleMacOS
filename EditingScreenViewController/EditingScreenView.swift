import Cocoa

class EditingScreenView: NSView {

    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var conteiner: NSView!
    @IBOutlet weak var collection: NSCollectionView!
    
    var editingTime: Timer?
    var seconds = 180 {
        didSet {
            if seconds % 60 < 10 {
                timerLabel.stringValue = "0\(Int(seconds / 60)):0\(seconds % 60)"
            } else {
                timerLabel.stringValue = "0\(Int(seconds / 60)):\(seconds % 60)"
            }
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        self.draw()
    }
    
    public func startTimer() {
        self.editingTime = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.seconds -= 1
            if self?.seconds == 0 {
                self?.editingTime?.invalidate()
                self?.editingTime = nil
            }
        })
    }
    
    private func draw() {
        let path = NSBezierPath()
        self.drawHorisontalLine(to: path)
        self.drawVerticalLine(to: path)
        let layer = CAShapeLayer()
        layer.frame = self.conteiner.bounds
        layer.path = path.cgPath
        layer.lineWidth = 2
        layer.strokeColor = NSColor.black.cgColor
        self.conteiner.layer?.addSublayer(layer)
    }
    
    private func drawHorisontalLine(to path: NSBezierPath) {
        let heigth = Double(conteiner.bounds.size.height / 10)
        let frameWidth = conteiner.frame.width
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
    
    private func drawVerticalLine(to path: NSBezierPath) {
        let width = Double(conteiner.bounds.size.width / 10)
        let frameHeigth = conteiner.frame.height
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
