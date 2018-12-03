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
    var sidePanelDelegate: SidePanelViewControllerDelegate?
    var menuController: MenuController? // my own kind of delegate, a handle to ContainerViewController
                                        // defined at the bottom of this class
                                        // assigned in AppDelegate:  leftViewController?.menuController = containerViewController
    
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
    
    let about_label : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
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
        
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
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
        
        let labelView: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        headerView.addSubview(labelView)
        tableView?.tableHeaderView = headerView
        tableView?.tableHeaderView?.frame.size.height = cos_logo.frame.size.height
        let footerView: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        footerView.addSubview(about_label)
        about_label.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 8).isActive = true
        about_label.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: 0).isActive = true
        tableView?.tableFooterView = footerView
        
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(MenuCell.self, forCellReuseIdentifier: "thecell")
        self.view.addSubview(tableView!)
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            print("\(version) - \(build)")
            about_label.text = "TelePatriot version \(version) (\(build))"
        }
        
        // even though we listen for role-added and role-removed events above
        // in listenForAccountStatusEvents(), the listener is
        // registered too late for the initial creation of the menu
        // So manually go through the roles here and turn menu items on/off

        // But you can't just assume that 'menuItems' has a certain number of items
        // or what item is in a particular position in the array.  The 0th element
        // might not be "My Mission" - it could be "Directors" or "Admins"
        if(!TPUser.sharedInstance.isVolunteer) {
            removeItem(items: &menuItems[0], text: "My Mission")
        }
        
        if(!TPUser.sharedInstance.isDirector) {
            removeItem(items: &menuItems[0], text: "Directors")
        }
        
        if(!TPUser.sharedInstance.isAdmin) {
            removeItem(items: &menuItems[0], text: "Admins")
        }
        
        if(!TPUser.sharedInstance.isVideoCreator) {
            removeItem(items: &menuItems[1], text: "Video Chat")
            removeItem(items: &menuItems[1], text: "Video Offers")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = self.view.frame // here's the magic right here
    }
    
    func putTheCorrectStuffInThisView(user: TPUser) {
        usernameLabel.text = TPUser.sharedInstance.getName()
        emailLabel.text = TPUser.sharedInstance.getEmail()
        let picUrl = TPUser.sharedInstance.getPhotoURL().absoluteString
        profilePic.image(fromUrl: picUrl)
        
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
    
    func deleteCell(cell: UITableViewCell, section: Int) {
        if let deletionIndexPath = tableView?.indexPath(for: cell) {
            menuItems[section].remove(at: deletionIndexPath.row);
            print("delete cell = \(cell.textLabel): deletionIndexPath.row = \(deletionIndexPath.row)")
            //tableView?.deleteRows(at: [deletionIndexPath], with: .automatic)
            tableView?.reloadData()
        }
        
    }
    
    // There's a note above about this method.  Worth reading.
    // Also we are basically doing this same thing in CenterViewController.checkLoggedIn()
    // Given that this method won't add this class a second time, I don't see why we even need this function
    // We might - would have to experiment with commenting it out above.  Still, seems pointless to call this above
    func listenForAccountStatusEvents() {
        if(TPUser.sharedInstance.accountStatusEventListeners.count == 0
            || !TPUser.sharedInstance.accountStatusEventListeners.contains(where: { String(describing: type(of: $0)) == "SidePanelViewController" })) {
            TPUser.sharedInstance.accountStatusEventListeners.append(self)
        }
    }
    
    // See TPUser.fetchRoles()
    // required by AccountStatusEventListener
    func roleAssigned(role: String) {
        if( role == "Volunteer" ) {
            // the & before menuItems is required to pass this list as an "inout" parameter
            // see doRoleAdded() and doRoleRemoved()
            //doRoleAdded(role: role, menuText: "My Mission", index: 0, items: menuItems[0])
            doRoleAdded(menuText: "My Mission", section: 0)//items: menuItems[0])
        }
        if( role == "Director" ) {
            //doRoleAdded(role: role, menuText: "Directors", index: 1, items: menuItems[0])
            doRoleAdded(menuText: "Directors", section: 0)//items: menuItems[0])
        }
        if( role == "Admin" ) {
            //doRoleAdded(role: role, menuText: "Admins", index: 2, items: menuItems[0])
            doRoleAdded(menuText: "Admins", section: 0)//items: menuItems[0])
        }
        if( role == "Video Creator" ) {
            doRoleAdded(menuText: "Video Chat", section: 1)//items: menuItems[0])
            doRoleAdded(menuText: "Video Offers", section: 1)//items: menuItems[0])
        }
    }
    
    // See TPUser.fetchRoles()
    // required by AccountStatusEventListener
    func roleRemoved(role: String) {
        if( role == "Volunteer" ) {
            doRoleRemoved(menuText: "My Mission", section: 0)//items: menuItems[0])
        }
        if( role == "Director" ) {
            doRoleRemoved(menuText: "Directors", section: 0)//items: menuItems[0])
        }
        if( role == "Admin" ) {
            doRoleRemoved(menuText: "Admins", section: 0)//items: menuItems[0])
        }
        if( role == "Video Creator" ) {
            doRoleRemoved(menuText: "Video Chat", section: 1)//items: menuItems[0])
            doRoleRemoved(menuText: "Video Offers", section: 1)//items: menuItems[0])
        }
    }
    
    // required by AccountStatusEventListener
    func allowed() {
        // need to do anything here?  If not, code smell
    }
    
    // required by AccountStatusEventListener
    func notAllowed() {
        // need to do anything here?  If not, code smell
    }
    
    // required by AccountStatusEventListener
    func accountEnabled() {
        // need to do anything here?  If not, code smell
    }
    
    // required by AccountStatusEventListener
    func accountDisabled() {
        // need to do anything here?  If not, code smell
    }
    
    // whileLoggingIn: If the team is selected by virtue of simply logging in,
    // we won't call menuController?.slideOutLeftMenu().  We only call menuController?.slideOutLeftMenu()
    // when the user has manually changed teams.  We want to provide a visual confirmation to the user
    // when he changes teams.  That visual confirmation comes in the form the left menu that slides out
    // to show the user what the new current team.  But we don't want to slide this menu out when the user is
    // just logging in.  For one thing, it is screwing up the creation of the other role menu items.
    func teamSelected(team: TeamIF, whileLoggingIn: Bool) {
        if let teamName = team.getName() {
            menuItems[0][0].title = "Team: "+teamName
            tableView?.reloadData()
        }
        
        // Set in AppDelegate.application()
        // The thing is, we don't want this function called when the user is logging in
        // But we DO want it called every other time the user changes his current_team
        if(!whileLoggingIn) {
            menuController?.slideOutLeftMenu()
        }
    }
    
    // required by AccountStatusEventListener
    func userSignedOut() {
        let teamItem = menuItems[0][0]
        
        // why were we doing this?
        menuItems[0].removeAll()
        menuItems[0].insert(teamItem, at: 0)
        tableView?.reloadData()
    }
    
    // WHY DO WE NEED 'index' ?  AREN'T WE JUST ADDING WHATEVER ITEM TO THE END OF THE LIST
    // REGARDLESS OF HOW BIG THE LIST IS?  (I think so)
//    private func doRoleAdded(menuText: String, items: Array<MenuItem>) {
//        let itemText = menuText
//        var alreadyGranted = false
//        let loop = items
//        for mi in loop {
//            if(mi.title == itemText) {
//                alreadyGranted = true
//            }
//        }
//        if(!alreadyGranted) {
//            guard let theItem = MenuItems.getItem(withText: itemText) else { //MenuItem(title: itemText)
//                // TODO this is a problem - no error handling here
//                return
//            }
//            guard menuItems.count > 0 else { return }
//            menuItems[0].append(theItem)
//            tableView?.reloadData()
//        }
//
//    }
    
    // required by AccountStatusEventListener
    private func doRoleAdded(menuText: String, section: Int) {
        let itemText = menuText
        var alreadyGranted = false
        let loop = menuItems[section]
        for mi in loop {
            if(mi.title == itemText) {
                alreadyGranted = true
            }
        }
        if(!alreadyGranted) {
            guard let theItem = MenuItems.getItem(withText: itemText) else { //MenuItem(title: itemText)
                // TODO this is a problem - no error handling here
                return
            }
            guard menuItems.count > 0 else { return }
            menuItems[section].append(theItem)
            tableView?.reloadData()
        }
        
    }
    
//    private func doRoleRemoved(menuText: String, items: Array<MenuItem>) {
//        // var cell:Cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section))?
//        var i = 0
//        var found = -1
//        var foundCell : UITableViewCell?
//        for mi in items {
//            if(mi.title == menuText) {
//                found = i
//                // We either need to put the Video Chat menu item in section 0, or replace the
//                // hard-coded 0 below with a variable and then figure out what section the removed menu item is in
//                foundCell = tableView?.cellForRow(at: IndexPath(row: found, section: 0))
//                break
//            }
//            i = i + 1
//        }
//
//        if let fc = foundCell {
//            self.deleteCell(cell: fc)
//        }
//    }
    
    // required by AccountStatusEventListener
    private func doRoleRemoved(menuText: String, section: Int) {
        // var cell:Cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section))?
        var i = 0
        var found = -1
        var foundCell : UITableViewCell?
        let items = menuItems[section]
        for mi in items {
            if(mi.title == menuText) {
                found = i
                // We either need to put the Video Chat menu item in section 0, or replace the
                // hard-coded 0 below with a variable and then figure out what section the removed menu item is in
                foundCell = tableView?.cellForRow(at: IndexPath(row: found, section: section))
                break
            }
            i = i + 1
        }
        
        if let fc = foundCell {
            self.deleteCell(cell: fc, section: section)
        }
    }
    
    // required by AccountStatusEventListener
    func videoInvitationExtended(vi: VideoInvitation) {
        // do anything?
    }
    
    // required by AccountStatusEventListener
    func videoInvitationRevoked() {
        // do anything?
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
        sidePanelDelegate?.didSelectSomething(menuItem: menuItem)
    }
    
    // sets the color of the section headings
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.darkGray
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
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
    
    // made this just for legislators so I could play around with their images without
    // impacting the user's profile pic.  Once I get this working, I can consolidate these methods
    public func legislatorImage(fromUrl urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let theTask = URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let response = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: response)?.resizedImageForLegislators(newSize: CGSize(width: 50, height: 50))
                }
            }
        }
        theTask.resume()
    }
}


// source:  http://samwize.com/2016/06/01/resize-uiimage-in-swift/
extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImageForLegislators(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        let originalSize = self.size
        let targetSize = CGSize(width:100, height:100)
        let widthRatio = targetSize.width / originalSize.width
        let heightRatio = targetSize.height / originalSize.height
        var newSize:CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: originalSize.width * heightRatio, height: originalSize.height * heightRatio)
        }
        else {
            newSize = CGSize(width: originalSize.width * widthRatio, height: originalSize.height * widthRatio)
        }
        
        // Notice how the rect below is newSize.height tall
        // But the UIGraphicsBeginImageContextWithOptions is init-ed with height that
        // is only 80% of newSize.height
        let newSize2 = CGSize(width: newSize.width, height: newSize.height * 0.8) // <-- this fraction is the magic part, it's what crops off the bottom!
        
        // preparing rect for new image size
        let rect = CGRect(x:0, y:0, width:newSize.width, height: newSize.height)
        
        //actually do the resizing to the rect using the ImageContext stuff
        //UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        UIGraphicsBeginImageContextWithOptions(newSize2, false, UIScreen.main.scale)
        self.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.circle
    }
    
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

protocol MenuController {
    func slideOutLeftMenu()
}
