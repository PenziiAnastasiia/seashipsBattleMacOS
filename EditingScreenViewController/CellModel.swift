import Foundation

struct CellModel: Equatable {
    
    enum CellType: Equatable {
        case full(StateType)
        case empty
        case miss
    }
    
    enum StateType: Equatable {
        case `default`
        case damaged
        case destroyed
    }
    
    let id: String
    var type: CellType
    
}
