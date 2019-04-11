//import UIKit
//import Firebase
//import FirebaseAuth
//import FirebaseAuthUI
//import FirebaseDatabaseUI
//import FirebaseGoogleAuthUI
//import FirebaseFacebookAuthUI
//import FBSDKCoreKit
//import FBSDKLoginKit

class HomeViewController//: BaseViewController
//, FUIAuthDelegate
/*, AccountStatusEventListener */ {
    
    //var db = FIRDatabaseReference.init()
//    var kFacebookAppID = "111804472843925"
//
//    var delegate : CenterViewControllerDelegate?
//
//    //@IBOutlet weak var volunteerButton: UIButton!
//    let volunteerButton : UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("My Mission", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(myMission), for: .touchUpInside)
//        return button
//    }()
//
//    //@IBOutlet weak var directorButton: UIButton!
//    let directorButton : UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Directors", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(directors), for: .touchUpInside)
//        return button
//    }()
//
//    //@IBOutlet weak var adminButton: UIButton!
//    let adminButton : UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Admins", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(admins), for: .touchUpInside)
//        return button
//    }()
//
//    let menuButton : UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("HomeVC", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(slideMenu), for: .touchUpInside)
//        return button
//    }()
//
//
//    var byPassLogin : Bool = false
//
//    //@IBOutlet weak var name: UILabel!
//    var name = UILabel()
//
//    @IBAction func logoutPressed(_ sender: Any) {
//        //try! Auth.auth().signOut()
//        //UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
//        TPUser.sharedInstance.signOut()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//
//    @objc func myMission() {
//        self.present(VolunteerViewController(), animated: true, completion: nil)
//    }
//
//    @objc func directors() {
//        self.present(DirectorViewController(), animated: true, completion: nil)
//    }
//
//    @objc func admins() {
//        self.present(AdminViewController(), animated: true, completion: nil)
//    }
//
//    @objc func slideMenu() {
//        delegate?.toggleLeftPanel?()
//    }
//
//
//
//    func application(app: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
//        let sourceApplication = options[UIApplicationOpenURLOptionUniversalLinksOnly] as! String
//        return FUIAuth.defaultAuthUI()!.handleOpen(url as URL, sourceApplication: sourceApplication )
//    }
//
//
//    // required by AccountStatusEventListener
//    func roleAssigned(role: String) {
//        if( role == "Volunteer" ) {
//            volunteerButton.isHidden = false
//            //volunteerButton.setTitle("My Mission", for: .normal)//.titleLabel = "My Mission"
//        }
//        if( role == "Director" ) {
//            directorButton.isHidden = false
//            //directorButton.setTitle("Directors", for: .normal)
//        }
//        if( role == "Admin" ) {
//            adminButton.isHidden = false
//            //adminButton.setTitle("Admins", for: .normal)
//        }
//    }
//
//    // required by AccountStatusEventListener
//    func roleRemoved(role: String) {
//        if( role == "Volunteer" ) {
//            volunteerButton.isHidden = true
//            //volunteerButton.setTitle("", for: .normal)
//        }
//        if( role == "Director" ) {
//            directorButton.isHidden = true
//            //directorButton.setTitle("", for: .normal)
//        }
//        if( role == "Admin" ) {
//            adminButton.isHidden = true
//            //adminButton.setTitle("", for: .normal)
//        }
//    }
    
}

//extension HomeViewController: SidePanelViewControllerDelegate {
//
//    func didSelectSomething(menuItem: MenuItem) {
//        /*********
//        imageView.image = animal.image
//        titleLabel.text = animal.title
//        creatorLabel.text = animal.creator
//        ********/
//        delegate?.collapseSidePanels?()
//    }
//}

