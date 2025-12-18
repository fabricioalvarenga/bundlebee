//
//  ContentView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct ContentView: NSViewControllerRepresentable {
    @EnvironmentObject var appState: AppState
    
    func makeNSViewController(context: Context) -> CustomSplitViewController {
        let splitVC = CustomSplitViewController()
        
        splitVC.splitView.dividerStyle = .thin
        
        let sidebarItem = NSSplitViewItem(sidebarWithViewController: NSHostingController(
            rootView: SidebarView().environmentObject(appState)))
        sidebarItem.canCollapse = true
        sidebarItem.minimumThickness = 200
        sidebarItem.maximumThickness = 250
        sidebarItem.holdingPriority = .defaultLow + 1
        
        let contentItem = NSSplitViewItem(viewController: NSHostingController(
            rootView: MainContentView().environmentObject(appState)))
        contentItem.canCollapse = false
        contentItem.holdingPriority = .defaultLow
        
        splitVC.addSplitViewItem(sidebarItem)
        splitVC.addSplitViewItem(contentItem)
        
        return splitVC
    }
    
    func updateNSViewController(_ nsViewController: CustomSplitViewController, context: Context) {
    }
}
