import Combine
import UIKit

/// Hierarchical tree with unlimited depth using collection view.
final class TreeListController: UIViewController {
    typealias Item = TreeNode
    typealias Section = TreeSection
    typealias DS = UICollectionViewDiffableDataSource<Section, Item>
    typealias DSSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>

    private var items = [Item]()
    private let collectionView: UICollectionView
    private let dataSource: DS
    private let itemProvider: ItemProvider
    private var subscriptions: Set<AnyCancellable> = []

    init(itemProvider: ItemProvider) {
        let collectionView = Self.createCollectionView()
        let dataSource = Self.createDataSource(with: collectionView)
        self.itemProvider = itemProvider
        self.collectionView = collectionView
        self.dataSource = dataSource
        collectionView.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - UIViewController

    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = collectionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToItemProvider()
        itemProvider.sendInitialItems()
    }

    // MARK: - Other

    private func subscribeToItemProvider() {
        itemProvider.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] items in
                self?.applySnapshot(treeNodes: items, to: .main)
            })
            .store(in: &subscriptions)
    }

    private static func createCollectionView() -> UICollectionView {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    }

    private static func createDataSource(with collectionView: UICollectionView) -> DS {
        let cellRegistration: CellRegistration = {
            CellRegistration { cell, indexPath, treeNode in
                var config = cell.defaultContentConfiguration()
                config.image = UIImage(systemName: "folder")
                config.imageProperties.tintColor = .systemBlue
                config.text = treeNode.name
                cell.contentConfiguration = config
                // include disclosure indicator for nodes with children
                cell.accessories = treeNode.children != nil ? [.outlineDisclosure()] : []
            }
        }()

        return DS(collectionView: collectionView) { collectionView, indexPath, treeNode -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: treeNode)
        }
    }

    private func applySnapshot(treeNodes: [TreeNode], to section: Section) {
        // reset section
        var snapshot = DSSnapshot()
        snapshot.appendSections([section])
        dataSource.apply(snapshot, animatingDifferences: false)

        // initial snapshot with the root nodes
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<TreeNode>()
        sectionSnapshot.append(treeNodes)

        func addItemsRecursively(_ nodes: [TreeNode], to parent: TreeNode?) {
            nodes.forEach { node in
                // for each node we add its children, then recurse into the children nodes
                if let children = node.children, !children.isEmpty {
                    sectionSnapshot.append(children, to: node)
                    addItemsRecursively(children, to: node)
                }

                // show every node expanded
                sectionSnapshot.expand([node])
            }
        }

        addItemsRecursively(treeNodes, to: nil)
        dataSource.apply(sectionSnapshot, to: section, animatingDifferences: true)
    }
}
