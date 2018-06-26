//
//  CenterViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/22/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabaseUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FBSDKCoreKit
import FBSDKLoginKit

class CenterViewController: BaseViewController, FUIAuthDelegate {
    
    // centerViewController.delegate = self  (from ContainerViewController)
    var delegate: CenterViewControllerDelegate?
    
    var byPassLogin : Bool = false
    
    let logo : UIImageView = {
        let img = UIImage(named: "splashscreen_image.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let getStartedButton : BaseButton = {
        let button = BaseButton(text: "Get Started")
        button.titleLabel?.font = button.titleLabel?.font.withSize(24)
        button.addTarget(self, action: #selector(toggleMainMenu), for: .touchUpInside)
        return button
    }()
    
    
    @objc func toggleMainMenu(_ sender: Any) {
        delegate?.toggleLeftPanel?()
    }
    
    override func viewDidLoad() {
        
        loadSplashscreen()
        
        BackTracker.sharedInstance.setNavigationItem(nav: self.navigationItem, backHandler: self)
        
        
        if(TPUser.sharedInstance.accountStatusEventListeners.count == 0
            || !TPUser.sharedInstance.accountStatusEventListeners.contains(where: { String(describing: type(of: $0)) == "CenterViewController" })) {
            TPUser.sharedInstance.accountStatusEventListeners.append(self)
        } else { print("CenterViewController: NOT adding self to list of accountStatusEventListeners") }
        
        
        // LimboViewController sets this in prepareForSegue
        if(!byPassLogin) {
            checkLoggedIn()
        }
        else {
            // If we're bypassing the login logic, it's because we are coming back to this
            // screen from LimboViewController.  In that case, we don't want to show the back
            // button here.  We don't want the user to be able to go back to that screen.
            
            // https://stackoverflow.com/a/44403725
            //self.navigationItem.hidesBackButton = true
        }
    }
    
    private func loadSplashscreen() {
        self.navigationItem.title = "TelePatriot" // what the user sees (across the top) when they first login
        
        view.addSubview(logo)
        view.addSubview(getStartedButton)
        
        
        logo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 75).isActive = true
        logo.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75).isActive = true
        logo.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
        
        getStartedButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        getStartedButton.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 30).isActive = true
        getStartedButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        getStartedButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
    }
    
    
    // logging in is done here.  Logging out is done in TPUser.signOut()
    func checkLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in
                print(user?.displayName)
                print(user?.email)
                
                // if the user doesn't have any roles assigned yet, send him to the Limbo screen...
                let u = TPUser.sharedInstance
                u.noRoleAssignedDelegate = self
                
                
                
                // need to get handle to SidePanelViewController
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                
                
                // The user object fires roleAssigned() which calls all listeners
                // This call makes this class one of those listeners
                // See also roleAssigned() in this class
                // addLeftPanelViewController()
                if(TPUser.sharedInstance.accountStatusEventListeners.count == 0
                    || !TPUser.sharedInstance.accountStatusEventListeners.contains(where: { String(describing: type(of: $0)) == "SidePanelViewController" })) {
                    TPUser.sharedInstance.accountStatusEventListeners.append((appDelegate?.leftViewController!)!)
                } else { print("SidePanelViewController: NOT adding self to list of accountStatusEventListeners") }
                
                
                
                print("CenterViewController.checkLoggedIn() -----------------")
                // BUG: This setUser() call below has to notify the SidePanelViewController
                u.setUser(u: user)
                
                // for starters, just leave the user here and show the logo and maybe a "Get Started" button
                // that slides out the left menu
                
                
            } else {
                // No user is signed in.
                self.login()
            }
        }
    }
    
    
    // https://www.youtube.com/watch?v=jH2LdL-PsHI
    // https://gist.github.com/caldwbr/5abe2dba3d1c2a6b525e141e7e967ac4
    func login() {
        let authUI = FUIAuth.init(uiWith: Auth.auth())
        
        // This is how you disable sign-in by email.  Uncomment to disable
        authUI?.isSignInWithEmailHidden = true
        
        let googleProvider = FUIGoogleAuth(scopes: ["https://www.googleapis.com/auth/userinfo.email", "https://www.googleapis.com/auth/userinfo.profile"])
        let facebookProvider = FUIFacebookAuth.init(permissions: ["public_profile", "email"])
        authUI?.delegate = self
        authUI?.providers = [googleProvider, facebookProvider]
        
        // from Brian Caldwell YouTube
        /*********/
        let authViewController = MyAuthPicker(authUI: authUI!)
        let navc = UINavigationController(rootViewController: authViewController)
        self.present(navc, animated: true, completion: nil)
         /********/
        /*****
         // This is the old way...  (pre-Jan 2018)
        let authViewController = authUI?.authViewController()  // this is what it was
        self.present(authViewController!, animated: true, completion: nil) // this is what it was
         ******/
    }
    
    
    internal func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if error != nil {
            //Problem signing in
            login()
        } else {
            //User is in! Here is where we code after signing in
            // how do we get the name of the user?
            
            //print("User: "+user!.displayName!)
            //name.text = user!.displayName!
            for pr in authUI.providers {
                print("\(pr.shortName) : accessToken: \(pr.accessToken), idToken: \(pr.idToken)")
            }
            /**
             Now find out if user has any roles yet, or if he has to be sent to the "limbo" screen
             **/
            let u = TPUser.sharedInstance
            u.noRoleAssignedDelegate = self
            u.setUser(u: user)
        }
    }
}

extension CenterViewController : AppDelegateDelegate {
    func show(viewController: UIViewController) {
        doView(vc: viewController, viewControllers: self.childViewControllers)
    }
}

extension CenterViewController: SidePanelViewControllerDelegate, DirectorViewControllerDelegate {
    
    @objc func goBack() {
        /*********
        guard let vc = BackTracker.sharedInstance.onBack() else {
            self.navigationItem.leftBarButtonItem = nil
            return
        }
        doView(vc: vc, viewControllers: self.childViewControllers, track: false)
         **********/
    }
    
    func didSelectSomething(menuItem: MenuItem) {
        
        // sets the title in the navigation bar at the top of each screen
        self.navigationItem.title = menuItem.title
        
        /*********
        if let _ = BackTracker.sharedInstance.last() {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.goBack))
        }
        else {
            self.navigationItem.leftBarButtonItem = nil
        }
         **********/
        
        delegate?.collapseSidePanels?()
        
        // This is where we figure out where to send the user based on the
        // menu item that was just touched
        if(menuItem.title == "Sign Out") {
            TPUser.sharedInstance.signOut()
            // see userSignedOut() below.  We created an extension of this class that implements
            // AccountStatusEventListener because we call TPUser.sharedInstance.signOut() from other
            // places besides just here and we need the UI to be cleared out whenever the logs out
        }
        else if(menuItem.title.starts(with: "My Profile")) {
            guard let vc = delegate?.getMyProfileVC() else { return }
            doView(vc: vc, viewControllers: self.childViewControllers)
        }
        else if(menuItem.title.starts(with: "My Legislators")) {
            guard let vc = delegate?.getMyLegislatorsVC() else { return }
            doView(vc: vc, viewControllers: self.childViewControllers)
        }
        else if(menuItem.title.starts(with: "Team")) {
            //guard let vc = delegate?.getNewPhoneCampaignVC() else { return }
            guard let vc = delegate?.getSwitchTeamsVC() else { return }
            doView(vc: vc, viewControllers: self.childViewControllers)
        }
        else if(menuItem.title == "My Mission") {
            guard let vc = delegate?.getMyMissionViewController() else { return }
            doView(vc: vc, viewControllers: self.childViewControllers)
            //doView(vc: MyMissionViewController(), viewControllers: self.childViewControllers)
        }
        else if(menuItem.title == "Directors") {
            unassignMissionItem()
            // don't instantiate here.  Get from ContainerViewController  ...but how?
            if let directorViewController = delegate?.getDirectorViewController() {
                doView(vc: directorViewController, viewControllers: self.childViewControllers)
            }
        }
        else if(menuItem.title == "Admins") {
            unassignMissionItem()
            guard let vc = delegate?.getAdminVC() else { return }
            doView(vc: vc, viewControllers: self.childViewControllers, track: true)
        }
        else if(menuItem.title == "Share Petition") {
            unassignMissionItem()
            doView(vc:  SharePetitionViewController(), viewControllers: self.childViewControllers)
        }
        else if(menuItem.title == "Video Chat") {
            // delegate is probably ContainerViewController
            guard let vc = delegate?.getVideoChatViewController() else { return }
            doView(vc: vc, viewControllers: self.childViewControllers, track: true)
        }
        else if(menuItem.title == "Video Invitations") {
            // delegate is probably ContainerViewController
            guard let vc = delegate?.getVideoInvitationsViewController() else { return }
            doView(vc: vc, viewControllers: self.childViewControllers, track: true)
        }
        /*********
        else if(menuItem.title == "Chat/Help") {
            doView(name: menuItem.title, vc:  ChatHelpViewController(),, viewControllers: self.childViewControllers)
        }
         **********/
        // Director screen...
        else if(menuItem.title == "New Phone Campaign") {
            //guard let vc = delegate?.getNewPhoneCampaignVC() else { return }
            guard let vc = delegate?.getChooseSpreadsheetTypeVC() else { return }
            doView(vc: vc, viewControllers: self.childViewControllers)
        }
        else if(menuItem.title == "My Active Missions") {
            //doView(vc: Xxxxxxxxxxx(), viewControllers: self.childViewControllers)
        }
        else if(menuItem.title == "All Active Missions") {
            //doView(vc: Xxxxxxxxxxx(), viewControllers: self.childViewControllers)
        }
        else if(menuItem.title == "All My Missions") {
            //doView(vc: Xxxxxxxxxxx(), viewControllers: self.childViewControllers)
        }
        else if(menuItem.title == "All Missions") {
            guard let vc = delegate?.getMissionSummaryTVC() else { return }
            doView(vc: vc, viewControllers: self.childViewControllers)
        }
        else if(menuItem.title == "All Activity") {
            guard let vc = delegate?.getAllActivityVC() else { return }
            doView(vc: vc, viewControllers: self.childViewControllers)
        }
        
    }
    
    func inList(viewControllers: [UIViewController], viewController: UIViewController) -> UIViewController? {
        let vcname = String(describing: type(of: viewController))
        for vc in viewControllers {
            let itername = String(describing: type(of: vc))
            if(itername == vcname) { return vc }
        }
        return nil
    }
    
    private func doView(vc: UIViewController, viewControllers: [UIViewController]) {
        doView(vc: vc, viewControllers: viewControllers, track: false)
    }
    
    private func doView(vc: UIViewController, viewControllers: [UIViewController], track: Bool) {
        guard let viewController = inList(viewControllers: self.childViewControllers, viewController: vc) else {
            // vc not yet a child vc so add it
            addChildViewController(vc)
            delegate?.viewChosen() // sets ContainerViewController.allowPanningFromRightToLeft = false
            self.view.addSubview(vc.view)
            if track { BackTracker.sharedInstance.onChoose(vc: vc) }
            return
        }
        if let myMissionVc = viewController as? MyMissionViewController {
            myMissionVc.myResumeFunction()
        }
        delegate?.viewChosen() // sets ContainerViewController.allowPanningFromRightToLeft = false
        viewController.viewDidLoad() // creative or hacky?  I need to run the code in this function whenever the view becomes visible again
        self.view.bringSubview(toFront: viewController.view)
        if track { BackTracker.sharedInstance.onChoose(vc: vc) }
    }
    
    func doView(vc: UIViewController) {
        doView(vc: vc, viewControllers: self.childViewControllers, track: true)
    }
    
    func doView(vc: UIViewController, track: Bool) {
        doView(vc: vc, viewControllers: self.childViewControllers, track: track)
    }
    
    func unassignMissionItem() {
        TPUser.sharedInstance.unassignCurrentMissionItem()
    }
    
}

extension CenterViewController : NoRoleAssignedDelegate {
    func theUserHasNoRoles() {
        // If you need to test/debug the LimboViewController screen flow, you'll want to comment this line in and out
        // With it commented out, you'll always be sent to the Home screen where you can logout.
        let limboViewController = LimboViewController()
        let navViewController: UINavigationController = UINavigationController(rootViewController: limboViewController)
        self.present(navViewController, animated: true, completion: nil)
    }
}

extension CenterViewController : NewPhoneCampaignSubmittedHandler {
    func newPhoneCampaignSubmitted() {
        guard let vc = delegate?.getMissionSummaryTVC() else { return }
        doView(vc: vc, viewControllers: self.childViewControllers)
    }
}

// CenterViewController is assigned in ContainerViewController.viewDidLoad()
extension CenterViewController : WrapUpViewControllerDelegate {
    
    func missionAccomplished() {
        guard let vc = delegate?.getMyMissionViewController() else { return }
        doView(vc: vc, viewControllers: self.childViewControllers)
    }
    
    // Not sure if I like this idea...  Let's put a viewcontroller inside the mission_item
    // object so the mission_item can direct us to the next screen, either back to My Mission
    // or to My Legislators or to ... ?
    func missionAccomplished(vc: UIViewController) {
        doView(vc: vc, viewControllers: self.childViewControllers)
    }
}

extension CenterViewController : ChooseSpreadsheetTypeDelegate {
    func spreadsheetTypeChosen(missionNode: String) {
        // need to send the spreadsheet type to NewPhoneCampaignVC
        guard let vc = delegate?.getNewPhoneCampaignVC() else { return }
        vc.missionNode = missionNode
        vc.clearFields()
        doView(vc: vc, viewControllers: self.childViewControllers)
    }
}

extension CenterViewController : SwitchTeamsDelegate {
    func teamSelected(team: Team) {
        if let oldteam = TPUser.sharedInstance.getCurrentTeam() {
            if oldteam.team_name != team.team_name {
                unassignMissionItem()
            }
        }
        TPUser.sharedInstance.setCurrentTeam(team: team)
    }
}

// Sends the user to AssignUserVC when he clicks someone from the Unassigned Users
// list on UnassignedUsersVC
extension CenterViewController : UnassignedUsersDelegate {
    func unassignedUserSelected(user: TPUser) {
        /******
         The user could be banned, or maybe hasn't signed the conf agreement.
         We have to know this stuff because if they shouldn't be let in, we need to send them
         to another screen...
         ********/
        
        
        if let is_banned = user.is_banned as? Bool {
            if is_banned {
                guard let vc : UserIsBannedVC = delegate?.getUserIsBannedVC() else { return }
                vc.user = user
                doView(vc: vc, viewControllers: self.childViewControllers, track: true)
                return
            }
            
        }
        
        guard let normalVC = delegate?.getAssignUserVC() else {return}
        //normalVC.uid = user.getUid()
        normalVC.passedInUser = user
        doView(vc: normalVC, viewControllers: self.childViewControllers, track: true)
    }
}


extension CenterViewController : SearchUsersDelegate {
    func userSelected(user: TPUser) {
        // BIG DESIGN FLAW - the AssignUserVC screen is not always the next place we want to go after selecting a user
        guard let normalVC = delegate?.getAssignUserVC() else {return}
        //normalVC.uid = user.getUid()
        normalVC.passedInUser = user
        doView(vc: normalVC, viewControllers: self.childViewControllers, track: true)
    }
}


// Once the user (admin) has assigned the new user to some groups (Admin, Director and/or Volunteer)
// the admin clicks OK which ends up calling this function, which sends the user back to the
// Unassigned Users screen
/**************
extension CenterViewController : AssignUserDelegate {
    func userAssigned(user : TPUser) {
        // go back to the Unassigned User screen
        guard let vc = delegate?.getUnassignedUsersVC() else { return }
        doView(vc: vc, viewControllers: self.childViewControllers)
    }
}
 ***********/

extension CenterViewController : AccountStatusEventListener {
    func roleAssigned(role: String) {
        // stub
    }
    
    func roleRemoved(role: String) {
        // stub
    }
    
    func teamSelected(team: Team, whileLoggingIn: Bool) {
        // stub
    }
    
    func userSignedOut() {
        
        // remove all subviews and child view controllers so that we don't come back to the screen we were on - that's really confusing
        for subview in view.subviews as! [UIView] {
            subview.removeFromSuperview()
        }
        for child in self.childViewControllers as! [UIViewController] {
            child.removeFromParentViewController()
        }
        loadSplashscreen()
    }
}

// AddressUpdater is declared at the bottom of MyLegislatorsVC
// MyLegislatorsVC.addressUpdater is assigned to CenterViewController in ContainerViewController
extension CenterViewController : AddressUpdater {
    func beginUpdatingAddressManually() {
        guard let vc = delegate?.getMyProfileVC() else { return }
        vc.useGPS = false
        doView(vc: vc, viewControllers: self.childViewControllers)
    }
    func beginUpdatingAddressUsingGPS() {
        guard let vc = delegate?.getMyProfileVC() else { return }
        vc.useGPS = true
        doView(vc: vc, viewControllers: self.childViewControllers)
    }
}


extension CenterViewController : AdminDelegate {
    func gotoUnassignedUsers() {
        guard let vc = delegate?.getUnassignedUsersVC() else { return }
        doView(vc: vc, viewControllers: self.childViewControllers, track: true)
    }
    
    func gotoSearchUsers() {
        guard let vc = delegate?.getSearchUsersVC() else { return }
        doView(vc: vc, viewControllers: self.childViewControllers, track: true)
    }
}

extension CenterViewController : BackHandler {
    func goBack(vc: UIViewController, track: Bool) {
        doView(vc: vc, viewControllers: self.childViewControllers, track: track)
    }
}

extension CenterViewController : MissionListDelegate {
    func missionSelected(mission: MissionSummary, team: Team) {
        guard let vc = delegate?.getMissionDetailsVC() else { return }
        vc.mission = mission
        vc.team = team
        doView(vc: vc, viewControllers: self.childViewControllers)
    }
}

extension CenterViewController : MissionDetailsDelegate {
    func missionDeleted(mission: MissionSummary) {
        guard let vc = delegate?.getMissionSummaryTVC() else { return }
        doView(vc: vc, viewControllers: self.childViewControllers)
    }
}

extension CenterViewController : VideoInvitationDelegate {
    func videoInvitationSelected(invitation: [String:Any]) {
        guard let vc = delegate?.getVideoChatViewController(),
            let room_id = invitation["room_id"] as? String
            else { return }
        vc.room_id = room_id
        doView(vc: vc, viewControllers: self.childViewControllers)
    }
}

/******
extension CenterViewController : NoMissionDelegate {
    func notifyNoMissions() {
        guard let vc = delegate?.getNoMissionVC() else {
            return }
        doView(vc: vc, viewControllers: self.childViewControllers)
    }
}
 *******/
