//
//  DirectorViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/5/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

class DirectorViewController: BaseViewController {
    
    var tableView: UITableView?
    var delegate: DirectorActionTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: self.view.bounds, style: .plain) // <--- this turned out to be key
        
        tableView?.delegate = self
        tableView?.dataSource = self
        //tableView?.reloadData()
        tableView?.register(MenuCell.self, forCellReuseIdentifier: "thecell")
        self.view.addSubview(tableView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: Table View Data Source

extension DirectorViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ct = MenuItems.sharedInstance.directorItems[section].count
        return ct
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "thecell", for: indexPath) as! MenuCell
        let sec = indexPath.section
        let row = indexPath.row
        cell.configureCell(MenuItems.sharedInstance.directorItems[sec][row])
        //cell.backgroundColor = .red
        //cell.textLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return "" //self.sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        //let ct = self.sections.count
        return 1 // ct
        
    }
}

// Mark: Table View Delegate

extension DirectorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = MenuItems.sharedInstance.directorItems[indexPath.section][indexPath.row]
        delegate?.didSelectSomething(menuItem: menuItem)
    }
}

