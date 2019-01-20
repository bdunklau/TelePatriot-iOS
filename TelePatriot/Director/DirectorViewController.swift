//
//  DirectorViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/5/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class DirectorViewController: BaseViewController {
    
    var tableView: UITableView?
    var delegate: DirectorViewControllerDelegate?
    
    
    
    let removed : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.textColor = .black
        // this setting, plus the widthAnchor constraint below is how we achieve word wrapping inside the scrollview
        l.numberOfLines = 0
        l.text = "Director features have been moved to CitizenBuilder"
        return l
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let this = self
        
        // TODO this is "transitional" code that shouldn't be around forever
        Database.database().reference().child("administration/configuration").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            if let vals = snapshot.value as? [String:Any] {
                let conf = Configuration(data: vals)
                if conf.getRolesFromCB() {
                    self.tableView?.removeFromSuperview()
                    
                    self.view.addSubview(self.removed)
                    self.removed.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32).isActive = true
                    self.removed.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
                    self.removed.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
                }
                else {
                    self.removed.removeFromSuperview()
                    
                    self.tableView = UITableView(frame: self.view.bounds, style: .plain) // <--- this turned out to be key
                    self.tableView?.delegate = self
                    self.tableView?.dataSource = this
                    self.tableView?.register(MenuCell.self, forCellReuseIdentifier: "thecell")
                    self.view.addSubview(self.tableView!)
                }
            }
            else {
                self.tableView?.removeFromSuperview()
                
                self.view.addSubview(self.removed)
                self.removed.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32).isActive = true
                self.removed.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
                self.removed.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
            }
        })
        
        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = self.view.bounds
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
        return cell
    }

    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
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

