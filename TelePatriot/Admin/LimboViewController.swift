//
//  LimboViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/14/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class LimboViewController: BaseViewController, UITableViewDelegate
{
    private var user: User?
    var isBrandNewUser : Bool?
    var limboView: LimboView?
    var missingInformationView: MissingInformationView?
    var nevermindView: NevermindView?
    var dataMissing = false
    var userValues: [String:String] = [:]
    var nevermindDelegate : NevermindDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "TelePatriot" // what the user sees (across the top) when they first login
        //theview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        theview()
    }
    
    private func theview() {
        
        // Is this going to work?  We should never come to this view except on brand new users
        isBrandNewUser = true
        
        // https://stackoverflow.com/a/44403725
        // Hide the back button on this screen.  Don't want the user to be able to go anywhere
        // until they are assigned to a group
        self.navigationItem.hidesBackButton = true
        
        if dataMissing {
            limboView?.removeFromSuperview()
            nevermindView?.removeFromSuperview()
            
            // show missingInformationView
            missingInformationView = MissingInformationView(frame: view.frame)
            missingInformationView?.setValues(uid: TPUser.sharedInstance.getUid(), user: userValues)
            view.addSubview(missingInformationView!)
            
            missingInformationView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            missingInformationView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
            missingInformationView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
            missingInformationView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            missingInformationView?.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: 1.0).isActive = true
            missingInformationView?.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 1.0).isActive = true
            missingInformationView?.missingInformationDelegate = self
        }
        else {
            showLimboView(name: TPUser.sharedInstance.getName(), email: TPUser.sharedInstance.getEmail())
        }
    }
    
    private func showNevermindView() {
        limboView?.removeFromSuperview()
        nevermindView = NevermindView(frame: view.frame)
        nevermindView?.setupView()
        nevermindView?.nevermindDelegate = self
        view.addSubview(nevermindView!)
    }
    
    private func showLimboView(name: String, email: String) {
        nevermindView?.removeFromSuperview()
        limboView = LimboView(frame: view.frame)
        limboView?.setupView(name: name, email: email)
        limboView?.limboViewDelegate = self
        view.addSubview(limboView!)
    }
    
    func addAccountStatusEventListener(user: TPUser) {
        if(TPUser.sharedInstance.accountStatusEventListeners.count == 0
            || !user.accountStatusEventListeners.contains(where: { String(describing: type(of: $0)) == "LimboViewController" })) {
            print("LimboViewController: adding self to list of accountStatusEventListeners")
            user.accountStatusEventListeners.append(self)
        } else {
            print("LimboViewController: NOT adding self to list of accountStatusEventListeners") }
    }
    
    @objc private func clickSignPetition(_ sender:UIButton) {
        // TODO should get from database
        openUrl(string: "https://www.conventionofstates.com")
    }
    
    @objc private func clickSignConfidentialityAgreement(_ sender:UIButton) {
        // TODO should get from database
        openUrl(string: "https://esign.coslms.com:8443/S/COS/Transaction/Volunteer_Agreement_Manual")
    }
    
    private func openUrl(string: String) {
        guard let url = URL(string: string) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else {
            UIApplication.shared.openURL(url)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // As long as the user contains the required info - name and email - we show the limbo screen
    // that tells them they need to sign the petition and conf agreement.
    // But if name or email is missing, we have to send them to the MissingInformationView screen
    func setUser(user: User) {
        self.user = user
        
        // check for special configuration to see if we should simulate missing data (name and email)
        Database.database().reference().child("administration/configuration").observeSingleEvent(of: .value, with: {(snapshot) in
            var simulate_missing_name = false
            var simulate_missing_email = false
            if let dictionary = snapshot.value as? [String : Any] {
                if let val = dictionary["simulate_missing_name"] as? Bool {
                    simulate_missing_name = val
                }
                if let val = dictionary["simulate_missing_email"] as? Bool {
                    simulate_missing_email = val
                }
            }
            
            let nameMissing = user.displayName == nil || user.displayName == "" || simulate_missing_name
            let emailMissing = user.email == nil || user.email == "" || simulate_missing_email
            self.dataMissing = nameMissing || emailMissing
            
            // User is signed in
            print("====================================================================")
            print("nameMissing = \(nameMissing)  simulate_missing_name = \(simulate_missing_name)")
            print("emailMissing = \(emailMissing)  simulate_missing_email = \(simulate_missing_email)")
            print("dataMissing = \(self.dataMissing)")
            print(user.displayName)
            print(user.email)
            
            if !nameMissing {
                self.userValues["name"] = user.displayName
            }
            if !emailMissing {
                self.userValues["email"] = user.email
            }
            
        }, withCancel: nil)
    }

}

extension LimboViewController : NevermindDelegate {
    func clickReregister() {
        nevermindDelegate?.clickReregister() // CenterViewController
    }
    func clickQuit() {
        nevermindDelegate?.clickQuit()
    }
}

extension LimboViewController : LimboViewDelegate {
    func clickShowMeHow() {
        self.present(ShowMeHowVC(), animated: true, completion: nil)
    }
    
    func startVideoChat() {
        if let vc = getAppDelegate().videoChatVC, let videoInvitation = limboView?.videoInvitation {
            //          I think what we need to do is create a VideoInvitation object and accept it here
            //            Then make sure the current user is a participant on the video node
            videoInvitation.accept()
            self.present(vc, animated: true, completion: nil) // have to get the vc from appDelegate
        }
    }
    
    func clickDone(name: String, email: String) {
        
        let now = Util.getDate_as_millis()
        limboView?.done_button.setTitle("Verifying...", for: .normal)
        let evt = CBAPIEvent(uid: TPUser.sharedInstance.getUid(), name: name, email: email, event_type: "check legal")
        evt.save()
        
        // need to call CB to confirm...
        Database.database().reference().child("cb_api_events/check-legal-responses/\(TPUser.sharedInstance.getUid())")
            .queryOrdered(byChild: "date_ms")
            .queryStarting(atValue: now)
            .queryLimited(toFirst: 1)
            .observe(.value, with: {(snapshot) in
                
                let children = snapshot.children
                while let snap = children.nextObject() as? DataSnapshot { // should only be one child because we limited to 1
                    guard let dictionary = snap.value as? [String:Any] else {
                        return
                    }
                    if let valid = dictionary["valid"] as? Bool {
                        if valid {
                            self.limboView?.done_button.setTitle("Good", for: .normal) }
                        else {
                            self.limboView?.done_button.setTitle("Signatures Not Received Yet", for: .normal) }
                    }
                }
                
            })
    
    }
    
    func clickNevermind() {
        showNevermindView()
    }
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

// This is what gets called when you click Save on the MissingInformationView
// And what happens is: The name and email are saved to the database and the user is shown
// the main verbiage of the limbo screen (LimboView).  We don't show this to users that have missing
// names and emails because there's no point.  We have to get that information first.
extension LimboViewController : MissingInformationDelegate {
    func saveInfo(uid: String, name: String, email: String) {
        if name == "" || email == "" {
            let title = "Required Fields"
            let message = "All fields on this screen are required"
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style {
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                }
            })
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }
        else if !email.isValidEmail() {
            let title = "Invalid Email"
            let message = "This is not a valid email address:\n\(email)"
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style {
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                }
            })
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let updatedData = ["users/\(uid)/name": name,
                               "users/\(uid)/email": email,
                               "users/\(uid)/account_disposition": "enabled"]
            // example of multi-path update
            Database.database().reference().updateChildValues(updatedData, withCompletionBlock: { (error, ref) -> Void in
                if let missingInformationView = self.missingInformationView {
                    missingInformationView.removeFromSuperview()
                }
                self.showLimboView(name: name, email: email)
                TPUser.sharedInstance.user?.updateEmail(to: email, completion: {error in
                    if error != nil {
                        
                    }
                    else {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = name
                        changeRequest?.commitChanges { (error) in
                            // do nothing I guess
                        }
                    }
                }) // TODO can't find signature of UserProfileChangeCallback
                TPUser.sharedInstance.set(email: email)
                TPUser.sharedInstance.set(name: name)
            })
        }
    }
}

extension LimboViewController : AccountStatusEventListener {
    
    func changed(name: String) {
        // do nothing?  really?  if so, code smell
    }
    
    func changed(email: String) {
        // do nothing?  really?  if so, code smell
    }
    
    // required by AccountStatusEventListener
    func roleAssigned(role: String) {
        guard let isNewUser = isBrandNewUser else { return }
        
        if(!isNewUser) { return }
        
        isBrandNewUser = false // so that the stuff below never gets called again
        
        // we only care on the very first role assigned
        //let byPassLogin = true
        //self.performSegue(withIdentifier: "HomeViewController", sender: byPassLogin)
        // We don't want to go to HomeViewController anymore.  We want to go to CenterViewController
        let home = ContainerViewController()
        //home.byPassLogin = true
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    // TODO Why does this class implement AccountStatusEventListener AccountStatusEventListener
    // if all the methods are no-ops?  Is there one method that we DO implement?
    // required by AccountStatusEventListener
    func roleRemoved(role: String) {
        // do nothing
    }
    
    // required by AccountStatusEventListener
    func allowed() {
        //        message = "allowed"
    }
    
    // required by AccountStatusEventListener
    func notAllowed() {
        //        message = "not allowed"
    }
    
    // required by AccountStatusEventListener
    func accountDisabled() {
        // do nothing
    }
    
    // required by AccountStatusEventListener
    func accountEnabled() {
        // do nothing
    }
    
    func teamSelected(team: TeamIF, whileLoggingIn: Bool) {
        // do nothing
    }
    
    func userSignedOut() {
        // do nothing
    }
    
    func videoInvitationExtended(vi: VideoInvitation) {
        limboView?.videoInvitation = vi
        limboView?.show_me_how_button.isHidden = true
        DispatchQueue.main.async { self.limboView?.video_invitation_button.isHidden = false }
        limboView?.access_limited_description.text = TPUser.sharedInstance.video_invitation_from_name!+" "+(limboView?.YOUVE_BEEN_INVITED_MESSAGE)!+" "+TPUser.sharedInstance.video_invitation_from_name!
    }
    
    func videoInvitationRevoked() {
        limboView?.videoInvitation = nil
        limboView?.show_me_how_button.isHidden = false
        limboView?.video_invitation_button.isHidden = true
        limboView?.access_limited_description.text = limboView?.ACCESS_LIMITED_DESCRIPTION
    }
    
}

/*************  this is just another way of implementing the UITableViewDataSource
 
extension LimboViewController : UITableViewDataSource {
    
    
    // required by UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountStatusEvents.count
    }
    
    // required by UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewAccountStatusEvents?.dequeueReusableCell(withIdentifier: "cellId",
                                                                    for: indexPath as IndexPath) as! AccountStatusEventTableViewCell
        
        let accountStatusEvent = accountStatusEvents[indexPath.row]
        cell.configureCell(accountStatusEvent: accountStatusEvent)
        
        return cell
    }
    
}
*********/
