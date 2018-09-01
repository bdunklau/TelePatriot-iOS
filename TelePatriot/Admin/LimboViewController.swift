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
//, UITableViewDataSource
, AccountStatusEventListener {
    
    
    var scrollView : UIScrollView?
    var isBrandNewUser : Bool?
    
    
    let welcome_heading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Welcome"
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let limboExplanation : UITextView = {
        let textView = UITextView()
        textView.text = "xxx"
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        //textView.font = UIFont.boldSystemFont(ofSize: textView.font.pointSize) // just example
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        var frame = textView.frame
        frame.size.height = 24
        textView.frame = frame
        textView.backgroundColor = .clear
        
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let access_limited_heading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Access: Limited"
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let access_limited_description : UITextView = {
        let textView = UITextView()
        textView.text = "You currently have Limited Access to TelePatriot.  With Limited Access, you can record video messages of support for the Convention of States and this app will automatically upload them to YouTube, Facebook and Twitter.  Click \"Show Me How\" to find out how."
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        textView.translatesAutoresizingMaskIntoConstraints = false
        //        var frame = textView.frame
        //        frame.size.height = 24
        //        textView.frame = frame
        textView.backgroundColor = .clear
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let show_me_how_button : BaseButton = {
        let button = BaseButton(text: "Show Me How")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickShowMeHow(_:)), for: .touchUpInside)
        return button
    }()
    
    let full_access_heading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Full Access"
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let full_access_description : UITextView = {
        let textView = UITextView()
        textView.text = "For Full Access to TelePatriot, there are two legal requirement you must meet.  They are described below."
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        textView.translatesAutoresizingMaskIntoConstraints = false
        //        var frame = textView.frame
        //        frame.size.height = 24
        //        textView.frame = frame
        textView.backgroundColor = .clear
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let legal_requirement_1_heading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Legal Requirement #1"
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let legal_requirement_1 : UITextView = {
        let textView = UITextView()
        textView.text = "You must sign the Convention of States petition"
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        textView.translatesAutoresizingMaskIntoConstraints = false
//        var frame = textView.frame
//        frame.size.height = 24
//        textView.frame = frame
        textView.backgroundColor = .clear
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let sign_petition_button : BaseButton = {
        let button = BaseButton(text: "Sign the Petition")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickSignPetition(_:)), for: .touchUpInside)
        return button
    }()
    
    let legal_requirement_2_heading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Legal Requirement #2"
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let legal_requirement_2 : UITextView = {
        let textView = UITextView()
        textView.text = "You must sign the Convention of States confidentiality agreement"
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        textView.translatesAutoresizingMaskIntoConstraints = false
        //        var frame = textView.frame
        //        frame.size.height = 24
        //        textView.frame = frame
        textView.backgroundColor = .clear
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let sign_confidentiality_agreement_button : BaseButton = {
        let button = BaseButton(text: "Sign the Confidentiality Agreement")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickSignConfidentialityAgreement(_:)), for: .touchUpInside)
        return button
    }()
    
    let when_finished_heading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "When Finished..."
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let when_finished : UITextView = {
        let textView = UITextView()
        textView.text = "Once you have signed both documents, click \"Done\" below"
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        textView.translatesAutoresizingMaskIntoConstraints = false
        //        var frame = textView.frame
        //        frame.size.height = 24
        //        textView.frame = frame
        textView.backgroundColor = .clear
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let done_button : BaseButton = {
        let button = BaseButton(text: "Done")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickDone(_:)), for: .touchUpInside)
        return button
    }()
    
    
    
//    let accountStatusHeaderLabel : UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Account Status"
//        return label
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "TelePatriot" // what the user sees (across the top) when they first login
        
        // Is this going to work?  We should never come to this view except on brand new users
        isBrandNewUser = true
        
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        if let scrollView = scrollView {
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: 2000)
            
            scrollView.addSubview(welcome_heading)
            welcome_heading.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
            welcome_heading.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(limboExplanation)
            limboExplanation.topAnchor.constraint(equalTo: welcome_heading.bottomAnchor, constant: 8).isActive = true
            limboExplanation.leadingAnchor.constraint(equalTo: welcome_heading.leadingAnchor, constant: 0).isActive = true
            limboExplanation.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
            
            scrollView.addSubview(access_limited_heading)
            access_limited_heading.topAnchor.constraint(equalTo: limboExplanation.bottomAnchor, constant: 32).isActive = true
            access_limited_heading.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(access_limited_description)
            access_limited_description.topAnchor.constraint(equalTo: access_limited_heading.bottomAnchor, constant: 8).isActive = true
            access_limited_description.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            access_limited_description.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
            
            scrollView.addSubview(show_me_how_button)
            show_me_how_button.topAnchor.constraint(equalTo: access_limited_description.bottomAnchor, constant: 16).isActive = true
            show_me_how_button.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
            
            scrollView.addSubview(full_access_heading)
            full_access_heading.topAnchor.constraint(equalTo: show_me_how_button.bottomAnchor, constant: 32).isActive = true
            full_access_heading.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(full_access_description)
            full_access_description.topAnchor.constraint(equalTo: full_access_heading.bottomAnchor, constant: 8).isActive = true
            full_access_description.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            full_access_description.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
            
            scrollView.addSubview(legal_requirement_1_heading)
            legal_requirement_1_heading.topAnchor.constraint(equalTo: full_access_description.bottomAnchor, constant: 32).isActive = true
            legal_requirement_1_heading.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(legal_requirement_1)
            legal_requirement_1.topAnchor.constraint(equalTo: legal_requirement_1_heading.bottomAnchor, constant: 8).isActive = true
            legal_requirement_1.leadingAnchor.constraint(equalTo: legal_requirement_1_heading.leadingAnchor, constant: 0).isActive = true
            legal_requirement_1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
            
            scrollView.addSubview(sign_petition_button)
            sign_petition_button.topAnchor.constraint(equalTo: legal_requirement_1.bottomAnchor, constant: 16).isActive = true
            sign_petition_button.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
            
            scrollView.addSubview(legal_requirement_2_heading)
            legal_requirement_2_heading.topAnchor.constraint(equalTo: sign_petition_button.bottomAnchor, constant: 32).isActive = true
            legal_requirement_2_heading.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(legal_requirement_2)
            legal_requirement_2.topAnchor.constraint(equalTo: legal_requirement_2_heading.bottomAnchor, constant: 8).isActive = true
            legal_requirement_2.leadingAnchor.constraint(equalTo: legal_requirement_2_heading.leadingAnchor, constant: 0).isActive = true
            legal_requirement_2.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
            
            scrollView.addSubview(sign_confidentiality_agreement_button)
            sign_confidentiality_agreement_button.topAnchor.constraint(equalTo: legal_requirement_2.bottomAnchor, constant: 16).isActive = true
            sign_confidentiality_agreement_button.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
            
            scrollView.addSubview(when_finished_heading)
            when_finished_heading.topAnchor.constraint(equalTo: sign_confidentiality_agreement_button.bottomAnchor, constant: 32).isActive = true
            when_finished_heading.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(when_finished)
            when_finished.topAnchor.constraint(equalTo: when_finished_heading.bottomAnchor, constant: 8).isActive = true
            when_finished.leadingAnchor.constraint(equalTo: when_finished_heading.leadingAnchor, constant: 0).isActive = true
            when_finished.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
            
            scrollView.addSubview(done_button)
            done_button.topAnchor.constraint(equalTo: when_finished.bottomAnchor, constant: 16).isActive = true
            done_button.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
            
            view.addSubview(scrollView)
        }
        
        
        
        
//        view.addSubview(limboExplanation)
//        view.addSubview(accountStatusHeaderLabel)
        
//        limboExplanation.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
//        limboExplanation.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
//        limboExplanation.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
//        limboExplanation.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.15).isActive = true
        
//        accountStatusHeaderLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
//        accountStatusHeaderLabel.topAnchor.constraint(equalTo: limboExplanation.bottomAnchor, constant: 8).isActive = true
//        accountStatusHeaderLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
//        view.addSubview(date)
//        date.topAnchor.constraint(equalTo: accountStatusHeaderLabel.bottomAnchor, constant: 8).isActive = true
//        date.leadingAnchor.constraint(equalTo: accountStatusHeaderLabel.leadingAnchor, constant: 0).isActive = true
//
//        view.addSubview(event)
//        event.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 8).isActive = true
//        event.leadingAnchor.constraint(equalTo: date.leadingAnchor, constant: 0).isActive = true
        
        
//        tableViewAccountStatusEvents = UITableView(frame: CGRect(x: 10, y: 200, width: 350, height: 400), style: .plain) // <--- this turned out to be key
//        tableViewAccountStatusEvents?.dataSource = self
//        tableViewAccountStatusEvents?.register(AccountStatusEventTableViewCell.self, forCellReuseIdentifier: "cellId")
//        tableViewAccountStatusEvents?.rowHeight = 110
//        view.addSubview(tableViewAccountStatusEvents!)
        
        
        // The user object fires roleAssigned() which calls all listeners
        // This call makes this class one of those listeners
        // See also roleAssigned() in this class
        
        // https://stackoverflow.com/a/44403725
        // Hide the back button on this screen.  Don't want the user to be able to go anywhere
        // until they are assigned to a group
        self.navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
        limboExplanation.text = TPUser.sharedInstance.getName() /*"Brent Dunklau"*/ +
            ", welcome to TelePatriot. This app is a powerful tool for supporters of the Convention of States Project."
        
        if TPUser.sharedInstance.getEmail() == "email not available" {
            legal_requirement_1.text = "You must sign the Convention of States petition using a confirmed email address.  Unfortunately, your email address has not been confirmed by the Facebook or Google (whoever you logged in with). We cannot grant you access to this app until we have an email address that has been confirmed by Facebook/Google.  We apologize for the inconvenience."
            
            legal_requirement_2.text = "You must sign the Convention of States confidentiality agreement using a confirmed email address.  Unfortunately, your email address has not been confirmed by the Facebook or Google (whoever you logged in with). We cannot grant you access to this app until we have an email address that has been confirmed by Facebook/Google.  We apologize for the inconvenience."
        }
        else {
            legal_requirement_1.text = "You must sign the Convention of States petition using this email address: \(TPUser.sharedInstance.getEmail())"
            legal_requirement_2.text = "You must sign the Convention of States confidentiality agreement using this email address: \(TPUser.sharedInstance.getEmail())"
        }
        
        
        //let nibName = UINib(nibName: "AccountStatusEventTableViewCell", bundle: nil)
        //tableViewAccountStatusEvents.register(nibName, forCellReuseIdentifier: "cellId")
        
//        fetchAccountStatusEvents(uid: TPUser.sharedInstance.getUid(), name: TPUser.sharedInstance.getName())
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
    
    @objc private func clickShowMeHow(_ sender:UIButton) {
        // go to the Show Me How page
        
        // Android: LimboActivity:show_me_how_button does this:  startActivity(new Intent(LimboActivity.this, ShowMeHowActivity.class));
        
        let vc = ShowMeHowVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func clickDone(_ sender:UIButton) {
        let now = Util.getDate_as_millis()
        done_button.setTitle("Verifying...", for: .normal)
        let evt = CBAPIEvent(uid: TPUser.sharedInstance.getUid(), name: TPUser.sharedInstance.getName(), email: TPUser.sharedInstance.getEmail(), event_type: "check legal")
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
                        self.done_button.setTitle("Good", for: .normal) }
                    else {
                        self.done_button.setTitle("Signatures Not Received Yet", for: .normal) }
                }
            }
                
        })
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    static func createInvitations(snapshot: DataSnapshot) -> [VideoInvitation] {
//        var invitations = [VideoInvitation]()
//        let children = snapshot.children
//        var counter = 0
//        while let snap = children.nextObject() as? DataSnapshot {
//            let invitation = VideoInvitation(snapshot: snap)
//            invitations.append(invitation)
//        }
//        return invitations
//    }
    
    
//    func fetchAccountStatusEvents(uid: String, name: String) {
//        Database.database().reference().child("users")
//            .child(uid).child("account_status_events")
//            .queryLimited(toLast: 1) // just display the latest event
//            .observe(.value, with: {(snapshot) in
//            let children = snapshot.children
//            print("fetchAccountStatusEvents: begin while")
//            while let snap = children.nextObject() as? DataSnapshot {
//
//                if let dictionary = snap.value as? [String : Any],
//                    let thedate = dictionary["date"] as? String,
//                    let theevent = dictionary["event"] as? String
//                {
//                    self.date.text = thedate
//                    self.event.text = theevent
//                    print("fetchAccountStatusEvents: key=\(snap.key) theevent=\(theevent)")
//                }
//            }
//
//        }, withCancel: nil)
//    }
    
    
//    func fetchAccountStatusEvents_orig(uid: String, name: String) {
//        Database.database().reference().child("users").child(uid).child("account_status_events").observe(.childAdded, with: {(snapshot) in
//
//            guard let dictionary = snapshot.value as? [String : String] else { return }
//            guard let thedate = dictionary["date"] else { return }
//            guard let event = dictionary["event"] else { return }
//            let accountStatusEvent = AccountStatusEvent(thedate: thedate, event: event)
//
//            self.accountStatusEvents.append(accountStatusEvent)
//            DispatchQueue.main.async{
//                self.tableViewAccountStatusEvents?.reloadData()
//
//                // this is what automatically scrolls the list to the bottom row when the admin takes action
//                // on this new person's account.  There aren't usually enough rows to matter in this case (admins reviewing
//                // and approving new people) but we'll end up using this code in other areas.
//                let index = IndexPath(row: self.accountStatusEvents.count-1, section: 0) // use your index number or Indexpath
//                self.tableViewAccountStatusEvents?.scrollToRow(at: index, at: .bottom, animated: true)
//            }
//
//        }, withCancel: nil)
//    }
    
    
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
    
    func teamSelected(team: Team, whileLoggingIn: Bool) {
        // do nothing
    }
    
    func userSignedOut() {
        // do nothing
    }
    
    
//    // required by UITableViewDataSource
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return accountStatusEvents.count
//    }
//
//    // required by UITableViewDataSource
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableViewAccountStatusEvents?.dequeueReusableCell(withIdentifier: "cellId",
//                                                                     for: indexPath as IndexPath) as! AccountStatusEventTableViewCell
//
//        let accountStatusEvent = accountStatusEvents[indexPath.row]
//        cell.configureCell(accountStatusEvent: accountStatusEvent)
//
//        return cell
//    }
    

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
