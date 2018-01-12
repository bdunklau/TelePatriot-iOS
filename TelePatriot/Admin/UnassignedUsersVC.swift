//
//  UnassignedUsersVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/19/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import FirebaseDatabase

// modeled after MissionSummaryTVC in iOS and AllActivityFragment in Android
class UnassignedUsersVC: BaseViewController, UITableViewDataSource {
    
    // assigned to CenterViewController in ContainerViewController
    var unassignedUsersDelegate : UnassignedUsersDelegate?
    
    var unassignedUsers = [[String:Any]]()
    
    let cellId = "cellId"
    
    var unassignedUsersTableView: UITableView?
    
    var ref : DatabaseReference?
    
    
    
    let headerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Unassigned Users"
        return label
    }()
    
    let descriptionTextView : UITextView = {
        let textView = UITextView()
        textView.text = "Each of these users needs to be assigned to at least one group.  They have no access to this app until they are assigned to at least one group"
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        //textView.font = UIFont.boldSystemFont(ofSize: textView.font.pointSize) // just example
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        var frame = textView.frame
        frame.size.height = 16
        textView.frame = frame
        
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        ref = Database.database().reference().child("no_roles")
        
        var headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 75))
        headerView.addSubview(headerLabel)
        headerView.addSubview(descriptionTextView)
        
        
        //headerLabel.text = "Mission Description"
        headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8).isActive = true
        headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 24).isActive = true
        headerLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 1).isActive = true
        //descriptionHeaderLabel.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 1).isActive = true
        
        descriptionTextView.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor, constant: 8).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor).isActive = true
        descriptionTextView.widthAnchor.constraint(equalTo: headerLabel
            .widthAnchor, multiplier: 0.95).isActive = true
        
        
        unassignedUsersTableView = UITableView(frame: self.view.bounds, style: .plain) // <--- this turned out to be key
        unassignedUsersTableView?.tableHeaderView = headerView
        unassignedUsersTableView?.tableHeaderView?.frame.size.height = 150
        unassignedUsersTableView?.dataSource = self
        unassignedUsersTableView?.delegate = self
        unassignedUsersTableView?.register(TPUserTableViewCell.self, forCellReuseIdentifier: "cellId")
        unassignedUsersTableView?.rowHeight = 200
        view.addSubview(unassignedUsersTableView!)
        
        
        
        fetchData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func getUserInfo(uid: String, dictionary: [String:Any]) -> [String:Any] {
        
        guard let created = dictionary["created"] as? String,
            let email = dictionary["email"] as? String,
            let name = dictionary["name"] as? String,
            let photoUrl = dictionary["photoUrl"] as? String else {
                return [:]
        }
        
        var has_signed_petition : Bool?
        if let pet = dictionary["has_signed_petition"] as? Bool {
            has_signed_petition = pet
        }
        
        var has_signed_confidentiality_agreement : Bool?
        if let conf = dictionary["has_signed_confidentiality_agreement"] as? Bool {
            has_signed_confidentiality_agreement = conf
        }
        
        var is_banned : Bool?
        if let ban = dictionary["is_banned"] as? Bool {
            is_banned = ban
        }
        
        let unassignedUser = ["uid": uid,
                              "values":["created": created,
                                        "email": email,
                                        "name": name,
                                        "photoUrl": photoUrl,
                                        "has_signed_petition": has_signed_petition,
                                        "has_signed_confidentiality_agreement": has_signed_confidentiality_agreement,
                                        "is_banned": is_banned]
            ]
            as [String : Any]
        
        return unassignedUser
    }
    
    
    func fetchData() {
        
        ref?.observe(.childAdded, with: {(snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any],
                  let uid = snapshot.key as? String else {
                return
            }
            
            let unassignedUser = self.getUserInfo(uid: uid, dictionary: dictionary)
            guard !unassignedUser.isEmpty else { return }
            
            
            // you'll get duplicate/phantom team entries without this.  That's because we explicitly
            // call viewDidLoad() in CenterViewController.doView()
            guard self.findIndex(unassignedUsers: self.unassignedUsers, unassignedUser: unassignedUser) == nil else {
                return
            }
            
            self.unassignedUsers.insert(unassignedUser, at: 0)
            print(unassignedUser)
            DispatchQueue.main.async {
                self.unassignedUsersTableView?.reloadData()
            }
            
            
        }, withCancel: nil)
        
        
        
        ref?.observe(.childChanged, with: {(snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any],
                let uid = snapshot.key as? String else {
                    return
            }
            
            let unassignedUser = self.getUserInfo(uid: uid, dictionary: dictionary)
            guard !unassignedUser.isEmpty else { return }
            
            // we BETTER find this...
            guard let index = self.findIndex(unassignedUsers: self.unassignedUsers, unassignedUser: unassignedUser) else {
                return
            }
            
            self.unassignedUsers[index] = unassignedUser
            DispatchQueue.main.async {
                self.unassignedUsersTableView?.reloadData()
            }
            
        }, withCancel: nil)
        
        
        
        ref?.observe(.childRemoved, with: {(snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any] else {
                return
            }
            
            guard let uid = snapshot.key as? String,
                let created = dictionary["created"] as? String,
                let email = dictionary["email"] as? String,
                let name = dictionary["name"] as? String,
                let photoUrl = dictionary["photoUrl"] as? String else {
                    return
            }
            
            
            let unassignedUser = ["uid": uid, "values":["created": created, "email": email, "name": name, "photoUrl": photoUrl]] as [String : Any]
            
            
            // find the team in the array and remove it
            guard let index = self.findIndex(unassignedUsers: self.unassignedUsers, unassignedUser: unassignedUser) else {
                return
            }
            
            self.unassignedUsers.remove(at: index)
            DispatchQueue.main.async {
                self.unassignedUsersTableView?.reloadData()
            }
        })
    }
    
    func findIndex(unassignedUsers: [[String:Any]], unassignedUser: [String:Any]) -> Int? {
        var i = 0
        for t in self.unassignedUsers {
            if let uid1 = t["uid"] as! String? {
                if let uid2 = unassignedUser["uid"] as! String? {
                    if uid1 == uid2 {
                        return i
                    }
                }
            }
            i = i + 1
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unassignedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = unassignedUsersTableView?.dequeueReusableCell(withIdentifier: "cellId",
                                                          for: indexPath as IndexPath) as! TPUserTableViewCell
        
        
        let unassignedUser = unassignedUsers[indexPath.row]
        cell.commonInit(unassignedUser: unassignedUser, ref: ref!)
        
        return cell
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

// This is what gets called when you click a row in the Unassigned Users table view
extension UnassignedUsersVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unassignedUser = unassignedUsers[indexPath.row]
        // assigned to CenterViewController in ContainerViewController
        unassignedUsersDelegate?.userSelected(user: unassignedUser)
    }
}

protocol UnassignedUsersDelegate {
    func userSelected(user: [String:Any])
}


