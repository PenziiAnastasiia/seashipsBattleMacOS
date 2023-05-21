import Cocoa

class GameProcessScreenViewController: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    var rootView: GameProcessScreenView {
        self.view as! GameProcessScreenView
    }
    
    private var myCellModels: [[CellModel]] = []
    private var enemyCellModels: [[CellModel]] = []
    private var myShipsArray = [[IndexPath]]()
    private var myShipsDictionary: [Int : [IndexPath]] = [:]
    private var enemyShipsArray = [[IndexPath]]()
    private var enemyShipsDictionary: [Int : [IndexPath]] = [:]
    
    private var enemyBoard = BoardGenerator.generate
    
    static func createController(myShips: [[IndexPath]], enemyShips: [[IndexPath]]) -> NSViewController? {
        let storyBoard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: GameProcessScreenViewController.self)
        let controller = storyBoard.instantiateController(withIdentifier: identifier) as? GameProcessScreenViewController
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

        _ = self.myShipsArray.compactMap { ship in
            ship.compactMap { point in
                self.myCellModels[point.section][point.item].type = .full(.default)
            }
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
        guard self.enemyCellModels[indexPath.section][indexPath.item].type == .empty else { return }
        let safeZone = self.selectModel(
            at: indexPath,
            shipsArray: self.enemyShipsArray,
            cellModels: &self.enemyCellModels,
            shipsDictionary: &self.enemyShipsDictionary)
        
        safeZone.forEach { point in
            self.enemyCellModels[point.section][point.item].type = .miss
        }
        self.rootView.enemyCollection.reloadData()
        if !self.checkShips() {
            self.enemyActions()
        }
    }
    
    private func selectModel(
        at indexPath: IndexPath,
        shipsArray: [[IndexPath]],
        cellModels: inout [[CellModel]],
        shipsDictionary: inout [Int : [IndexPath]]
    ) -> [IndexPath]
    {
        var model = cellModels[indexPath.section][indexPath.item]
        var safeZone: [IndexPath] = []
        model.type = .miss
        shipsArray.enumerated().forEach { (i, ship) in
            if ship.contains(indexPath) {
                if shipsDictionary[i] == nil {
                    shipsDictionary[i] = [indexPath]
                } else {
                    shipsDictionary[i]?.append(indexPath)
                }
                model.type = .full(.damaged)
                if shipsDictionary[i]?.count == shipsArray[i].count {
                    model.type = .full(.destroyed)
                    shipsDictionary[i]?.forEach { point in
                        cellModels[point.section][point.item].type = .full(.destroyed)
                    }
                    safeZone = SafeZoneBuilder.createSafeZone(around: ship, state: .vertical)
                    if ship.count > 1 {
                        if ship[0].add(item: 1) == ship[1] {
                            safeZone = SafeZoneBuilder.createSafeZone(around: ship, state: .horisontal)
                        }
                    }
                    
                }
            }
        }
        cellModels[indexPath.section][indexPath.item] = model
        
        return safeZone
    }
    
    private func enemyActions() {
        guard let point = self.enemyBoard.randomElement() else { return }
        self.enemyBoard.remove(object: point)
        let safeZone = self.selectModel(
            at: point,
            shipsArray: self.myShipsArray,
            cellModels: &self.myCellModels,
            shipsDictionary: &self.myShipsDictionary)
        safeZone.forEach { point in
            self.enemyBoard.remove(object: point)
        }
        self.rootView.myCollection.reloadData()
        _ = self.checkShips()
    }
    
    private func checkShips() -> Bool {
        var ships = self.myShipsDictionary.compactMap { $1 }
        if self.check(ships: ships) {
            NSAlert.showAlert(title: "На жаль!", message: "Ви програли!") { [weak self] value in
                self?.presentStartFlow()
            }
            
            return true
        }
        
        ships = self.enemyShipsDictionary.compactMap { $1 }
        if self.check(ships: ships) {
            NSAlert.showAlert(title: "Вітаннячка!", message: "Ви перемогли!") { [weak self] value in
                self?.presentStartFlow()
            }
            
            return true
        }
        
        return false
    }
    
    private func check(ships: [[IndexPath]]) -> Bool {
        if ships.count == 10 {
            return !(1...4).compactMap { i in
                if ships.filter({ ship in
                    ship.count == (5 - i)
                }).count == i {
                    return true
                } else {
                    return false
                }
            }.contains(false)
        }
        
        return false
    }
    
    private func presentStartFlow() {
        let storyBoard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: StartScreenViewController.self)
        
        self.view.window?.contentViewController = storyBoard.instantiateController(withIdentifier: identifier) as? NSViewController
        
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
        }
    }
       
}
