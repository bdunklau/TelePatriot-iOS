//
//  LimboViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/14/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class LimboViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AccountStatusEventListener {
    
    var isBrandNewUser : Bool?
    var accountStatusEvents = [AccountStatusEvent]()

    //@IBOutlet weak var limboExplanation: UITextView!
    var limboExplanation = UITextView()
    
    /******
    @IBOutlet weak var tableViewAccountStatusEvents: UITableView! {
        didSet {
            self.tableViewAccountStatusEvents.dataSource = self
            self.tableViewAccountStatusEvents.rowHeight = 90
        }
    }
    ********/
    var tableViewAccountStatusEvents = UITableView()
    
    @IBAction func chatHelpPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Is this going to work?  We should never come to this view except on brand new users
        isBrandNewUser = true
        
        self.tableViewAccountStatusEvents.dataSource = self
        self.tableViewAccountStatusEvents.rowHeight = 90
        
        // The user object fires roleAssigned() which calls all listeners
        // This call makes this class one of those listeners
        // See also roleAssigned() in this class
        if(TPUser.sharedInstance.accountStatusEventListeners.count == 0
            || !TPUser.sharedInstance.accountStatusEventListeners.contains(where: { String(describing: type(of: $0)) == "LimboViewController" })) {
            print("LimboViewController: adding self to list of accountStatusEventListeners")
            TPUser.sharedInstance.accountStatusEventListeners.append(self)
        } else { print("LimboViewController: NOT adding self to list of accountStatusEventListeners") }
        
        // https://stackoverflow.com/a/44403725
        // Hide the back button on this screen.  Don't want the user to be able to go anywhere
        // until they are assigned to a group
        self.navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
        limboExplanation.text = TPUser.sharedInstance.getName() /*"Brent Dunklau"*/ + limboExplanation.text
        
        
        let nibName = UINib(nibName: "AccountStatusEventTableViewCell", bundle: nil)
        tableViewAccountStatusEvents.register(nibName, forCellReuseIdentifier: "cellId")
        
        fetchAccountStatusEvents(uid: TPUser.sharedInstance.getUid(), name: TPUser.sharedInstance.getName())
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
    
    
    // required by UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountStatusEvents.count
    }
    
    // required by UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewAccountStatusEvents.dequeueReusableCell(withIdentifier: "cellId",
                                                 for: indexPath as IndexPath) as! AccountStatusEventTableViewCell
        
        let accountStatusEvent = accountStatusEvents[indexPath.row]
        cell.commonInit(accountStatusEvent: accountStatusEvent)
        
        return cell
    }
    
    
    func fetchAccountStatusEvents(uid: String, name: String) {
        Database.database().reference().child("users").child(uid).child("account_status_events").observe(.childAdded, with: {(snapshot) in
            
            guard let dictionary = snapshot.value as? [String : String] else { return }
            guard let thedate = dictionary["date"] else { return }
            guard let event = dictionary["event"] else { return }
            let accountStatusEvent = AccountStatusEvent(thedate: thedate, event: event)
            
            self.accountStatusEvents.append(accountStatusEvent)
            DispatchQueue.main.async{
                self.tableViewAccountStatusEvents.reloadData()
            
                // this is what automatically scrolls the list to the bottom row when the admin takes action
                // on this new person's account.  There aren't usually enough rows to matter in this case (admins reviewing
                // and approving new people) but we'll end up using this code in other areas.
                let index = IndexPath(row: self.accountStatusEvents.count-1, section: 0) // use your index number or Indexpath
                self.tableViewAccountStatusEvents.scrollToRow(at: index, at: .bottom, animated: true)
            }
            
        }, withCancel: nil)
    }
    
    
    // required by AccountStatusEventListener
    func roleAssigned(role: String) {
        guard let isNewUser = isBrandNewUser else { return }
        
        if(!isNewUser) { return }
        
        isBrandNewUser = false // so that the stuff below never gets called again
        
        // we only care on the very first role assigned
        //let byPassLogin = true
        //self.performSegue(withIdentifier: "HomeViewController", sender: byPassLogin)
        let home = HomeViewController()
        home.byPassLogin = true
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    // required by AccountStatusEventListener
    func roleRemoved(role: String) {
        // do nothing
    }
    
    /***** not using storyboards anymore
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! HomeViewController
        vc.byPassLogin = true
    }
    ******/

}
