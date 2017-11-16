//
//  LimboViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/14/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class LimboViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var accountStatusEvents = [AccountStatusEvent]()

    @IBOutlet weak var limboExplanation: UITextView!
    
    @IBOutlet weak var tableViewAccountStatusEvents: UITableView! {
        didSet {
            self.tableViewAccountStatusEvents.dataSource = self
            self.tableViewAccountStatusEvents.rowHeight = 100
        }
    }
    
    @IBAction func chatHelpPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            }
            
        }, withCancel: nil)
    }

}
