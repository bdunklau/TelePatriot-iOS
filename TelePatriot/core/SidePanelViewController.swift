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
    
    let cos_logo : UIImageView = {
        let image = UIImage(named: "coslogo")!
        let imageView = UIImageView(image: image)
        //imageView.translatesAutoresizingMaskIntoConstraints = false // this is the one time we don't need this.  Makes it so the image fills the table header
        return imageView
    }()
    
    let profilePic : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    enum CellIdentifiers {
        static let thecell = "thecell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenForAccountStatusEvents()
        
        tableView = UITableView(frame: self.view.bounds, style: .plain) // <--- this turned out to be key
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none // I didn't like the gray separators lines in the slide-out menu
        
        var headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        //var imageView: UIImageView = UIImageView(frame: frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        headerView.addSubview(cos_logo)
        
        headerView.addSubview(profilePic)
        let picUrl = TPUser.sharedInstance.getPhotoURL().absoluteString
        profilePic.image(fromUrl: picUrl)
        profilePic.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8).isActive = true
        profilePic.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8).isActive = true
        
        emailLabel.text = TPUser.sharedInstance.getEmail()
        headerView.addSubview(emailLabel)
        emailLabel.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 8).isActive = true
        emailLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8).isActive = true
        
        usernameLabel.text = TPUser.sharedInstance.getName()
        headerView.addSubview(usernameLabel)
        usernameLabel.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 8).isActive = true
        usernameLabel.bottomAnchor.constraint(equalTo: emailLabel.topAnchor, constant: 0).isActive = true
        
        
        
        var labelView: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        headerView.addSubview(labelView)
        tableView?.tableHeaderView = headerView
        tableView?.tableHeaderView?.frame.size.height = cos_logo.frame.size.height
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(MenuCell.self, forCellReuseIdentifier: "thecell")
        self.view.addSubview(tableView!)
        
        
        // even though we listen for role-added and role-removed events above
        // in listenForAccountStatusEvents(), the listener is
        // registered too late for the initial creation of the menu
        // So manually go through the roles here and turn menu items on/off

        // But you can't just assume that 'menuItems' has a certain number of items
        // or what item is in a particular position in the array.  The 0th element
        // might not be "My Mission" - it could be "Directors" or "Admins"
        if(!TPUser.sharedInstance.isVolunteer) {
            removeItem(items: &menuItems[0], text: "My Mission")
            //menuItems[0].remove(at: 0)
        }
        
        if(!TPUser.sharedInstance.isDirector) {
            removeItem(items: &menuItems[0], text: "Directors")
            //menuItems[0].remove(at: 1)
        }
        
        if(!TPUser.sharedInstance.isAdmin) {
            removeItem(items: &menuItems[0], text: "Admins")
            //menuItems[0].remove(at: 2)
        }
    }
    
    private func removeItem(items: inout [MenuItem], text: String) {
        var i = 0
        var found = -1
        for item in items {
            if item.title == text {
                found = i
                break
            }
            i = i + 1
        }
        if found != -1 {
            items.remove(at: found)
        }
    }
    
    func insert(item: MenuItem, at: Int) {
        guard menuItems.count > 0 else { return }
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


// source:  http://www.andrewkouri.com/swift-3-extension-to-uiimage-to-quickly-retrieve-image-from-a-url/
extension UIImageView {
    public func image(fromUrl urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let theTask = URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let response = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: response)?.resizedImage(newSize: CGSize(width: 50, height: 50))
                }
            }
        }
        theTask.resume()
    }
}


// source:  http://samwize.com/2016/06/01/resize-uiimage-in-swift/
extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage.circle // note the extension further down
    }
    
    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
    
}


// source  https://www.reddit.com/r/swift/comments/3hjc0t/how_to_create_circular_images_for_a_profile/
extension UIImage {
    var circle: UIImage {
        let square = size.width < size.height ? CGSize(width: size.width, height: size.width) : CGSize(width: size.height, height: size.height)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}
