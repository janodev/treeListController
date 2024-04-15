import Foundation

/// Node model of a tree structure.
struct TreeNode: Hashable, Sendable {
    let id = UUID()
    let name: String
    var children: [TreeNode]?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        return lhs.id == rhs.id
    }
}
