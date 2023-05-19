import Foundation

struct ShipModel: Equatable {
    init(decks: [IndexPath]) {
        self.decks = decks.compactMap { indexPath in
            DeckModel(point: indexPath)
        }
    }
    
    var decks: [DeckModel]
    var isDestroyed: Bool {
        return !decks.compactMap { deck in
            deck.isDestroyed
        }.contains(false)
    }
    
}

struct DeckModel: Equatable {
    let point: IndexPath
    var isDestroyed: Bool = false
}
