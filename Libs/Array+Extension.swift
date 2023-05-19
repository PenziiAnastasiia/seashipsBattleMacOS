import Foundation

extension Array where Element: Equatable {
    @discardableResult
    mutating func remove(object: Element) -> Element? {
        self.firstIndex(of: object)
            .map { index in
                self.remove(at: index)
            }
    }
    
    func object(at index: Int) -> Element? {
        return index < self.count ? self[index] : nil
    }
}
