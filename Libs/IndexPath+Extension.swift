import Foundation

extension IndexPath {
    var previousItemAndSection: IndexPath {
        IndexPath(item: self.item - 1, section: self.section - 1)
    }
    
    var nextItemAndSection: IndexPath {
        IndexPath(item: self.item + 1, section: self.section + 1)
    }
    
    var previousItemNextSection: IndexPath {
        IndexPath(item: self.item - 1, section: self.section + 1)
    }
    
    var nextItemPreviousSection: IndexPath {
        IndexPath(item: self.item + 1, section: self.section - 1)
    }
    
    var aslantElements: [IndexPath] {
        [previousItemAndSection, previousItemNextSection, nextItemAndSection, nextItemPreviousSection]
    }
    
    public func add(item: Int) -> IndexPath {
        IndexPath(item: self.item + item, section: self.section)
    }
    
    public func add(section: Int) -> IndexPath {
        IndexPath(item: self.item, section: self.section + section)
    }
}
