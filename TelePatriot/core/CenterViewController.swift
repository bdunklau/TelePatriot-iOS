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
import FirebaseUI
//import FirebaseAuthUI
//import FirebaseDatabaseUI
//import FirebaseGoogleAuthUI
//import FirebaseFacebookAuthUI
import FBSDKCoreKit
import FBSDKLoginKit

class CenterViewController: BaseViewController, FUIAuthDelegate {
    
    // centerViewController.delegate = self  (from ContainerViewController)
    var delegate: CenterViewControllerDelegate?
    
    //var missingInformationVC: MissingInformationVC?
    
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
    
    let one_moment_please_label : UITextView = {
        let textView = UITextView()
        textView.text = "One moment please\nLogging you in now"
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
    
    //var limboViewController : LimboViewController?
    var disabledViewController : DisabledViewController?
    
    @objc func toggleMainMenu(_ sender: Any) {
        delegate?.toggleLeftPanel?()
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "TelePatriot" // what the user sees (across the top) when they first login
        
        getSpinner()
        showSpinner()
        
        if(TPUser.sharedInstance.accountStatusEventListeners.count == 0
            || !TPUser.sharedInstance.accountStatusEventListeners.contains(where: { String(describing: type(of: $0)) == "CenterViewController" })) {
            TPUser.sharedInstance.accountStatusEventListeners.append(self)
        } else {
            print("CenterViewController: NOT adding self to list of accountStatusEventListeners") }
        
        BackTracker.sharedInstance.setNavigationItem(nav: self.navigationItem, backHandler: self)
        
        
        if let _ = TPUser.sharedInstance.uid {
            loadSplashscreen()
        }
        
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
    
    var spinnerView : UIView?
    let ai = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
//    private func showSpinner2() {
//        if (self.spinning) {
//            return
//        }
//        self.spinnerView?.addSubview(self.ai)
//        print("showSpinner2():  ================================================")
//        print("showSpinner2():  self.spinnerView?.addSubview(self.ai)")
//        self.view.addSubview(self.spinnerView!)
//        print("showSpinner2():  self.view.addSubview(self.spinnerView!)")
//        self.spinning = true
//        print("showSpinner2():  self.spinning = \(self.spinning)")
//    }
    
    private func getSpinner() {
        spinnerView = UIView.init(frame: view.bounds)
        if let spinnerView = spinnerView {
            spinnerView.addSubview(one_moment_please_label)
            
            one_moment_please_label.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor, constant: 0).isActive = true
            one_moment_please_label.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor, constant: -64).isActive = true
            
            spinnerView.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            ai.startAnimating()
            ai.center = spinnerView.center
        }
        
    }
    
    private func showSpinner() {
        DispatchQueue.main.async {
            self.spinnerView?.addSubview(self.ai)
            self.view.addSubview(self.spinnerView!)
        }
    }
    
    private func dismissSpinner() {
        self.ai.removeFromSuperview()
        if let spinnerView = spinnerView {
            spinnerView.removeFromSuperview()
        }
    }
    
    var splashScreenAlreadyLoaded = false
    private func loadSplashscreen() {
        if splashScreenAlreadyLoaded {
            print("splashScreenAlreadyLoaded = \(splashScreenAlreadyLoaded)")
            return
        }
        
        splashScreenAlreadyLoaded = true
        dismissSpinner()
        
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
    
    var dataMissing = false
    var simulate_missing_name = false
    var simulate_missing_email = false
    // logging in is done here.  Logging out is done in TPUser.signOut()
    func checkLoggedIn() {
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                
                // need to get handle to SidePanelViewController
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                
                TPUser.sharedInstance.setUser(u: user)
                print("CenterViewController.checkLoggedIn(): TPUser.sharedInstance.setUser(u: user)  \(user.displayName ?? "name is n/a")")
                
                if let sidePanelViewController = appDelegate?.leftViewController {
                    TPUser.sharedInstance.addAccountStatusEventListener(listener: sidePanelViewController)
                    print("CenterViewController.checkLoggedIn(): TPUser.sharedInstance.addAccountStatusEventListener(listener: sidePanelViewController)")
                }
                
                if let videoChatVC = appDelegate?.videoChatVC {
                    TPUser.sharedInstance.addAccountStatusEventListener(listener: videoChatVC)
                    print("CenterViewController.checkLoggedIn(): TPUser.sharedInstance.addAccountStatusEventListener(listener: videoChatVC)")
                }
                
                if let limboViewController = appDelegate?.limboViewController {
                    limboViewController.setUser(user: user)
                    TPUser.sharedInstance.addAccountStatusEventListener(listener: limboViewController)
                    print("CenterViewController.checkLoggedIn(): TPUser.sharedInstance.addAccountStatusEventListener(listener: limboViewController)")
                }
                
                // fire off a CBAPIEvent to make CB do a look up on this email address
                // BUT WHAT IF GOOGLE/FACEBOOK DIDN'T SEND THEIR NAME OR EMAIL ???
                // We need a configurable switch to test this info not being sent
                if let name = user.displayName, let email = user.email {
                    let evt = CBAPIEvent(uid: TPUser.sharedInstance.getUid(), name: name, email: email, event_type: "login")
                    evt.save()
                    print("CenterViewController.checkLoggedIn(): evt.save()")
                }
                else {
                    // send them to the MissingInformation screen
                    print("CenterViewController.checkLoggedIn(): Send user to MissingInformation screen because name and/or email is missing")
                }
                
                
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
        authUI?.isSignInWithEmailHidden = false
        
        let googleProvider = FUIGoogleAuth(scopes: ["https://www.googleapis.com/auth/userinfo.email", "https://www.googleapis.com/auth/userinfo.profile"])
        let facebookProvider = FUIFacebookAuth.init(permissions: ["public_profile", "email"])
        authUI?.delegate = self
        authUI?.providers = [googleProvider, facebookProvider]
        
        // from Brian Caldwell YouTube
        let authViewController = MyAuthPicker(authUI: authUI!)
        let navc = UINavigationController(rootViewController: authViewController)
        
        var topController: UIViewController = (UIApplication.shared.keyWindow?.rootViewController!)!
        while(topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
        }
        topController.present(navc, animated: true, completion: nil)
        
//        self.present(navc, animated: true, completion: nil)
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
//            let u = TPUser.sharedInstance
//            u.noRoleAssignedDelegate = self
//            u.setUser(u: user)
        }
    }
}

extension CenterViewController : AppDelegateDelegate {
    func show(viewController: UIViewController) {
        doView(vc: viewController, viewControllers: self.childViewControllers)
    }
}

extension CenterViewController : NevermindDelegate {
    func clickReregister() {
//        try! Auth.auth().signOut()
//        splashScreenAlreadyLoaded = false  // so that the next time you login, you'll get the splashscreen again
        login()
    }
    func clickQuit() {
        splashScreenAlreadyLoaded = false  // so that the next time you login, you'll get the splashscreen again
        TPUser.sharedInstance.signOut()
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
            splashScreenAlreadyLoaded = false  // so that the next time you login, you'll get the splashscreen again
            TPUser.sharedInstance.signOut()
            // see userSignedOut() below.  We created an extension of this class that implements
            // AccountStatusEventListener because we call TPUser.sharedInstance.signOut() from other
            // places besides just here and we need the UI to be cleared out whenever the logs out
        }
        else if(menuItem.title.starts(with: "My Profile")) {
            guard let vc = delegate?.getMyProfileVC() else { return }
            unassignMissionItem()
            doView(vc: vc, viewControllers: self.childViewControllers)
        }
        else if(menuItem.title.starts(with: "My Legislators")) {
            guard let vc = delegate?.getMyLegislatorsVC() else { return }
            unassignMissionItem()
            doView(vc: vc, viewControllers: self.childViewControllers)
        }
        else if(menuItem.title.starts(with: "Team")) {
            //guard let vc = delegate?.getNewPhoneCampaignVC() else { return }
            guard let vc = delegate?.getSwitchTeamsVC() else { return }
            unassignMissionItem()
            doView(vc: vc, viewControllers: self.childViewControllers)
        }
        else if(menuItem.title == "My Mission") {
            unassignMissionItem()
            
            // See MainActivity.onNavigationItemSelected() on the Android side
            // TRANSITIONAL CODE - We're not always going to have all this.  At some point, we are only going to get mission
            // information from CB.  But until we finally jettison the mission stored in TelePatriot/Firebase, we're going to have
            // to check the data under /administration/configuration
            Database.database().reference().child("administration/configuration").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                if let vals = snapshot.value as? [String:Any] {
                    let conf = Configuration(data: vals)
                    if conf.getMissionsFromCB() {
                        guard let vc = self.delegate?.getMyCBMissionViewController() else {
                            return }
                        vc.missionConfig = conf
                        self.doView(vc: vc, viewControllers: self.childViewControllers)
                    }
                    else {
                        guard let vc = self.delegate?.getMyMissionViewController() else { return }
                        self.doView(vc: vc, viewControllers: self.childViewControllers)
                    }
                }
                else {
                    guard let vc = self.delegate?.getMyMissionViewController() else { return }
                    self.doView(vc: vc, viewControllers: self.childViewControllers)
                    //doView(vc: MyMissionViewController(), viewControllers: self.childViewControllers)
                }
            })
            
        }
        else if(menuItem.title == "Directors") {
            // don't instantiate here.  Get from ContainerViewController  ...but how?
            if let directorViewController = delegate?.getDirectorViewController() {
                unassignMissionItem()
                doView(vc: directorViewController, viewControllers: self.childViewControllers)
            }
        }
        else if(menuItem.title == "Admins") {
            guard let vc = delegate?.getAdminVC() else { return }
            unassignMissionItem()
            doView(vc: vc, viewControllers: self.childViewControllers, track: true)
        }
        else if(menuItem.title == "Share Petition") {
            unassignMissionItem()
            doView(vc:  SharePetitionViewController(), viewControllers: self.childViewControllers)
        }
        else if(menuItem.title == "Video Chat") {
            // delegate is probably ContainerViewController
            guard let vc = delegate?.getVideoChatViewController() else { return }
            unassignMissionItem()
            doView(vc: vc, viewControllers: self.childViewControllers, track: true)
        }
        else if(menuItem.title == "Video Offers") {
            // delegate is probably ContainerViewController
            guard let vc = delegate?.getVideoOffersVC() else { return }
            unassignMissionItem()
            doView(vc: vc, viewControllers: self.childViewControllers, track: true)
        }
        else if(menuItem.title == "Video Invitations") {
            // delegate is probably ContainerViewController
            guard let vc = delegate?.getVideoInvitationsViewController() else { return }
            unassignMissionItem()
            doView(vc: vc, viewControllers: self.childViewControllers, track: true)
        }
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // TODO do we need to do something here or not when orientation changes between landscap and portrait?
        //view.invalidateIntrinsicContentSize()
    }
    
}

extension CenterViewController : NewPhoneCampaignSubmittedHandler {
    func newPhoneCampaignSubmitted() {
        guard let vc = delegate?.getMissionSummaryTVC() else { return }
        doView(vc: vc, viewControllers: self.childViewControllers)
    }
}

// CenterViewController is assigned in ContainerViewController.viewDidLoad()
extension CenterViewController : WrapUpCBCallDelegate {
    func cbMissionAccomplished() {
        guard let vc = delegate?.getMyCBMissionViewController() else { return }
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
    func teamSelected(team: TeamIF) {
        if let oldteam = TPUser.sharedInstance.getCurrentTeam() {
            if let name = team.getName(), let oldname = oldteam.getName(), name != oldname {
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


extension CenterViewController : AccountStatusEventListener {
    
    func changed(name: String) {
        // do nothing?  really?  if so, code smell
    }
    
    func changed(email: String) {
        // do nothing?  really?  if so, code smell
    }
    
    func roleAssigned(role: String) {
        // stub
    }
    
    func roleRemoved(role: String) {
        // stub
    }
    
    func teamSelected(team: TeamIF, whileLoggingIn: Bool) {
        // stub
    }
    
    func userSignedOut() {
        
        // remove all subviews and child view controllers so that we don't come back to the screen we were on - that's really confusing
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        for child in self.childViewControllers {
            child.removeFromParentViewController()
        }
    }
    
    //THIS ISN'T BEING CALLED ON SUBSEQUENT LOGINS !!!!!!!!!!!!!!!!!
    func allowed() {
        if let limboViewController = delegate?.getLimboViewController() {
            limboViewController.dismiss(animated: true, completion: nil)
            limboViewController.removeFromParentViewController()
        }
        loadSplashscreen()
    }
    
    func notAllowed() {
        dismissSpinner()
        
        if let limboViewController = delegate?.getLimboViewController() {
            
            let is_ = limboViewController.viewIfLoaded?.window != nil || limboViewController.isBeingPresented
                || limboViewController.isViewLoaded
            if !is_ { // bug fix - avoids a nasty "already presented" exception
                limboViewController.modalPresentationStyle = .popover
                self.present(limboViewController, animated: true, completion:nil)
            }
        }
        
        //loadSplashscreen()
    }
    
    func accountDisabled() {
        if disabledViewController == nil {
            disabledViewController = DisabledViewController()
            disabledViewController?.modalPresentationStyle = .popover
            self.present(disabledViewController!, animated: true, completion:nil)
        }
    }
    
    // required by AccountStatusEventListener
    func accountEnabled() {
        if let disabledViewController = disabledViewController {
            disabledViewController.dismiss(animated: true, completion: nil)
            self.disabledViewController = nil
        }
    }
    
    // required by AccountStatusEventListener
    func videoInvitationExtended(vi: VideoInvitation) {
        // do nothing?  really?  if so, code smell
    }
    
    // required by AccountStatusEventListener
    func videoInvitationRevoked() {
        // do nothing?  really?  if so, code smell
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
    func missionSelected(mission: MissionSummary, team: TeamIF) {
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
    func videoInvitationSelected(invitation: VideoInvitation) {
        guard let vc = delegate?.getVideoChatViewController(),
            let room_id = invitation.room_id
            else { return }
        vc.room_id = room_id
        doView(vc: vc, viewControllers: self.childViewControllers)
    }
}

extension CenterViewController : MissionDelegate {
    func leaveNotes() {
        guard let _ = TPUser.sharedInstance.currentCBMissionItem,
            let vc = delegate?.getCBMissionItemWrapUpVC()
        // whats the vc
        else { return }
        
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
