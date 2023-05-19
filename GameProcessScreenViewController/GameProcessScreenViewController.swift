import Cocoa

class GameProcessScreenViewController: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    var rootView: GameProcessScreenView {
        self.view as! GameProcessScreenView
    }
    
    private var myCellModels: [[CellModel]] = []
    private var enemyCellModels: [[CellModel]] = []
    private var lockedPoints: [IndexPath] = []
    
    //private var myShips = [ShipModel]()
    //private var enemyShips = [ShipModel]()
    
    private var myShipsArray = [[IndexPath]]()
    private var enemyShipsArray = [[IndexPath]]()
    private var enemy: [[IndexPath]] = [[], [], [], [], [], [], [], [], [], []]
    
    static func createController(myShips: [[IndexPath]], enemyShips: [[IndexPath]]) -> NSViewController? {
        let storyBoard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: GameProcessScreenViewController.self)
        let controller = storyBoard.instantiateController(withIdentifier: identifier) as? GameProcessScreenViewController
//        controller?.myShips = myShips
//        controller?.enemyShips = enemyShips
        controller?.myShipsArray = myShips
        controller?.enemyShipsArray = enemyShips
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.configureCollections()
    }
    
    //MARK:
    //MARK: - Private
    
    private func configureCollections() {
        self.myCellModels = self.generateItems()
        self.enemyCellModels = self.generateItems()
        [self.rootView.myCollection, self.rootView.enemyCollection]
            .forEach { collection in
                self.configure(collection: collection)
            }
    }
    
    private func configure(collection: NSCollectionView?) {
        collection?.register(PoligonCell.self, forItemWithIdentifier: Config.poligonCellIdentifier)
        collection?.dataSource = self
        collection?.delegate = self
        collection?.isSelectable = true
        collection?.reloadData()
    }
    
    public func generateItems() -> [[CellModel]] {
        return (0...9).compactMap { section in
            (0...9).compactMap { item in
                return CellModel(id: section.description + item.description, type: .empty)
            }
        }
    }
    
    private func models(from collection: NSCollectionView) -> [[CellModel]] {
        return collection == self.rootView.myCollection ? self.myCellModels : self.enemyCellModels
    }
    
    private func selectModel(at indexPath: IndexPath) {
        var model = self.enemyCellModels[indexPath.section][indexPath.item]
        if model.type == .empty {
            model.type = .miss
            (0...9).forEach { i in
                if self.enemyShipsArray[i].contains(where: { point in
                    point == indexPath
                }) {
                    self.enemy[i].append(indexPath)
                    model.type = .full(.damaged)
                    if self.enemy[i].count == self.enemyShipsArray[i].count {
                        model.type = .full(.destroyed)
                        self.enemy[i].forEach { point in
                            self.enemyCellModels[point.section][point.item].type = .full(.destroyed)
                        }
                    }
                }
            }
            self.enemyCellModels[indexPath.section][indexPath.item] = model
        }
        
//        self.enemyShipsArray.forEach { ship in
//            if let index = ship.firstIndex(of: indexPath) {
//                self.enemy[index].append(indexPath)
//                if self.enemy[index].count != self.enemyShipsArray[index].count {
//                    model.type = .full(.damaged)
//                } else {
//                    model.type = .full(.destroyed)
//                    self.enemy[index].forEach { point in
//                        self.enemyCellModels[point.section][point.item].type = .full(.destroyed)
//                    }
//                }
//            }
//        }
//        self.enemyCellModels[indexPath.section][indexPath.item] = model
        
        
//        var maybeShip = self.enemyShips.first { ship in
//            ship.decks.contains { deck in
//                deck.point == indexPath
//            }
//        }
//        if let ship = maybeShip {
//            if let index = ship.decks.firstIndex(where: { deck in deck.point == indexPath }) {
//                var d = maybeShip?.decks.remove(at: index)
//                d?.isDestroyed = true
//                d.do { maybeShip?.decks.append($0) }
//            }
//
//        }
        
//            if !ship.isDestroyed {
//                model.type = .full(.damaged)
//            } else if ship.isDestroyed {
//                model.type = .full(.destroyed)
//            }
//
//        self.cellModels[indexPath.section][indexPath.item] = model
//
//        return model.type
    }
 
    //MARK:
    //MARK: - NSCollectionViewDataSource
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return self.models(from: collectionView).count
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.models(from: collectionView)[section].count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let model = self.models(from: collectionView)[indexPath.section][indexPath.item]
        let item = collectionView.makeItem(withIdentifier: Config.poligonCellIdentifier, for: indexPath) as! PoligonCell
        item.fill(with: model)
        
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        if collectionView == self.rootView.enemyCollection, let indexPath = indexPaths.first {
            self.selectModel(at: indexPath)
            collectionView.reloadData()
        }
    }
       
}
