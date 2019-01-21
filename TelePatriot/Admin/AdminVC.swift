//
//  AdminVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/24/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class AdminVC: BaseViewController {
    
    var adminDelegate : AdminDelegate?
    
    
    let unassignedUsersButton : BaseButton = {
        let button = BaseButton(text: "Unassigned Users")
        button.translatesAutoresizingMaskIntoConstraints = false // <-- pretty much always do this
        button.addTarget(self, action: #selector(unassignedUsers), for: .touchUpInside)
        return button
    }()
    
    let searchUsersButton : BaseButton = {
        let button = BaseButton(text: "Search Users")
        button.translatesAutoresizingMaskIntoConstraints = false // <-- pretty much always do this
        button.addTarget(self, action: #selector(searchUsers), for: .touchUpInside)
        return button
    }()
    
    
    let removed : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.textColor = .black
        // this setting, plus the widthAnchor constraint below is how we achieve word wrapping inside the scrollview
        l.numberOfLines = 0
        l.text = "Admin features have been moved to CitizenBuilder"
        return l
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // TODO this is "transitional" code that shouldn't be around forever
        Database.database().reference().child("administration/configuration").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            if let vals = snapshot.value as? [String:Any] {
                let conf = Configuration(data: vals)
                if conf.getRolesFromCB() {
                    self.unassignedUsersButton.removeFromSuperview()
                    self.searchUsersButton.removeFromSuperview()
                    
                    self.view.addSubview(self.removed)
                    self.removed.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32).isActive = true
                    self.removed.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
                    self.removed.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
                }
                else {
                    self.removed.removeFromSuperview()
                    
                    self.view.addSubview(self.unassignedUsersButton)
                    self.unassignedUsersButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    self.unassignedUsersButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -72).isActive = true
                    
                    self.view.addSubview(self.searchUsersButton)
                    self.searchUsersButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    self.searchUsersButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 72).isActive = true
                    
                }
            }
            else {
                self.unassignedUsersButton.removeFromSuperview()
                self.searchUsersButton.removeFromSuperview()
                
                self.view.addSubview(self.removed)
                self.removed.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32).isActive = true
                self.removed.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
                self.removed.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
            }
        })
        
    }
    
    
    @objc func unassignedUsers(_ sender: Any) {
        
        adminDelegate?.gotoUnassignedUsers()
    }
    
    
    @objc func searchUsers(_ sender: Any) {
        // adminDelegate is probably CenterViewController
        adminDelegate?.gotoSearchUsers()
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

protocol AdminDelegate {
    func gotoUnassignedUsers()
    func gotoSearchUsers()
}
