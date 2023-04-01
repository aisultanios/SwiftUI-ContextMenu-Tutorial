//
//  ContextMenuWithPreview.swift
//  ContextMenuTutorial
//
//  Created by Aisultan Askarov on 11.03.2023.
//

import SwiftUI

// MARK: - Custom Menu Context Implementation
struct PreviewContextMenu<Content: View> {
    let size: CGSize
    var color: Binding<Color>
    var text: Binding<String>
    let destination: Content
    let actionProvider: UIContextMenuActionProvider?
    
    init(size: CGSize, color: Binding<Color>, text: Binding<String>, destination: Content, actionProvider: UIContextMenuActionProvider? = nil) {
        self.size = size
        self.destination = destination
        self.actionProvider = actionProvider
        self.color = color
        self.text = text
    }
}

// UIView wrapper with UIContextMenuInteraction
struct PreviewContextView<Content: View>: UIViewRepresentable {
    
    let menu: PreviewContextMenu<Content>
    let didCommitView: () -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        let menuInteraction = UIContextMenuInteraction(delegate: context.coordinator)
        view.addInteraction(menuInteraction)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(menu: self.menu, didCommitView: self.didCommitView)
    }
    
    class Coordinator: NSObject, UIContextMenuInteractionDelegate {
        
        let menu: PreviewContextMenu<Content>
        let didCommitView: () -> Void
                
        init(menu: PreviewContextMenu<Content>, didCommitView: @escaping () -> Void) {
            self.menu = menu
            self.didCommitView = didCommitView
        }
                
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
            let previewProvider: () -> UIViewController? = {
                let viewController = UIHostingController(rootView: self.menu.destination)
                viewController.preferredContentSize = self.menu.size
                return viewController
            }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: previewProvider, actionProvider: self.menu.actionProvider)
        }
        
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
            animator.addCompletion(self.didCommitView)
        }
        
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
            let parameters = UIPreviewParameters()
            parameters.backgroundColor = .clear
            return UITargetedPreview(view: interaction.view!, parameters: parameters)
        }

        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForDismissingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
            let parameters = UIPreviewParameters()
            parameters.backgroundColor = .clear
            return UITargetedPreview(view: interaction.view!, parameters: parameters)
        }
        
    }
}

// Add context menu modifier
extension View {
    func contextMenu<Content: View>(_ menu: PreviewContextMenu<Content>) -> some View {
        self.modifier(PreviewContextViewModifier(menu: menu))
    }
}

struct PreviewContextViewModifier<V: View>: ViewModifier {

    let menu: PreviewContextMenu<V>
    @Environment(\.presentationMode) var mode
    
    @State var isActive: Bool = false
    
    func body(content: Content) -> some View {
        Group {
            if isActive {
                menu.destination
            } else {
                content.overlay(PreviewContextView(menu: menu, didCommitView: { self.isActive = true }))
            }
        }
    }
}
