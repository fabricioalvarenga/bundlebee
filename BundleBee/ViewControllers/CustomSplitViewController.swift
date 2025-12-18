//
//  CustomSplitViewController.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import AppKit

class CustomSplitViewController: NSSplitViewController {
    override func viewDidAppear() {
        super.viewDidAppear()
        
        let toolbar = NSToolbar(identifier: "MainToolbar")
        toolbar.delegate = self
        toolbar.displayMode = .iconOnly
        
        if let window = view.window {
            window.toolbar = toolbar
            window.toolbarStyle = .unifiedCompact
        }
    }
}

extension CustomSplitViewController: NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        if itemIdentifier == .toggleSidebar {
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.label = "Toogle Sidebar"
            item.paletteLabel = "Toogle Sidebar"
            item.toolTip = "Toogle Sidebar"
            item.isBordered = true
            item.image = NSImage(systemSymbolName: "sidebar.left", accessibilityDescription: "Sidebar")
            item.target = self
            item.action = #selector(toggleSidebar(_:))
            return item
        }
        
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.toggleSidebar, .sidebarTrackingSeparator]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.toggleSidebar, .sidebarTrackingSeparator]
    }
}
