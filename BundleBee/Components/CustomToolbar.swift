//
//  CustomToolbar.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 29/12/25.
//

import SwiftUI

struct CustomToolbar<ItemOfFirstMenuSection, ItemOfSecondMenuSection>: ToolbarContent
where ItemOfFirstMenuSection: CaseIterable & Identifiable & Equatable,
      ItemOfFirstMenuSection.AllCases: RandomAccessCollection,
      ItemOfFirstMenuSection.ID: StringProtocol,
      ItemOfSecondMenuSection: CaseIterable & Identifiable & Equatable,
      ItemOfSecondMenuSection.AllCases: RandomAccessCollection,
      ItemOfSecondMenuSection.ID: StringProtocol {
    
    private let primaryActionPlacement: ToolbarItemPlacement
    private let secondaryActionPlacement: ToolbarItemPlacement
    
    private let mainActionButtonHelp: String
    private let mainActionButtonDisabled: Bool
    private let mainActionButtonAction: () -> Void
    
    private let selectButtonHelp: String
    private let selectButtonAction: () -> Void
    
    private let menuHelp: String
    private let menuDisabled: Bool
    private let titleOfFirstMenuSection: String
    private let titleOfSecondMenuSection: String
    private let onSelectItemOfFirstMenuSection: ((ItemOfFirstMenuSection) -> Void)?
    private let onSelectItemOfSecondMenuSection: ((ItemOfSecondMenuSection) -> Void)?
    
    private let trashButonHelp: String
    private let trashButtonDisabled: Bool
    private let trashButtonAction: () -> Void
    
    @State private var selectedItemOfFirstMenuSection: ItemOfFirstMenuSection
    @State private var selectedItemOfSecondMenuSection: ItemOfSecondMenuSection

    init(
        primaryActionPlacement: ToolbarItemPlacement = .primaryAction,
        secondaryActionPlacement: ToolbarItemPlacement = .secondaryAction,
        
        mainActionButtonHelp: String,
        mainActionButtonDisabled: Bool = true,
        
        selectButtonHelp: String,
        
        menuHelp: String? = nil,
        menuDisabled: Bool = true,
        
        titleOfFirstMenuSection: String? = nil,
        selectedItemOfFirstMenuSection: ItemOfFirstMenuSection,
        
        titleOfSecondMenuSection: String? = nil,
        selectedItemOfSecondMenuSection: ItemOfSecondMenuSection,

        trashButonHelp: String,
        trashButtonDisabled: Bool = true,
        
        mainActionButtonAction: @escaping () -> Void,
        selectButtonAction: @escaping () -> Void,
        trashButtonAction: @escaping () -> Void,
        
        onSelectItemOfFirstMenuSection: ((ItemOfFirstMenuSection) -> Void)? = nil,
        onSelectItemOfSecondMenuSection: ((ItemOfSecondMenuSection) -> Void)? = nil
    ) {
        self.primaryActionPlacement = primaryActionPlacement
        self.secondaryActionPlacement = secondaryActionPlacement
            
        self.mainActionButtonHelp = mainActionButtonHelp
        self.mainActionButtonDisabled = mainActionButtonDisabled
        self.mainActionButtonAction = mainActionButtonAction
            
        self.selectButtonHelp = selectButtonHelp
        self.selectButtonAction = selectButtonAction
            
        self.menuHelp = menuHelp ?? ""
        self.menuDisabled = menuDisabled
        
        self.titleOfFirstMenuSection = titleOfFirstMenuSection ?? ""
        self._selectedItemOfFirstMenuSection = State(initialValue: selectedItemOfFirstMenuSection)
        self.onSelectItemOfFirstMenuSection = onSelectItemOfFirstMenuSection
        
        self.titleOfSecondMenuSection = titleOfSecondMenuSection ?? ""
        self._selectedItemOfSecondMenuSection = State(initialValue: selectedItemOfSecondMenuSection)
        self.onSelectItemOfSecondMenuSection = onSelectItemOfSecondMenuSection

        self.trashButonHelp = trashButonHelp
        self.trashButtonDisabled = trashButtonDisabled
        self.trashButtonAction = trashButtonAction
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: primaryActionPlacement) {
            Button {
                trashButtonAction()
            } label: {
                Image(systemName: "trash")
            }
            .disabled(trashButtonDisabled)
            .help(trashButonHelp)
            
        }
        
        ToolbarItemGroup(placement: secondaryActionPlacement) {
            HStack {
                Button {
                    selectButtonAction()
                } label: {
                    Image(systemName: "doc.badge.plus")
                }
                .help(selectButtonHelp)
                
                Menu {
                    Section(titleOfFirstMenuSection) {
                        ForEach(ItemOfFirstMenuSection.allCases) { item in
                            Button {
                                selectedItemOfFirstMenuSection = item
                                onSelectItemOfFirstMenuSection?(item)
                            } label: {
                                // TODO: Alinhar os textos
                                HStack {
                                    if selectedItemOfFirstMenuSection == item {
                                        Image(systemName: "checkmark")
                                    }
                                    
                                    Text(item.id)
                                }
                            }
                        }
                    }
                    
                    Section(titleOfSecondMenuSection) {
                        ForEach(ItemOfSecondMenuSection.allCases) { item in
                            Button {
                                selectedItemOfSecondMenuSection = item
                                onSelectItemOfSecondMenuSection?(item)
                            } label: {
                                HStack {
                                    if selectedItemOfSecondMenuSection == item {
                                        Image(systemName: "checkmark")
                                    }
                                    
                                    Text(item.id)
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .disabled(menuDisabled)
                .help(menuHelp)
            }
            
            Button {
                mainActionButtonAction()
            } label: {
                Image(systemName: "doc.zipper")
            }
            .disabled(mainActionButtonDisabled)
            .help(mainActionButtonHelp)
        }
    }
}
