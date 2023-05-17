import Cocoa

class EditingScreenViewController: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    struct Config {
        static let poligonCellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "PoligonCell")
    }

    //MARK:
    //MARK: - Properties
    
    var rootView: EditingScreenView {
        self.view as! EditingScreenView
    }
    
    private let shipsBuilder = ShipsBuilder()
    
    private var cellModels: [[CellModel]] = []
    private var lockedPoints: [IndexPath] = []
    private var mySelectPoints: [IndexPath] = []
    
    private var myShipsArray: [[IndexPath]] = []
    private var enemyShipsArray: [[IndexPath]] = []
    
    //MARK:
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollection()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.rootView.startTimer()
    }
    
    //MARK:
    //MARK: - Actions
    
    @IBAction func menuListAction(_ sender: NSButton) {
    }
    
    @IBAction func playAction(_ sender: NSButton) {
        self.createMyShips()
        self.enemyShipsArray = self.shipsBuilder.createShips()    }
    
    @IBAction func clearAction(_ sender: Any) {
        self.lockedPoints = []
        self.mySelectPoints = []
        self.generateItems()
        self.rootView.collection.reloadData()
    }
    
    //MARK:
    //MARK: - Private
    
    private func configureCollection() {
        self.generateItems()
        
        let collection = self.rootView.collection
        collection?.register(PoligonCell.self, forItemWithIdentifier: Config.poligonCellIdentifier)
        collection?.dataSource = self
        collection?.delegate = self
        collection?.isSelectable = true
        collection?.reloadData()
    }
    
    public func generateItems() {
        self.cellModels = (0...9).compactMap { section in
            (0...9).compactMap { item in
                return CellModel(id: section.description + item.description, type: .empty)
            }
        }
    }
    
    private func createMyShips() {
        let array = self.mySelectPoints.sorted { first, second in
            first.section < second.section
        }.reduce([[IndexPath]]()) { result, indexPath in
            var array = result
            if let section = result.first(where: { $0.first?.section == indexPath.section }) {
                var indexes = section
                indexes.append(indexPath)
                indexes.sort { $0.item < $1.item }
                array.firstIndex { $0.first?.section == indexPath.section }
                    .map { index in
                        array.remove(at: index)
                        array.append(indexes)
                    }
            } else {
                array.append([indexPath])
            }
            
            return array
        }
        print(array)
    }
    
    private func didSelectModel(at indexPath: IndexPath) -> CellModel.CellType {
        var model = self.cellModels[indexPath.section][indexPath.item]
        if model.type == .empty {
            model.type = .full(.damaged)
        } else {
            model.type = .empty
        }
        self.cellModels[indexPath.section][indexPath.item] = model
        return model.type
    }
    
    private func selectModel(at index: IndexPath) {
        let modelType = self.didSelectModel(at: index)
        var array = [IndexPath]()
        
        array += self.aslantLocking(at: index)
        
        if modelType == .full(.damaged) {
            self.lockedPoints += array
            self.mySelectPoints += [IndexPath.init(item: index.item, section: index.section)]
        } else {
            array.forEach { indexPath in
                if let lockedIndex = self.lockedPoints.firstIndex(of: indexPath) {
                    self.lockedPoints.remove(at: lockedIndex)
                }
            }
            if let selectIndex = self.mySelectPoints.firstIndex(of: index) {
                self.mySelectPoints.remove(at: selectIndex)
            }
        }
    
        self.didLockedModels(at: array)
    }
    
    private func aslantLocking(at index: IndexPath) -> [IndexPath] {
        var array = [IndexPath]()
        
        switch index.section {
        case 0:
            switch index.item {
            case 0:
                array += [index.nextItemAndSection]
            case 1...8:
                array += [index.previousItemNextSection, index.nextItemAndSection]
            case 9:
                array += [index.previousItemNextSection]
                
            default:
                return array
            }
        case 1...8:
            switch index.item {
            case 0:
                array += [index.nextItemPreviousSection, index.nextItemAndSection]
            case 1...8:
                array += index.aslantElements
            case 9:
                array += [index.previousItemAndSection, index.previousItemNextSection]
            default:
                return array
            }
        case 9:
            switch index.item {
            case 0:
                array += [index.nextItemPreviousSection]
            case 1...8:
                array += [index.previousItemAndSection, index.nextItemPreviousSection]
            case 9:
                array += [index.previousItemAndSection]
            default:
                return array
            }
        default:
            return array
        }
        return array
    }
    
    private func didLockedModels(at indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            var model = self.cellModels[indexPath.section][indexPath.item]
            if self.lockedPoints.contains(indexPath) {
                model.type = .miss
            } else {
                model.type = .empty
            }
            self.cellModels[indexPath.section][indexPath.item] = model
        }
        
    }
    
    //MARK:
    //MARK: - NSCollectionViewDataSource
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return self.cellModels.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellModels[section].count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let model = self.cellModels[indexPath.section][indexPath.item]
        let item = collectionView.makeItem(withIdentifier: Config.poligonCellIdentifier, for: indexPath) as! PoligonCell
        item.fill(with: model)
        
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        if let indexPath = indexPaths.first {
            if !self.lockedPoints.contains(where: { $0.section == indexPath.section && $0.item == indexPath.item }) {
                self.selectModel(at: indexPath)
                collectionView.reloadData()
            }
        }
    }
    
}
