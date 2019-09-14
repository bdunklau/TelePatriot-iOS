//
//  WrapUpCBCallingMissionVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/5/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

// on Android, see CBMissionItemWrapUpFragment.java
class CBMissionItemWrapUpVC: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var wrapUpCBCallDelegate : WrapUpCBCallDelegate? // defined at bottom
    
    // need drop down for outcome type
    var picker: UIPickerView = {
        let p = UIPickerView()
        return p
    }()
    
    // In Android, this list is in strings.xml   At some point, we should probably put this
    // list in the database
    //var pickerData = ["voice mail", "spoke on the phone", "number disconnected", "wrong number"] // this is what is was prior to 1/16/18
    var pickerData = ["Voicemail", "Talked on the phone", "3-way call",
                      "Wrong number", "Number disconnected"] /*, "None",<- bug here , "No answer"] */
    
    var outcome : String = "Voicemail"
    
    let whatHappenedLabel : UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "What happened on the call?..."
        l.translatesAutoresizingMaskIntoConstraints = false // <-- ALWAYS DO THIS !!!!!!
        return l
    }()
    
    let mission_person_name : UILabel = {
        let l = UILabel()
        l.text = ""
        l.translatesAutoresizingMaskIntoConstraints = false // <-- ALWAYS DO THIS !!!!!!
        return l
    }()
    
    let mission_person_phone : UILabel = {
        let l = UILabel()
        l.text = ""
        l.translatesAutoresizingMaskIntoConstraints = false // <-- ALWAYS DO THIS !!!!!!
        return l
    }()
    
    let mission_person_name2 : UILabel = {
        let l = UILabel()
        l.text = ""
        l.translatesAutoresizingMaskIntoConstraints = false // <-- ALWAYS DO THIS !!!!!!
        return l
    }()
    
    let mission_person_phone2 : UILabel = {
        let l = UILabel()
        l.text = ""
        l.translatesAutoresizingMaskIntoConstraints = false // <-- ALWAYS DO THIS !!!!!!
        return l
    }()
    
    let notesLabel : UILabel = {
        let l = UILabel()
        l.text = "Notes"
        l.translatesAutoresizingMaskIntoConstraints = false // <-- ALWAYS DO THIS !!!!!!
        return l
    }()
    
    // need UITextView for notes
    let notesField : UITextView = {
        let v = UITextView()
        //let borderColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        v.layer.borderWidth = 0.5
        //v.layer.borderColor = borderColor.cgColor
        v.layer.cornerRadius = 5.0
        v.translatesAutoresizingMaskIntoConstraints = false // <-- ALWAYS DO THIS !!!!!!
        return v
    }()
    
    // need button to submit
    let submitButton : BaseButton = {
        let btn = BaseButton(text: "Submit and Get Another Mission")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(submitWrapUp(_:)), for: .touchUpInside)
        return btn
    }()
    
    // need button to submit
    let submitAndQuitButton : BaseButton = {
        let btn = BaseButton(text: "Submit and Logout")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(submitWrapUpAndQuit(_:)), for: .touchUpInside)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // source:  https://codewithchris.com/uipickerview-example/
        // Connect data:
        //self.picker = UIPickerView()
        self.picker.delegate = self
        self.picker.dataSource = self
        
        self.picker.frame = CGRect(x: 0, y: 196, width: self.view.bounds.width, height: 100.0)
        picker.selectRow(-1, inComponent: 0, animated: false)
        
        view.addSubview(whatHappenedLabel)
        whatHappenedLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        whatHappenedLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
        whatHappenedLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        whatHappenedLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        
        view.addSubview(mission_person_name)
        mission_person_name.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        mission_person_name.topAnchor.constraint(equalTo: whatHappenedLabel.bottomAnchor, constant: -48).isActive = true

        view.addSubview(mission_person_phone)
        mission_person_phone.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        mission_person_phone.bottomAnchor.constraint(equalTo: mission_person_name.bottomAnchor, constant: 0).isActive = true

        view.addSubview(mission_person_name2)
        mission_person_name2.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 4).isActive = true
        mission_person_name2.topAnchor.constraint(equalTo: mission_person_name.bottomAnchor, constant: 8).isActive = true

        view.addSubview(mission_person_phone2)
        mission_person_phone2.leadingAnchor.constraint(equalTo: mission_person_phone.leadingAnchor, constant: 0).isActive = true
        mission_person_phone2.bottomAnchor.constraint(equalTo: mission_person_name2.bottomAnchor, constant: 0).isActive = true
        
        
        if view.subviews.contains(picker) {
            picker.removeFromSuperview()
            // I don't know why we have to do this.  Must be something different about UIPickerView's
            // We don't have to make sure other controls aren't added twice.  Unless they ARE added multiple
            // times and we just don't realize it because right on top of either other ... ?
        }
        
        notesField.text = ""
        outcome = "Voicemail" // reset to this value each time we come to this screen
        
        view.addSubview(picker)
        //pickerViewContainer.view.addSubview(picker)
        //view.addSubview(pickerViewContainer.view)
        //pickerViewContainer.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        picker.topAnchor.constraint(equalTo: whatHappenedLabel.bottomAnchor, constant: 32).isActive = true
        //picker.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 135).isActive = true
        picker.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        picker.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1).isActive = true
        
        view.addSubview(notesLabel)
        notesLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        notesLabel.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 8).isActive = true
        notesLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(notesField)
        notesField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        notesField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16).isActive = true
        notesField.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 0).isActive = true
        notesField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
        notesField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
        
        
        // But what if the user is taking a single action like calling his legislator?
        // There is no "next mission" in this case.  We have to intelligently figure out what the user's
        // next move is.
        view.addSubview(submitButton)
        submitButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        submitButton.topAnchor.constraint(equalTo: notesField.bottomAnchor, constant: 8).isActive = true
        submitButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
        view.addSubview(submitAndQuitButton)
        submitAndQuitButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        submitAndQuitButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 32).isActive = true
        submitAndQuitButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
        
        if let missionItem = TPUser.sharedInstance.currentCBMissionItem,
            let fname = missionItem.first_name, let lname = missionItem.last_name,
            let phone = missionItem.phone {
            mission_person_name.text = "\(fname) \(lname)"
            mission_person_phone.text = phone
            if let name2 = missionItem.name2, let phone2 = missionItem.phone2 {
                mission_person_name2.text = name2
                mission_person_phone2.text = phone2
            }
            else {
                mission_person_name2.text = ""
                mission_person_phone2.text = ""
            }
        }
    }
    
    
    @objc func submitWrapUp(_ sender: BaseButton) {
        doQuit = false
        saveNotes()
    }
    
    
    private func saveNotes() {
        guard let missionItem = TPUser.sharedInstance.currentCBMissionItem,
            let person_id = missionItem.person_id,
            let first_name = missionItem.first_name,
            let last_name = missionItem.last_name,
            let mission_id = missionItem.mission_id,
            let phone = missionItem.phone,
            let domain = missionItem.citizen_builder_domain,
            let apiKeyName = missionItem.citizen_builder_api_key_name,
            let apiKeyValue = missionItem.citizen_builder_api_key_value,
            let author_id = TPUser.sharedInstance.citizen_builder_id,
            let url = URL(string: "https://\(domain)/api/ios/v1/person_call/call_data")
            else {
                return
        }
        
        var notes = "no notes left"
        if let fld = notesField.text, fld != "" {
            notes = fld
        }
        
        let json : [String:Any] = [
            "person_id": person_id,
            "author_id": author_id,
            "mission_id": mission_id,
            "phone_number": phone,
            "outcome": outcome,
            "note": notes,
            "call_date": Util.getDate_yyyy_MM_dd(),
            "duration": 1, // TODO fix this
            "success": true
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKeyValue, forHTTPHeaderField: apiKeyName)
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData!
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data") // TODO FIXME write errors to db
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String:Any] {
                print(responseJSON)
                TPUser.sharedInstance.currentCBMissionItem = nil
                if self.doQuit {
                    self.logout()
                } else {
                    
                    var call_notes = [
                        "first_name": first_name, // the person called
                        "last_name": last_name,   // the person called
                        "person_id": person_id,   // the person called CB ID
                        "phone_number": phone,    // the person called
                        "author_name": TPUser.sharedInstance.getName(), // the volunteer
                        "author_id": author_id,                         // the volunteer's CB ID
                        "outcome": self.outcome,
                        "notes": notes,
                        "call_date": Util.getDate_MMM_d_yyyy_hmm_am_z(),
                        "call_date_ms": Util.getDate_as_millis(),
                        "mission_name": missionItem.name,
                        "mission_id": mission_id,
                        "calls_made": missionItem.calls_made,
                        "percent_complete": missionItem.percent_complete,
                        "total": missionItem.total,
                        "status": missionItem.status
                        ] as [String : Any]
                    
                    if let phone2 = missionItem.phone2, let name2 = missionItem.name2 {
                        call_notes["phone2"] = phone2.trimmingCharacters(in: .whitespacesAndNewlines)
                        call_notes["name2"] = name2.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    if let info = missionItem.info {
                        call_notes["info"] = info
                    }
                    
                    let ref = Database.database().reference().child("call_notes")
                    ref.childByAutoId().setValue(call_notes, withCompletionBlock: { (error, ref) -> Void in
                        DispatchQueue.main.async {
                            self.wrapUpCBCallDelegate?.cbMissionAccomplished()
                        } // DispatchQueue.main.async
                    })
                    
                } // else if self.doQuit
                
            } // if let responseJSON = responseJSON as? [String:Any]
        }
        task.resume()
        
    }
    
    
    var doQuit = false
    @objc func submitWrapUpAndQuit(_ sender: BaseButton) {
        doQuit = true
        saveNotes()
        logout()
    }
    
    func logout() {
        //try! Auth.auth().signOut()
        //UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        TPUser.sharedInstance.signOut()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // source:  https://codewithchris.com/uipickerview-example/
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // source:  https://codewithchris.com/uipickerview-example/
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // source:  https://codewithchris.com/uipickerview-example/
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("titleForRow row = \(row)  -  pickerData[row] = \(pickerData[row])")
        return pickerData[row]
    }
    
    
    // source:  https://codewithchris.com/uipickerview-example/
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        print("didSelectRow row = \(row)")
        outcome = pickerData[row]
    }
    
}


protocol WrapUpCBCallDelegate {
    func cbMissionAccomplished()
}

