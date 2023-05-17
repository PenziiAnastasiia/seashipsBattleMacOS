import Foundation

extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        _ = self.firstIndex(of: object)
            .map { index in
                self.remove(at: index)
            }
    }
    
    func object(at index: Int) -> Element? {
        return index < self.count ? self[index] : nil
    }
}
