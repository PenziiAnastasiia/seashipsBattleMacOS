import Cocoa

struct Config {
    static let poligonCellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "PoligonCell")
}

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
                layer.backgroundColor = NSColor.init(hex: "#FF7C90", alpha: 1).cgColor
            case .destroyed:
                layer.backgroundColor = NSColor.systemRed.cgColor
            }
        }
    }
}
