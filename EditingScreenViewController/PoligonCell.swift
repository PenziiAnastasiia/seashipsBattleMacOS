import Cocoa

class PoligonCell: NSCollectionViewItem {

    private var model: CellModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.model = nil
        self.changeColor(with: .empty)
    }
    
    public func fill(with model: CellModel) {
        self.model = model
        self.changeColor(with: model.type)
    }
    
    private func changeColor(with type: CellModel.CellType) {
        let layer = CAShapeLayer()
        self.view.layer = layer
        switch type {
        case .empty:
            layer.backgroundColor = NSColor.white.cgColor
        case .miss:
            layer.backgroundColor = NSColor.unemphasizedSelectedTextBackgroundColor.cgColor
        case .full(let deckType):
            switch deckType {
            case .default:
                layer.backgroundColor = NSColor.systemCyan.cgColor
            case .damaged:
                layer.backgroundColor = NSColor.systemPink.withAlphaComponent(0.4).cgColor
            case .destroyed:
                layer.backgroundColor = NSColor.systemRed.cgColor
            }
        }
    }
    
}

//extension NSColor {
//    class func fromHex(hex: Int, alpha: Float) -> NSColor {
//        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
//        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
//        let blue = CGFloat((hex & 0xFF)) / 255.0
//        return NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1.0)
//    }
//    
//    class func fromHexString(hex: String, alpha: Float) -> NSColor? {
//        // Handle two types of literals: 0x and # prefixed
//        var cleanedString = ""
//        if hex.hasPrefix("0x") {
//            cleanedString = hex.suffix(from: 2)//.substringFromIndex(2)
//        } else if hex.hasPrefix("#") {
//            cleanedString = hex.substringFromIndex(1)
//        }
//        // Ensure it only contains valid hex characters 0
//        let validHexPattern = "[a-fA-F0-9]+"
//        if cleanedString.conformsTo(validHexPattern) {
//            var theInt: UInt32 = 0
//            let scanner = NSScanner.scannerWithString(cleanedString)
//            scanner.scanHexInt(&theInt)
//            let red = CGFloat((theInt & 0xFF0000) >> 16) / 255.0
//            let green = CGFloat((theInt & 0xFF00) >> 8) / 255.0
//            let blue = CGFloat((theInt & 0xFF)) / 255.0
//            return NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1.0)
//    
//        } else {
//            return Optional.None
//        }
//    }
//}
