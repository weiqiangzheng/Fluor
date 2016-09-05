//
//  RulesEditorWindowController.swift
//  Fluor
//
//  Created by Pierre TACCHI on 04/09/16.
//  Copyright © 2016 Pyrolyse. All rights reserved.
//

import Cocoa

class RulesTableItem: NSObject {
    let id: String
    let url: URL
    let icon: NSImage
    let name: String
    var behavior: Int {
        didSet {
            let info = StatusMenuController.behaviorDidChangeUserInfoConstructor(id: id, url: url, behavior: AppBehavior(rawValue: behavior + 1)!)
            let not = Notification(name: Notification.Name.BehaviorDidChangeForApp, object: self, userInfo: info)
            NotificationCenter.default.post(not)
        }
    }
    
    init(id: String, url: URL, icon: NSImage, name: String, behavior: Int) {
        self.id = id
        self.url = url
        self.icon = icon
        self.name = name
        self.behavior = behavior
    }
}

class RulesEditorWindowController: NSWindowController, NSTableViewDataSource {
    @IBOutlet weak var tableView: NSTableView!
    
    private var rulesArray = [RulesTableItem]()

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.setFrameAutosaveName("EditRulesWindowAutosaveName")
    }
    
    func loadData() {
        loadRules()
        tableView.reloadData()
    }
    
    private func loadRules() {
        var rules = BehaviorManager.default.retrieveRules()
        rules.sort { $0.name < $1.name }
        rulesArray = rules
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return rulesArray.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return rulesArray[row]
    }
    
    @IBAction func behaviorChange(_ sender: NSSegmentedControl) {
        tableView.row(for: sender)
    }
}
