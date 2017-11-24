//
//  SidePanelViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/22/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

class SidePanelViewController: UIViewController {
    
    //@IBOutlet weak var tableView: UITableView!
    var tableView : UITableView?
    //var tableView : MainMenuTableView?
    
    //var menuItems = [MenuItem]()
    var menuItems = [[MenuItem]]()
    var sections = [String]()
    
    var delegate: SidePanelViewControllerDelegate?
    
    //let sections = ["pizza", "deep dish pizza", "calzone"]
    /***
    let items = [["Margarita", "BBQ Chicken", "Pepperoni"], ["sausage", "meat lovers", "veggie lovers"], ["sausage", "chicken pesto", "prawns", "mushrooms"]]
 ****/
    
    
    enum CellIdentifiers {
        static let thecell = "thecell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .plain) // <--- this turned out to be key
        
        
        //let nibName = UINib(nibName: "MenuCell", bundle: nil)
        //tableView?.register(nibName, forCellReuseIdentifier: "thecell")
        
        tableView?.delegate = self
        tableView?.dataSource = self
        //tableView?.reloadData()
        tableView?.register(MenuCell.self, forCellReuseIdentifier: "thecell")
        self.view.addSubview(tableView!)
    }
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ct = self.menuItems[section].count //menuItems.count
        print("rows in section \(section) = \(ct)")
        return ct
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "thecell", for: indexPath) as! MenuCell
        let sec = indexPath.section
        let row = indexPath.row
        cell.configureForMenuItem(menuItems[sec][row])
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
