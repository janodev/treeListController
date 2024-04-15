import Combine
import Foundation

final class ItemProvider {
    var itemsPublisher = PassthroughSubject<[TreeNode], Never>()

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateItems),
            name: .init("ItemProviderUpdated"),
            object: nil
        )
        sendInitialItems()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func sendInitialItems() {
        updateItems()
    }

    @objc func updateItems() {
        let newItems = fetchItems()
        itemsPublisher.send(newItems)
    }

    private func fetchItems() -> [TreeNode] {
        sampleTreeNodes
    }
}
