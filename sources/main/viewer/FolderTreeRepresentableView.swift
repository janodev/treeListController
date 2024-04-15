#if os(iOS)
import SwiftUI
import SwiftData

/// Representable wrapper to display TreeListController in SwiftUI.
struct TreeListRepresentableView: UIViewControllerRepresentable {
    typealias UIViewControllerType = TreeListController
    let treeNodes: [TreeNode]

    func makeUIViewController(context: Context) -> TreeListController {
        TreeListController(itemProvider: ItemProvider())
    }

    func updateUIViewController(_ uiViewController: TreeListController, context: Context) {
    }
}

let sampleTreeNodes = [
    TreeNode(name: "Folder 1", children: [
        TreeNode(name: "Subfolder 1-1", children: [
            TreeNode(name: "File 1-1-1"),
            TreeNode(name: "File 1-1-2"),
            TreeNode(name: "Subsubfolder 1-1-1", children: [
                TreeNode(name: "File 1-1-1-1"),
                TreeNode(name: "File 1-1-1-2")
            ])
        ]),
        TreeNode(name: "Subfolder 1-2", children: [
            TreeNode(name: "File 1-2-1"),
            TreeNode(name: "Subsubfolder 1-2-1", children: [
                TreeNode(name: "File 1-2-1-1"),
                TreeNode(name: "File 1-2-1-2", children: [
                    TreeNode(name: "File 1-2-1-2-1")
                ])
            ]),
            TreeNode(name: "File 1-2-2")
        ])
    ]),
    TreeNode(name: "Folder 2", children: [
        TreeNode(name: "Subfolder 2-1"),
        TreeNode(name: "Subfolder 2-2", children: [
            TreeNode(name: "File 2-2-1"),
            TreeNode(name: "File 2-2-2")
        ])
    ]),
    TreeNode(name: "Folder 3", children: [
        TreeNode(name: "Subfolder 3-1", children: [
            TreeNode(name: "Subsubfolder 3-1-1", children: [
                TreeNode(name: "File 3-1-1-1"),
                TreeNode(name: "File 3-1-1-2"),
                TreeNode(name: "Subsubsubfolder 3-1-1-1", children: [
                    TreeNode(name: "File 3-1-1-1-1"),
                    TreeNode(name: "File 3-1-1-1-2")
                ])
            ]),
            TreeNode(name: "File 3-1-2")
        ]),
        TreeNode(name: "File 3-2")
    ])
]

#Preview {
    TreeListRepresentableView(treeNodes: sampleTreeNodes)
}
#endif
