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
    
    let descriptionTextView : UITextView = {
        let textView = UITextView()
        textView.text = "Searching for a mission..."
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
    
    /*******
    let scrollView : UIScrollView = {
        let s = UIScrollView()
        s.backgroundColor = UIColor.black
        return s
    }()
     *******/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
        scrollView.addSubview(callButton1)
        
        view.addSubview(scrollView)
        
         /***********
         scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
         scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 55).isActive = true
         scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
         scrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1).isActive = true
        ***********/
        
        
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
         
        callButton1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        callButton1.topAnchor.constraint(equalTo: descriptionTextView
            .bottomAnchor, constant: 8).isActive = true
        callButton1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
        callButton1.addTarget(self, action: #selector(makeCall(_:)), for: .touchUpInside)
        
        
        
        
        
        
        /****************
        
        
        descriptionHeaderLabel.text = "Mission Description"
        scriptHeaderLabel.text = "Script"
        
        view.addSubview(descriptionHeaderLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(scriptHeaderLabel)
        view.addSubview(scriptTextView)
        view.addSubview(callButton1)
        
        descriptionHeaderLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        descriptionHeaderLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 55).isActive = true
        descriptionHeaderLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        descriptionHeaderLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        
        descriptionTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: descriptionHeaderLabel.bottomAnchor).isActive = true
        descriptionTextView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
        //descriptionTextView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        
        scriptHeaderLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        scriptHeaderLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8).isActive = true
        scriptHeaderLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        //scriptHeaderLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        
        scriptTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        scriptTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16).isActive = true
        scriptTextView.topAnchor.constraint(equalTo: scriptHeaderLabel.bottomAnchor, constant: 8).isActive = true
        scriptTextView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
        //scriptTextView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        
        callButton1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        callButton1.topAnchor.constraint(equalTo: scriptTextView.bottomAnchor, constant: 8).isActive = true
        callButton1.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        callButton1.addTarget(self, action: #selector(makeCall(_:)), for: .touchUpInside)
        *****************/
        
        
        // might also want to look into this: https://stackoverflow.com/a/31428932
        // to try to get elements positioned relative to the nav bar at the top
        
        fetchMission(parent: self.parent)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("MyMissionViewController: viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let centerVc = parent as? CenterViewController {
            centerVc.unassignMissionItem()
        }
    }
    
    func myResumeFunction() {
        fetchMission(parent: self.parent)
    }
    
    
    @objc func makeCall(_ sender: CallButton) {
        guard let ph = sender.phone else { return }
        guard let number = URL(string: "tel://"+ph) else { return }
        UIApplication.shared.open(number)
    }
    

    func fetchMission(parent: UIViewController?) {
        
        // TODO won't always be this...
        let team = "The Cavalry"
        
        Database.database().reference()
            .child("teams/\(team)/mission_items")
            .queryOrdered(byChild: "group_number")
            .queryLimited(toFirst: 1)
            .observeSingleEvent(of: .value, with: {(snapshot) in
                
                guard let entries = snapshot.value as? [String:[String:AnyObject]] else {
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
        
                    guard let description = mission_item_elements["description"] as? String,
                        let mission_id = mission_item_elements["mission_id"] as? String,
                        let script = mission_item_elements["script"] as? String,
                        let phone1 = mission_item_elements["phone"] as? String,
                        let name1 = mission_item_elements["name"] as? String,
                        let uid = mission_item_elements["uid"] as? String else { return }
        
                    // viewWillDisappear() doesn't get called because of the way we just add subviews to the CenterViewController
                    // so we need some other way to tell when this view goes visible/invisible.  This is what I came up with:
                    // Pass the mission_item_id to the parent view controller.  Then, in that controller (CenterViewController),
                    // we handle switching views, and it's there that we can un-assign this mission
                    // See CenterViewController.didSelectSomething()
                    if let centerVc = parent as? CenterViewController {
                        centerVc.mission_item_id = mission_item_id
                    }
                    
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
                    
                    Database.database().reference()
                        .child("teams/\(team)/mission_items/\(mission_item_id)/accomplished").setValue("in progress")
                    
                    Database.database().reference()
                        .child("teams/\(team)/mission_items/\(mission_item_id)/active_and_accomplished").setValue("true_in progress")
                    
                    let mi = MissionItem(mission_id: mission_id, mission_item_id: mission_item_id, phone: phone1, name: name1, uid: uid)
                    TPUser.sharedInstance.currentMissionItem = mi
                    
                } // end for
                    
            
        }, withCancel: nil)
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
