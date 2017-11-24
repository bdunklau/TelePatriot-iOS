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

class CenterViewController: UIViewController, FUIAuthDelegate {
    
    
    /********
    @IBOutlet weak fileprivate var imageView: UIImageView!
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var creatorLabel: UILabel!
    *******/
    
    var delegate: CenterViewControllerDelegate?
    
    var byPassLogin : Bool = false
    
    // MARK: Button actions
    
    @IBAction func leftMenuTapped(_ sender: Any) {
        delegate?.toggleLeftPanel?()
    }
    
    @IBAction func rightMenuTapped(_ sender: Any) {
        delegate?.toggleRightPanel?()
    }
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "CenterVC"
        
        // LimboViewController sets this in prepareForSegue
        if(!byPassLogin) {
            checkLoggedIn()
        }
        else {
            // If we're bypassing the login logic, it's because we are coming back to this
            // screen from LimboViewController.  In that case, we don't want to show the back
            // button here.  We don't want the user to be able to go back to that screen.
            
            // https://stackoverflow.com/a/44403725
            self.navigationItem.hidesBackButton = true
        }
    }
    
    
    func checkLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in
                print(user?.displayName)
                print(user?.email)
                
                // if the user doesn't have any roles assigned yet, send him to the Limbo screen...
                let u = TPUser.sharedInstance
                print("CenterViewController.checkLoggedIn() -----------------")
                u.setUser(u: user)
                // TODO This is not right (above and below). We see a temporary black screen because we are fetching
                // user roles asynchronously (of course) but we are checking synchronously on the very next line to see
                // if the user has any roles.  The stuff below ought to be in a callback.
                /***********************
                 This is the wrong thing to look at anyway.  We need to look at the /no_roles node to determine
                 if the user should go to the limbo screen
                if(!u.hasAnyRole()) {
                    
                    // If you need to test/debug the LimboViewController screen flow, you'll want to comment this line in and out
                    // With it commented out, you'll always be sent to the Home screen where you can logout.
                    self.view.window?.rootViewController?.navigationController?.pushViewController(LimboViewController(), animated: false)
                    //self.present(LimboViewController(), animated: true, completion: nil)
                }
                 *********************/
                
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
        //let options = FirebaseApp.app()?.options
        //let clientId = options?.clientID
        let googleProvider = FUIGoogleAuth(scopes: ["https://www.googleapis.com/auth/userinfo.email", "https://www.googleapis.com/auth/userinfo.profile"])
        let facebookProvider = FUIFacebookAuth.init(permissions: ["public_profile", "email"])
        authUI?.delegate = self
        authUI?.providers = [googleProvider, facebookProvider]
        let authViewController = authUI?.authViewController()
        self.present(authViewController!, animated: true, completion: nil)
    }
    
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if error != nil {
            //Problem signing in
            login()
        } else {
            //User is in! Here is where we code after signing in
            // how do we get the name of the user?
            
            //print("User: "+user!.displayName!)
            //name.text = user!.displayName!
            
            /**
             Now find out if user has any roles yet, or if he has to be sent to the "limbo" screen
             **/
            let u = TPUser.sharedInstance
            u.setUser(u: user)
            // now see if the user has any roles.  If he does, send him on to whatever the main/home screen is
            // If he doesn't, send him to the "limbo" screen where he has to sit and wait to be let in.
            if u.hasAnyRole() {
                // let them in  ...which really means do nothing, because this screen/controller is where they need to be
            } else {
                // send them to the "limbo" screen
                //self.performSegue(withIdentifier: "ShowLimboScreen", sender: self)
                self.present(LimboViewController(), animated: true, completion: nil)
            }
        }
    }
}

extension CenterViewController: SidePanelViewControllerDelegate {
    
    func didSelectSomething(menuItem: MenuItem) {
        /*******
        imageView.image = animal.image
        titleLabel.text = animal.title
        creatorLabel.text = animal.creator
        ********/
        self.navigationItem.title = menuItem.title
        delegate?.collapseSidePanels?()
        
        // This is where we figure out where to send the user based on the
        // menu item that was just touched
        if(menuItem.title == "Sign Out") {
            try! Auth.auth().signOut()
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        }
        else if(menuItem.title == "My Mission") {
            doView(vc: MyMissionViewController(), viewControllers: self.childViewControllers)
        }
        else if(menuItem.title == "Directors") {
            doView(vc: DirectorViewController(), viewControllers: self.childViewControllers)
        }
        else if(menuItem.title == "Admins") {
            doView(vc: AdminViewController(), viewControllers: self.childViewControllers)
        }
        else if(menuItem.title == "Share Petition") {
            doView(vc: SharePetitionViewController(), viewControllers: self.childViewControllers)
        }
        else if(menuItem.title == "Chat/Help") {
            doView(vc: ChatHelpViewController(), viewControllers: self.childViewControllers)
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
    
    func doView(vc: UIViewController, viewControllers: [UIViewController]) {
        guard let viewController = inList(viewControllers: self.childViewControllers, viewController: vc) else {
            // vc not yet a child vc so add it
            addChildViewController(vc)
            self.view.addSubview(vc.view)
            return
        }
        self.view.bringSubview(toFront: viewController.view)
        
    }
}

