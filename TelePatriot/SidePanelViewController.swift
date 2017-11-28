//
//  SidePanelViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/22/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

class SidePanelViewController: UIViewController, AccountStatusEventListener {
    
    var tableView : UITableView?
    
    var menuItems = [[MenuItem]]()
    var sections = [String]()
    
    // see ContainerViewController.addChildSidePanelController()
    var delegate: SidePanelViewControllerDelegate?
    
    
    
    enum CellIdentifiers {
        static let thecell = "thecell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenForAccountStatusEvents()
        
        tableView = UITableView(frame: self.view.bounds, style: .plain) // <--- this turned out to be key
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(MenuCell.self, forCellReuseIdentifier: "thecell")
        self.view.addSubview(tableView!)
        
        
        // even though we listen for role-added and role-removed events above
        // in listenForAccountStatusEvents(), the listener is
        // registered too late for the initial creation of the menu
        // So manually go through the roles here and turn menu items on/off
        if(!TPUser.sharedInstance.isVolunteer) {
            menuItems[0].remove(at: 0)
        }
        
        if(!TPUser.sharedInstance.isDirector) {
            menuItems[0].remove(at: 1)
        }
        
        if(!TPUser.sharedInstance.isAdmin) {
            menuItems[0].remove(at: 2)
        }
    }
    
    func insert(item: MenuItem, at: Int) {
        menuItems[0].insert(item, at: at)
        let insertionIndexPath = IndexPath(row: at, section: 0)
        tableView?.insertRows(at: [insertionIndexPath], with: .automatic)
    }
    
    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = tableView?.indexPath(for: cell) {
            menuItems[0].remove(at: deletionIndexPath.row)
            tableView?.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
        
    }
    
    func listenForAccountStatusEvents() {
        if(TPUser.sharedInstance.accountStatusEventListeners.count == 0
            || !TPUser.sharedInstance.accountStatusEventListeners.contains(where: { String(describing: type(of: $0)) == "SidePanelViewController" })) {
            TPUser.sharedInstance.accountStatusEventListeners.append(self)
        }
    }
    
    // required by AccountStatusEventListener
    func roleAssigned(role: String) {
        if( role == "Volunteer" ) {
            // the & before menuItems is required to pass this list as an "inout" parameter
            // see doRoleAdded() and doRoleRemoved()
            doRoleAdded(role: role, menuText: "My Mission", index: 0, items: menuItems[0])
        }
        if( role == "Director" ) {
            doRoleAdded(role: role, menuText: "Directors", index: 1, items: menuItems[0])
        }
        if( role == "Admin" ) {
            doRoleAdded(role: role, menuText: "Admins", index: 2, items: menuItems[0])
        }
    }
    
    // required by AccountStatusEventListener
    func roleRemoved(role: String) {
        if( role == "Volunteer" ) {
            doRoleRemoved(role: role, menuText: "My Mission", items: menuItems[0])
        }
        if( role == "Director" ) {
            doRoleRemoved(role: role, menuText: "Directors", items: menuItems[0])
        }
        if( role == "Admin" ) {
            doRoleRemoved(role: role, menuText: "Admins", items: menuItems[0])
        }
    }
    
    // Note the inout modifier below - that's how you can modify a list passed to a function
    private func doRoleAdded(role: String, menuText: String, index: Int, items: Array<MenuItem>) {
        let itemText = menuText
        var alreadyGranted = false
        let loop = items
        for mi in loop {
            if(mi.title == itemText) {
                alreadyGranted = true
            }
        }
        if(!alreadyGranted) {
            let theItem = MenuItem(title: itemText)
            self.insert(item: theItem, at: index)
        }
        
    }
    
    // Note the inout modifier below - that's how you can modify a list passed to a function
    private func doRoleRemoved(role: String, menuText: String, items: Array<MenuItem>) {
        // var cell:Cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section))?
        var i = 0
        var found = -1
        var foundCell : UITableViewCell?
        for mi in items {
            if(mi.title == menuText) {
                found = i
                foundCell = tableView?.cellForRow(at: IndexPath(row: found, section: 0))
                break
            }
            i = i + 1
        }
     
        if let fc = foundCell {
            self.deleteCell(cell: fc)
        }
    }
}



// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ct = self.menuItems[section].count 
        return ct
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "thecell", for: indexPath) as! MenuCell
        let sec = indexPath.section
        let row = indexPath.row
        cell.configureCell(menuItems[sec][row])
        //cell.backgroundColor = .red
        //cell.textLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        let ct = self.sections.count
        return ct
    }
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.section][indexPath.row]
        delegate?.didSelectSomething(menuItem: menuItem)
    }
}
