import Foundation

class ShipsBuilder {
    enum ShipState: Int {
        case horisontal
        case vertical
        
        var change: ShipState {
            switch self {
            case .horisontal:
                return .vertical
            case .vertical:
                return .horisontal
            }
        }
    }
    
    enum ShipLength: Int {
        case one
        case double
        case triple
        case quaternary
        
        static var all: [ShipLength] {
            return [.quaternary, .triple, .double, .one]
        }
    }
    
    private var mainArray: [IndexPath]
    var deckShipsArray: [IndexPath]
    private var shipsArray: [[IndexPath]]
    
    init() {
        self.mainArray = BoardGenerator.generate
        self.deckShipsArray = []
        self.shipsArray = []
    }
    
    public func createShips() -> [[IndexPath]] {
        self.mainArray = BoardGenerator.generate
        self.deckShipsArray = []
        self.shipsArray = []
        
        ShipLength.all.forEach { shipLength in
            self.createDecks(length: shipLength)
        }
        return self.shipsArray
    }
    
    private func createDecks(length: ShipLength) {
        (0...(3 - length.rawValue)).forEach { _ in
            self.createDeck(with: self.mainArray, length: length)
        }
    }
    
    private func createDeck(with array: [IndexPath], length: ShipLength) {
        var mainArray = array
        guard let startPoint = mainArray.randomElement() else { return }
        let state = self.shipState()
        let ship = self.createShip(with: startPoint, length: length, state: state)
        guard !ship.isEmpty else {
            mainArray.remove(object: startPoint)
            self.createDeck(with: mainArray, length: length)
            return
        }
        self.deckShipsArray += ship
        self.shipsArray.append(ship)
        ship.forEach { shipElement in
            self.mainArray.remove(object: shipElement)
        }
        self.createSafeZone(around: ship, state: state)
    }
    
    private func shipState() -> ShipState {
        let random = Int.random(in: 0...1)
        return ShipState(rawValue: random) ?? .horisontal
    }
    
    private func createShip(with point: IndexPath, length: ShipLength, state: ShipState) -> [IndexPath] {
        switch state {
        case .horisontal:
            for i in ((point.item - length.rawValue)...point.item) {
                let newPoint = IndexPath(item: i, section: point.section)
                if self.check(point: newPoint) {
                    if self.checkFitIn(startPoint: newPoint, length: length, state: state) {
                        return (0...length.rawValue).compactMap(newPoint.add(item:))
                    }
                }
            }
            return []
        case .vertical:
            for i in ((point.section - length.rawValue)...point.section) {
                let newPoint = IndexPath(item: point.item, section: i)
                if self.check(point: newPoint) {
                    if self.checkFitIn(startPoint: newPoint, length: length, state: state) {
                        return (0...length.rawValue).compactMap(newPoint.add(section:))
                    }
                }
            }
            return []
        }
    }
    
    private func check(point: IndexPath) -> Bool {
        return point.item >= 0
                && point.item <= 9
                && point.section >= 0
                && point.section <= 9
                && self.mainArray.contains(point)
    }
    
    private func checkFitIn(startPoint: IndexPath, length: ShipLength, state: ShipState) -> Bool {
        var endPoint: IndexPath
        switch state {
        case .horisontal:
            endPoint = startPoint.add(item: length.rawValue)
        case .vertical:
            endPoint = startPoint.add(section: length.rawValue)
        }
        return self.check(point: endPoint)
    }
    
    private func createSafeZone(around ship: [IndexPath], state: ShipState) {
        guard let first = ship.first, let last = ship.last else { return }
        switch state {
        case .horisontal:
            self.fillingMainArray(zone: first.aslantElements)
            self.fillingMainArray(zone: last.aslantElements)
            self.fillingMainArray(zone: self.verticalZone(point: first))
            self.fillingMainArray(zone: self.verticalZone(point: last))
            self.fillingMainArray(zone: [first.add(item: -1)])
            self.fillingMainArray(zone: [last.add(item: 1)])
        case .vertical:
            self.fillingMainArray(zone: first.aslantElements)
            self.fillingMainArray(zone: last.aslantElements)
            self.fillingMainArray(zone: self.horizontalZone(point: first))
            self.fillingMainArray(zone: self.horizontalZone(point: last))
            self.fillingMainArray(zone: [first.add(section: -1)])
            self.fillingMainArray(zone: [last.add(section: 1)])
        }
    }
    
    private func verticalZone(point: IndexPath) -> [IndexPath] {
        return [point.add(section: -1), point.add(section: 1)]
    }
    
    private func horizontalZone(point: IndexPath) -> [IndexPath] {
        return [point.add(item: -1), point.add(item: 1)]
    }
    
    private func fillingMainArray(zone: [IndexPath]) {
        zone.forEach { i in
            if self.mainArray.contains(i) {
                self.mainArray.remove(object: i)
            }
        }
    }
}
