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
        p.translatesAutoresizingMaskIntoConstraints = false // <-- ALWAYS DO THIS !!!!!!
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
        let btn = BaseButton(text: "Save")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(submitWrapUp(_:)), for: .touchUpInside)
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
        self.picker = UIPickerView()
        self.picker.delegate = self
        self.picker.dataSource = self
        
        self.picker.frame = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: 200.0)
        
        /****/
        view.addSubview(whatHappenedLabel)
        whatHappenedLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        whatHappenedLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        whatHappenedLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        whatHappenedLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25).isActive = true
        /****/
        
        view.addSubview(picker)
        //pickerViewContainer.view.addSubview(picker)
        //view.addSubview(pickerViewContainer.view)
        //pickerViewContainer.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        picker.topAnchor.constraint(equalTo: whatHappenedLabel.bottomAnchor, constant: 16).isActive = true
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
        
    }
    
    
    @objc func submitWrapUp(_ sender: BaseButton) {
        guard let missionItem = TPUser.sharedInstance.currentMissionItem else {
                    return }
        
        notesField.text = ""
        outcome = pickerData[0]
        picker.selectRow(0, inComponent: 0, animated: false)
        
        print("wrap up for:  mission_item_id = \(missionItem)")
        let ref = Database.database().reference().child("mission_items").child(missionItem.mission_item_id)
        
        
        /****
         Multi-path updates would be better but I think the nodes have to exist in the first place,
         and some of these don't.  When I tested this on 12/2/17, not even the existing nodes were being updated
         I think could be because some of the nodes didn't exist, and maybe it's an all-or-nothing transaction
         let missionRef = ref.child(missionItem.mission_item_id)
         let missionData = ["outcome": outcome,
                             "notes": notesField.text,
                             "completed_by_uid": TPUser.sharedInstance.getUid(),
                             "completed_by_name": TPUser.sharedInstance.getName(),
                             "accomplished": "completed",
                             "active_and_accomplished": "true_completed"] as [String : Any]
         
         missionRef.updateChildValues(missionData)
         **********/
        
        ref.child("outcome").setValue(outcome)
        ref.child("notes").setValue(notesField.text)
        ref.child("completed_by_uid").setValue(TPUser.sharedInstance.getUid())
        ref.child("completed_by_name").setValue(TPUser.sharedInstance.getName())
        ref.child("accomplished").setValue("completed")
        ref.child("active_and_accomplished").setValue("true_completed")
        TPUser.sharedInstance.currentMissionItem = nil
        
        // Now, just send the user to another mission
        delegate?.missionAccomplished()
        
        
        // In Android, this is User.java: submitWrapUp()
        /*************
        public void submitWrapUp(String outcome, String notes) {
            DatabaseReference ref = FirebaseDatabase.getInstance().getReference("mission_items/"+missionItemId);
            ref.child("outcome").setValue(outcome);
            ref.child("notes").setValue(notes);
            ref.child("completed_by_uid").setValue(getUid());
            ref.child("completed_by_name").setValue(getName());
            missionItemId = null;
            missionItem = null;
        }
         ************/
        
        
        
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
