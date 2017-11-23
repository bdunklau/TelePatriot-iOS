import UIKit
import Firebase
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabaseUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FBSDKCoreKit
import FBSDKLoginKit

class HomeViewController: BaseViewController, FUIAuthDelegate, AccountStatusEventListener {
    
    //var db = FIRDatabaseReference.init()
    var kFacebookAppID = "111804472843925"
    
    var delegate : CenterViewControllerDelegate?
    
    //@IBOutlet weak var volunteerButton: UIButton!
    let volunteerButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("My Mission", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(myMission), for: .touchUpInside)
        return button
    }()
    
    //@IBOutlet weak var directorButton: UIButton!
    let directorButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Directors", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(directors), for: .touchUpInside)
        return button
    }()
    
    //@IBOutlet weak var adminButton: UIButton!
    let adminButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Admins", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(admins), for: .touchUpInside)
        return button
    }()
    
    let menuButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Menu", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(slideMenu), for: .touchUpInside)
        return button
    }()
    
    
    var byPassLogin : Bool = false
    
    //@IBOutlet weak var name: UILabel!
    var name = UILabel()
    
    @IBAction func logoutPressed(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        listenForAccountStatusEvents()
     
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
    
    func setupView() {
        
        navigationItem.title = "Home"
        
        let item2 = UIBarButtonItem(customView: menuButton)
        self.navigationItem.setLeftBarButtonItems([item2], animated: true)
        
        self.view.addSubview(volunteerButton)
        self.view.addSubview(directorButton)
        self.view.addSubview(adminButton)
        
        /******
        volunteerButton.addTarget(self, action: #selector(myMission), for: .touchUpInside)
        directorButton.addTarget(self, action: #selector(directors), for: .touchUpInside)
        adminButton.addTarget(self, action: #selector(admins), for: .touchUpInside)
        *******/
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-24-[v0]-24-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": volunteerButton]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-24-[v0]-24-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": directorButton]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-24-[v0]-24-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": adminButton]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-24-[v0]-10-[v1]-50-[v2]-300-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": volunteerButton, "v1": directorButton, "v2": adminButton]))
    }
    
    @objc func myMission() {
        self.present(VolunteerViewController(), animated: true, completion: nil)
    }
    
    @objc func directors() {
        self.present(DirectorViewController(), animated: true, completion: nil)
    }
    
    @objc func admins() {
        self.present(AdminViewController(), animated: true, completion: nil)
    }
    
    @objc func slideMenu() {
        delegate?.toggleLeftPanel?()
    }
    
    func checkLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in
                print(user?.displayName)
                print(user?.email)
                self.name.text = user?.displayName
                
                // if the user doesn't have any roles assigned yet, send him to the Limbo screen...
                let u = TPUser.sharedInstance
                print("HomeViewController.checkLoggedIn() -----------------")
                u.setUser(u: user)
                // TODO This is not right (above and below). We see a temporary black screen because we are fetching
                // user roles asynchronously (of course) but we are checking synchronously on the very next line to see
                // if the user has any roles.  The stuff below ought to be in a callback.
                if(!u.hasAnyRole()) {
                    
                    // If you need to test/debug the LimboViewController screen flow, you'll want to comment this line in and out
                    // With it commented out, you'll always be sent to the Home screen where you can logout.
                    self.navigationController?.pushViewController(LimboViewController(), animated: false)
                    //self.present(LimboViewController(), animated: true, completion: nil)
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
                //self.performSegue(withIdentifier: "ShowLimboScreen", sender: self)
                self.present(LimboViewController(), animated: true, completion: nil)
            }
        }
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionUniversalLinksOnly] as! String
        return FUIAuth.defaultAuthUI()!.handleOpen(url as URL, sourceApplication: sourceApplication )
    }
    
    
    // required by AccountStatusEventListener
    func roleAssigned(role: String) {
        if( role == "Volunteer" ) {
            volunteerButton.isHidden = false
            //volunteerButton.setTitle("My Mission", for: .normal)//.titleLabel = "My Mission"
        }
        if( role == "Director" ) {
            directorButton.isHidden = false
            //directorButton.setTitle("Directors", for: .normal)
        }
        if( role == "Admin" ) {
            adminButton.isHidden = false
            //adminButton.setTitle("Admins", for: .normal)
        }
    }
    
    // required by AccountStatusEventListener
    func roleRemoved(role: String) {
        if( role == "Volunteer" ) {
            volunteerButton.isHidden = true
            //volunteerButton.setTitle("", for: .normal)
        }
        if( role == "Director" ) {
            directorButton.isHidden = true
            //directorButton.setTitle("", for: .normal)
        }
        if( role == "Admin" ) {
            adminButton.isHidden = true
            //adminButton.setTitle("", for: .normal)
        }
    }
    
    func listenForAccountStatusEvents() {
        if(TPUser.sharedInstance.accountStatusEventListeners.count == 0
            || !TPUser.sharedInstance.accountStatusEventListeners.contains(where: { String(describing: type(of: $0)) == "HomeViewController" })) {
            print("HomeViewController: adding self to list of accountStatusEventListeners")
            TPUser.sharedInstance.accountStatusEventListeners.append(self)
        } else { print("HomeViewController: NOT adding self to list of accountStatusEventListeners") }
    }
    
}

extension HomeViewController: SidePanelViewControllerDelegate {
    
    func didSelectSomething(menuItem: MenuItem) {
        /*********
        imageView.image = animal.image
        titleLabel.text = animal.title
        creatorLabel.text = animal.creator
        ********/
        delegate?.collapseSidePanels?()
    }
}

