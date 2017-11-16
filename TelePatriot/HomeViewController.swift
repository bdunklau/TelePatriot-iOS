import UIKit
import Firebase
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabaseUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FBSDKCoreKit
import FBSDKLoginKit

class HomeViewController: BaseViewController, FUIAuthDelegate {
    
    //var db = FIRDatabaseReference.init()
    var kFacebookAppID = "111804472843925"
    
    var byPassLogin : Bool = false
    
    @IBOutlet weak var name: UILabel!
    
    @IBAction func logoutPressed(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
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
                // User is signed in.
                self.name.text = user?.displayName
                
                // if the user doesn't have any roles assigned yet, send him to the Limbo screen...
                let u = TPUser.sharedInstance
                print("HomeViewController.checkLoggedIn() -----------------")
                u.setUser(u: user)
                if(!u.hasAnyRole()) {
                    self.performSegue(withIdentifier: "ShowLimboScreen", sender: self)
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
                self.performSegue(withIdentifier: "ShowLimboScreen", sender: self)
            }
        }
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionUniversalLinksOnly] as! String
        return FUIAuth.defaultAuthUI()!.handleOpen(url as URL, sourceApplication: sourceApplication )
    }
    
    
}

