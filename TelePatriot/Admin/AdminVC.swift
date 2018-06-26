//
//  AdminVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/24/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit

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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(unassignedUsersButton)
        unassignedUsersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        unassignedUsersButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -72).isActive = true
        
        view.addSubview(searchUsersButton)
        searchUsersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchUsersButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 72).isActive = true
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
