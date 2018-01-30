//
//  MyMissionViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/23/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class MyMissionViewController : BaseViewController {
    
    var callButton1 = CallButton(text: "")
    var callButton2 = CallButton(text: "")
    var noMissionLabel = UILabel()
    //var noMissionDelegate : NoMissionDelegate?
    
    let descriptionHeaderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scriptHeaderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static var NO_MISSIONS_FOUND_MESSAGE = "No missions found yet for this team..."
    
    let descriptionTextView : UITextView = {
        let textView = UITextView()
        textView.text = NO_MISSIONS_FOUND_MESSAGE
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
    
    let scriptTextView : UITextView = {
        let textView = UITextView()
        textView.text = "Searching for a mission..."
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        //textView.font = UIFont.boldSystemFont(ofSize: textView.font.pointSize) // just example
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTheView()
    }
    
    private func loadTheView() {
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height))
        scrollView.contentSize = CGSize(width: 250, height: 1450)
        //scrollView.backgroundColor = UIColor.red
        
        
        scrollView.addSubview(descriptionHeaderLabel)
        scrollView.addSubview(descriptionTextView)
        /************
         // see the TODO down in fetchMission for explanation why we aren't including these elements
         scriptHeaderLabel.text = "Script"
         scrollView.addSubview(scriptHeaderLabel)
         scrollView.addSubview(scriptTextView)
         ***********/
        
        view.addSubview(scrollView)
        
        
        descriptionHeaderLabel.text = "Mission Description"
        descriptionHeaderLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        descriptionHeaderLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 35).isActive = true
        descriptionHeaderLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
        //descriptionHeaderLabel.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1).isActive = true
        
        descriptionTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: descriptionHeaderLabel.bottomAnchor).isActive = true
        descriptionTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
        //descriptionTextView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor, multiplier: 0.25).isActive = true
        
        /************
         // see the TODO down in fetchMission for explanation why we aren't including these elements
         scriptHeaderLabel.text = "Script"
         scriptHeaderLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
         scriptHeaderLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8).isActive = true
         scriptHeaderLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
         //scriptHeaderLabel.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor, multiplier: 0.25).isActive = true
         
         scriptTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
         scriptTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16).isActive = true
         scriptTextView.topAnchor.constraint(equalTo: scriptHeaderLabel.bottomAnchor, constant: 8).isActive = true
         scriptTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
         //scriptTextView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1).isActive = true
         ************/
        
        scrollView.addSubview(callButton1)
        callButton1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        callButton1.topAnchor.constraint(equalTo: descriptionTextView
            .bottomAnchor, constant: 8).isActive = true
        callButton1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
        callButton1.addTarget(self, action: #selector(makeCall(_:)), for: .touchUpInside)
        
        
        scrollView.addSubview(callButton2)
        callButton2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        callButton2.topAnchor.constraint(equalTo: callButton1.bottomAnchor, constant: 24).isActive = true
        callButton2.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
        callButton2.addTarget(self, action: #selector(makeCall(_:)), for: .touchUpInside)
        
        
        // might also want to look into this: https://stackoverflow.com/a/31428932
        // to try to get elements positioned relative to the nav bar at the top
        
        fetchMission(parent: self.parent)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("MyMissionViewController: viewWillAppear")
        loadTheView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let centerVc = parent as? CenterViewController else {
            return
        }
        
        centerVc.unassignMissionItem()
    }
    
    func myResumeFunction() {
        fetchMission(parent: self.parent)
    }
    
    
    // call end is recorded in AppDelegate.onCallEnded()
    @objc func makeCall(_ sender: CallButton) {
        guard let ph = sender.phone else { return }
        guard let number = URL(string: "tel://"+ph) else { return }
        guard let mission_name = TPUser.sharedInstance.currentMissionItem?.mission_name else { return }
        guard let supporter_name = TPUser.sharedInstance.currentMissionItem?.name else { return }
        
        // In Android, MyMissionFragment.call() creates a MissionItemEvent
        // Here's what we have to save:  event_date, event_type, mission_name, phone, supporter_phone, volunteer_name, volunteer_phone, volunteer_uid
        let m = MissionItemEvent(event_type: "is calling",
                                 volunteer_uid: TPUser.sharedInstance.getUid(),
                                 volunteer_name: TPUser.sharedInstance.getName(),
                                 mission_name: mission_name,
                                 phone: ph,
                                 volunteer_phone: "phone number not available", // <- this sucks https://stackoverflow.com/a/40719308
            supporter_name: supporter_name,
            event_date: getDateString())
        
        // the "guard" will unwrap the team name.  Otherwise, you'll get nodes written to the
        // database like this...  Optional("The Cavalry")
        guard let team = TPUser.sharedInstance.getCurrentTeam()?.team_name else {
            return
        }
        let ref = Database.database().reference().child("teams/\(team)/activity")
        ref.child("all").childByAutoId().setValue(m.dictionary())
        ref.child("by_phone_number").child(ph).childByAutoId().setValue(m.dictionary())
        
        // now do the call
        UIApplication.shared.open(number)
    }
    
    func getDateString() -> String {
        return Util.getDate_Day_MMM_d_hmmss_am_z_yyyy()
    }
    
    
    
    func fetchMission(parent: UIViewController?) {
        
        guard let team = TPUser.sharedInstance.getCurrentTeam()?.team_name else {
            return
        }
        
        if TPUser.sharedInstance.currentMissionItem == nil {
            // This would happen if the user was looking at a mission, then swiped to get
            // the menu, then touched "My Mission"
            // If the user happens to do this, we don't want to get ANOTHER mission.
            // We need to serve up the current "in progress" mission.  Otherwise, the mission
            // the user was looking at will become an orphan and no one will end up working it.
            
            // Similar to MyMissionFragment.workThis() in Android
            // On iOS, we don't actually have to do anything when the mission item
            // already exists.  On Android, we have to reset the text fields
            
            
            Database.database().reference()
                .child("teams/\(team)/mission_items")
                .queryOrdered(byChild: "group_number")
                .queryLimited(toFirst: 1)
                .observeSingleEvent(of: .value, with: {(snapshot) in
                    
                    guard let entries = snapshot.value as? [String:[String:AnyObject]] else {
                        self.indicateNoMissionsAvailable()
                        return }
                    
                    // mission_item_id is a key node under /mission_items
                    // mission_item_elements are all the nodes under /mission_items/{mission_item_id}
                    for (mission_item_id,mission_item_elements) in entries {
                        print("mission_item_id is...")
                        print(mission_item_id)
                        print(mission_item_elements)
                        /*************** this is what print(dict) shows...
                         ["name": Walker, Jim, "active_and_accomplished": true_new, "email": jimwalkerwhitefishmontana@gmail.com, "accomplished": new, "description": Here we are testing 3way calls, "name2": Pretend Legislator, "uid_and_active": ApvMfQc4ixUeNZkEREIiUMHzAdP2_true, "active": 1, "uid": ApvMfQc4ixUeNZkEREIiUMHzAdP2, "mission_id": -KyUE52JKX3QVDH1D57f, "phone2": 719-567-6742, "mission_create_date": Nov 8, 2017 11:24 pm CST, "phone": 2146325613, "mission_name": Montana Mission 11:23, "mission_type": Phone Campaign, "url": https://docs.google.com/spreadsheets/d/1-qLih2jZFE2QEwUY7-H4dowp1Pk0dCReYmRDWZP0e_g/edit?usp=drivesdk, "script": There is no script in this case because we aren't actually calling anyone.  The 3rd "person" in this case is just an auto-attendant giving out the current time.]
                         **************/
                        
                        guard let group_number = mission_item_elements["group_number"] as? Int,
                            group_number != 999999
                            else {
                                // if all we got was a 999999, then this item is being worked by someone else and
                                // there basically are no more missions for this user
                                self.indicateNoMissionsAvailable()
                                return
                        }
                        
                        guard let description = mission_item_elements["description"] as? String,
                            let accomplished = mission_item_elements["accomplished"] as? String,
                            let active = mission_item_elements["active"] as? Bool,
                            let active_and_accomplished = mission_item_elements["active_and_accomplished"] as? String,
                            //let email = mission_item_elements["email"] as? String,
                            let mission_create_date = mission_item_elements["mission_create_date"] as? String,
                            let mission_id = mission_item_elements["mission_id"] as? String,
                            let mission_name = mission_item_elements["mission_name"] as? String,
                            let mission_type = mission_item_elements["mission_type"] as? String,
                            let name1 = mission_item_elements["name"] as? String,
                            let phone1 = mission_item_elements["phone"] as? String,
                            let script = mission_item_elements["script"] as? String,
                            let uid = mission_item_elements["uid"] as? String,
                            let uid_and_active = mission_item_elements["uid_and_active"] as? String,
                            let url = mission_item_elements["url"] as? String,
                            let number_of_missions_in_master_mission = mission_item_elements["number_of_missions_in_master_mission"] as? Int
                            else {
                                return }
                        
                        //let button1Text = name1 + " " + phone1
                        DispatchQueue.main.async {
                            self.callButton1.setTitle(name1 + " " + phone1, for: .normal)
                        }
                        self.callButton1.phone = phone1
                        
                        // TODO boy this is ugly.  Had a bitch of a time getting scrolling to work on the "My Mission"
                        // screen.  It would scroll until I added the second UITextView for the script.  So I am re-purposing
                        // the description field to also contain the script
                        self.descriptionTextView.text = description + "\n\n\n\nScript\n\n" + script
                        //self.scriptTextView.text = script
                        
                        if let phone2 = mission_item_elements["phone2"] as? String, let name2 = mission_item_elements["name2"] as? String {
                            let button2Text = name2 + " " + phone2
                            self.callButton2.setTitle(button2Text, for: .normal)
                            self.callButton2.phone = phone2
                        }
                        else {
                            self.callButton2.setTitle("", for: .normal)
                            //self.callButton2.phone = phone2
                        }
                        
                        Database.database().reference()
                            .child("teams/\(team)/mission_items/\(mission_item_id)/accomplished").setValue("in progress")
                        
                        Database.database().reference()
                            .child("teams/\(team)/mission_items/\(mission_item_id)/active_and_accomplished").setValue("true_in progress")
                        
                        Database.database().reference()
                            .child("teams/\(team)/mission_items/\(mission_item_id)/group_number_was").setValue(group_number)
                        
                        Database.database().reference()
                            .child("teams/\(team)/mission_items/\(mission_item_id)/group_number").setValue(999999)
                        
                        
                        let mi = MissionItem(mission_item_id: mission_item_id,
                                             accomplished: accomplished,
                                             active: active,
                                             active_and_accomplished: active_and_accomplished,
                                             description: description,
                                             //email: email,
                            mission_create_date: mission_create_date,
                            mission_id: mission_id,
                            mission_name: mission_name,
                            mission_type: mission_type,
                            name: name1,
                            phone: phone1,
                            script: script,
                            uid: uid,
                            uid_and_active: uid_and_active,
                            url: url,
                            group_number: group_number,
                            number_of_missions_in_master_mission: number_of_missions_in_master_mission)
                        
                        mi.group_number_was = group_number
                        mi.group_number = 999999
                        
                        TPUser.sharedInstance.currentMissionItem = mi
                        
                    } // end for
                    
                    
                }, withCancel: nil)
            
        } // if TPUser.sharedInstance.currentMissionItem != nil
        
    }
    
    
    func indicateNoMissionsAvailable() {
        descriptionTextView.text = MyMissionViewController.NO_MISSIONS_FOUND_MESSAGE
        callButton1.setTitle("", for: .normal)
        callButton2.setTitle("", for: .normal)
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
}

/**********
 protocol NoMissionDelegate {
 func notifyNoMissions()
 }
 *********/

