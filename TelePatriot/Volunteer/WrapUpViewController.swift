//
//  WrapUpViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/1/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class WrapUpViewController : BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var delegate : WrapUpViewControllerDelegate?
    
    // need drop down for outcome type
    var picker: UIPickerView = {
        let p = UIPickerView()
        //p.translatesAutoresizingMaskIntoConstraints = false // <-- ALWAYS DO THIS - EXCEPT IN THIS CASE
        return p
    }()
    
    var pickerData = ["voice mail", "spoke on the phone", "number disconnected", "wrong number"]
    
    var outcome : String = "voice mail"
    
    let whatHappenedLabel : UILabel = {
        let l = UILabel()
        l.text = "What happened on the call?..."
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
    
    /********
    let pickerViewContainer : ContainerViewController = {
        let c = ContainerViewController()
        
        return c
    }()
     ********/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // source:  https://codewithchris.com/uipickerview-example/
        // Connect data:
        //self.picker = UIPickerView()
        self.picker.delegate = self
        self.picker.dataSource = self
        
        self.picker.frame = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: 200.0)
        picker.selectRow(-1, inComponent: 0, animated: false)
        
        /****/
        view.addSubview(whatHappenedLabel)
        whatHappenedLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        whatHappenedLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
        whatHappenedLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        whatHappenedLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        /****/
        
        if view.subviews.contains(picker) {
            picker.removeFromSuperview()
            // I don't know why we have to do this.  Must be something different about UIPickerView's
            // We don't have to make sure other controls aren't added twice.  Unless they ARE added multiple
            // times and we just don't realize it because right on top of either other ... ?
        }
        
        notesField.text = ""
        
        view.addSubview(picker)
        //pickerViewContainer.view.addSubview(picker)
        //view.addSubview(pickerViewContainer.view)
        //pickerViewContainer.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        picker.topAnchor.constraint(equalTo: whatHappenedLabel.bottomAnchor, constant: 64).isActive = true
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
        
        view.addSubview(submitButton)
        submitButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        submitButton.topAnchor.constraint(equalTo: notesField.bottomAnchor, constant: 8).isActive = true
        submitButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
        view.addSubview(submitAndQuitButton)
        submitAndQuitButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        submitAndQuitButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 8).isActive = true
        submitAndQuitButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        
    }
    
    
    @objc func submitWrapUp(_ sender: BaseButton) {
        saveNotes()
        
        // Now, just send the user to another mission
        delegate?.missionAccomplished()
    }
    
    private func saveNotes() {
        guard let missionItem = TPUser.sharedInstance.currentMissionItem else {
            return }
        
        
        // the "guard" will unwrap the team name.  Otherwise, you'll get nodes written to the
        // database like this...  Optional("The Cavalry")
        guard let team = TPUser.sharedInstance.getCurrentTeam()?.team_name else {
            return
        }
        Database.database().reference().child("teams/\(team)/mission_items/\(missionItem.mission_item_id)").removeValue()
        let ref = Database.database().reference().child("teams/\(team)/missions/\(missionItem.mission_id)/mission_items/\(missionItem.mission_item_id)")
        ref.child("accomplished").setValue("complete")
        ref.child("active").setValue(false)
        ref.child("active_and_accomplished").setValue("false_complete")
        ref.child("outcome").setValue(outcome)
        ref.child("notes").setValue(notesField.text)
        ref.child("completed_by_uid").setValue(TPUser.sharedInstance.getUid())
        ref.child("completed_by_name").setValue(TPUser.sharedInstance.getName())
        
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a z"
        let mission_complete_date = dateFormatter.string(from: date)
        ref.child("mission_complete_date").setValue(mission_complete_date)
        ref.child("uid_and_active").setValue(TPUser.sharedInstance.getUid()+"_false")
        
        TPUser.sharedInstance.currentMissionItem = nil
    }
    
    @objc func submitWrapUpAndQuit(_ sender: BaseButton) {
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
