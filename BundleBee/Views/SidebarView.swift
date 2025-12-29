//
//  SidebarView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "archivebox.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.blue.gradient)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Archive")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Manager")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            Divider()
                .padding(.vertical, 16)
            
            VStack(spacing: 4) {
                ForEach(TabType.allCases) { tab in
                    SidebarButton(title: tab.id, icon: tab.icon, isSelected: appState.selectedTab == tab) {
                        appState.selectedTab = tab
                    }
                }
            }
            .padding(.horizontal, 8)
            
            Spacer()
        }
        .frame(minWidth: 200)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .controlBackgroundColor))
    }
}
