//
//  NewPhoneCampaignVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/5/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class NewPhoneCampaignVC: BaseViewController {
    
    // following the delegate pattern...
    var submitHandler : NewPhoneCampaignSubmittedHandler?
    
    let missionTitleField : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "Mission Title"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let urlLabel : UILabel = {
        let l = UILabel()
        l.text = "Spreadsheet URL"
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let spreadsheetUrlField : UITextView = {
        let v = UITextView()
        //let borderColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        v.layer.borderWidth = 0.5
        //v.layer.borderColor = borderColor.cgColor
        v.layer.cornerRadius = 5.0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let submitButton : BaseButton = {
        let b = BaseButton(text: "Submit")
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(okPressed), for: .touchUpInside)
        return b
    }()
    
    var missionNode : String = "missions" // ChooseSpreadsheetTypeVC could change this to "master_missions"
    
    
    // https://www.youtube.com/watch?v=joVi3thZOqc
    //let rootRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(missionTitleField)
        view.addSubview(urlLabel)
        view.addSubview(spreadsheetUrlField)
        view.addSubview(submitButton)

        
        missionTitleField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        missionTitleField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16).isActive = true
        missionTitleField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90).isActive = true
        missionTitleField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
        missionTitleField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.06).isActive = true
        
        urlLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        urlLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 8).isActive = true
        urlLabel.topAnchor.constraint(equalTo: missionTitleField.bottomAnchor, constant: 8).isActive = true
        urlLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        urlLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        
        spreadsheetUrlField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        spreadsheetUrlField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16).isActive = true
        spreadsheetUrlField.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 0).isActive = true
        spreadsheetUrlField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
        spreadsheetUrlField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
        
        
        submitButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //submitButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        //submitButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16).isActive = true
        submitButton.topAnchor.constraint(equalTo: spreadsheetUrlField.bottomAnchor, constant: 16).isActive = true
        submitButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        submitButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true

    }
    
    
    func clearFields() {
        missionTitleField.text = ""
        spreadsheetUrlField.text = ""
    }
    
    
    /*@IBAction*/ @objc func okPressed(_ sender: Any) {
        
        guard let team = TPUser.sharedInstance.getCurrentTeam()?.getName() else {
            return
        }
        let rootRef = Database.database().reference()
        let key = rootRef.child("teams/\(team)/\(missionNode)").childByAutoId().key
        let uid : String = Auth.auth().currentUser!.uid
        let name : String = Auth.auth().currentUser!.displayName!
        let url : String = spreadsheetUrlField.text
        let mission_name : String = missionTitleField.text!
        let uid_and_active : String = Auth.auth().currentUser!.uid + "_false"
        
        let missionVals: [String:Any] = ["uid": uid,
                    "name": name,
                    "url": url,
                    "mission_name": mission_name,
                    "active": false,
                    "mission_type": "Phone Campaign",
                    "uid_and_active": uid_and_active]
        
        let mission = ["teams/\(team)/\(missionNode)/\(key)": missionVals]
        // example of multi-path update
        rootRef.updateChildValues(mission, withCompletionBlock: { (error:Error?, ref:DatabaseReference) in
                // not sure how to handle the NSError yet
                // just handle success for now
            
                // On success, send the user to "All My Missions"
                // See ContainerViewController.  That's where we assign submitHandler to CenterViewController
                self.submitHandler?.newPhoneCampaignSubmitted()
            
            }) //as! (Error?, DatabaseReference) -> Void)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

/**********/
 
 protocol NewPhoneCampaignSubmittedHandler {
     func newPhoneCampaignSubmitted()
 }

 /********/

