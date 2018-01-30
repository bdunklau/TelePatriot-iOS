//
//  SearchUsersVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/24/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class SearchUsersVC: UITableViewController, UISearchResultsUpdating {
    
    
    // assigned to CenterViewController in ContainerViewController
    var searchUsersDelegate : SearchUsersDelegate?
    var ref : DatabaseReference?
    var query : DatabaseQuery?
    let cellId = "basicCell"
    var currentSearch : String?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //var users = [[String:Any]]()
    var users = [TPUser]()
    
    override func viewDidLoad() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        tableView?.register(TPUserTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView?.rowHeight = 200
        
        super.viewDidLoad()
        
        query = Database.database().reference().child("users").queryOrdered(byChild: "name")
        
        ref = Database.database().reference().child("users")
        
        if let curr = currentSearch {
            searchController.searchBar.text = curr
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TPUserTableViewCell
        let user = users[indexPath.row]
        cell.commonInit(user: user, ref: ref!)
        
        return cell
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        users.removeAll()
        let newText = "dfgsdfgsdfgsdfgsfdsdg" // so that empty search field won't return anything
        var str = ""
        
        if searchController.searchBar.text == nil ||  searchController.searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            str = newText
        }
        else {
            str = searchController.searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let first_char = str.prefix(1).uppercased()
        let the_rest = str.suffix(str.count-1)
        str = first_char + the_rest
        
        let end = str+"\u{f8ff}"
        
        self.tableView.reloadData()
        
        query?.queryStarting(atValue: str).queryEnding(atValue: end).observe(.childAdded ,with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any],
                let uid = snapshot.key as? String else {
                    return
            }
            
            guard let user = self.getUserObject(uid: uid, dictionary: dictionary) else { return }
            
            // you'll get duplicate/phantom user entries without this.  That's because we explicitly
            // call viewDidLoad() in CenterViewController.doView()
            //guard self.findIndex(users: self.users, user: user) == nil else {
            //    return
            //}
            
            self.users.append(user)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
    }
    
    
    private func getUserObject(uid: String, dictionary: [String:Any]) -> TPUser? {
        let created = TPUser.create(uid: uid, dictionary: dictionary)
        return created
    }
    
    
    // adaptation from UnassignedUsersVC
    func findIndex(users: [TPUser], user: TPUser) -> Int? {
        var i = 0
        for t in self.users {
            if let uid1 = t.getUid() as String? {
                if let uid2 = user.getUid() as String? {
                    if uid1 == uid2 {
                        return i
                    }
                }
            }
            i = i + 1
        }
        return nil
    }
    
    // per UITableViewDelegate - This is what gets called when you click one of the users in the search results
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        // If the user hits "back", this line will preserve the user's last search.  Otherwise the search field will be reset to ""
        currentSearch = searchController.searchBar.text
        
        searchController.searchBar.endEditing(true)
        searchController.isActive = false // without this, the search bar will still be visible on the next screen, when we are looking at a particular user's profile
        // assigned to CenterViewController in ContainerViewController
        searchUsersDelegate?.userSelected(user: user)
    }
}

protocol SearchUsersDelegate {
    func userSelected(user: TPUser)
}
