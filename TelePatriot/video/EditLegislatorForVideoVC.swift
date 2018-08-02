//
//  EditLegislatorForVideoVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 4/21/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

// Android equiv:  EditLegislatorForVideoDlg
class EditLegislatorForVideoVC: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, LegislatorDelegate {
    
    
    var selectedState = "TX"
    var selectedChamber = "HD"
    var selectedDistrict = "1"
    var scrollView : UIScrollView?
    
    let legislatorHeadingLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Select Legislator"
        l.font = l.font.withSize(24)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    var videoNode : VideoNode?
    var states = [[String:String]]()
    
    var mostChambers = ["HD", "SD"]
    var nebraskaChambers = ["SD"]
    var chambers = ["HD", "SD"]
    
    var districts = [String]() //["1", "2", "3", "4", "5"] // needs to come from database
    
    var legislatorUIs = [LegislatorUI]()
    
    
    var statePicker: UIPickerView = {
        let p = UIPickerView()
        //p.translatesAutoresizingMaskIntoConstraints = false // <-- ALWAYS DO THIS - EXCEPT IN THIS CASE
        return p
    }()
    
    // SD or HD
    var chamberPicker: UIPickerView = {
        let p = UIPickerView()
        //p.translatesAutoresizingMaskIntoConstraints = false // <-- ALWAYS DO THIS - EXCEPT IN THIS CASE
        return p
    }()
    
    var districtPicker: UIPickerView = {
        let p = UIPickerView()
        //p.translatesAutoresizingMaskIntoConstraints = false // <-- ALWAYS DO THIS - EXCEPT IN THIS CASE
        return p
    }()
    
    
    let cancel_button : BaseButton = {
        let button = BaseButton(text: "Cancel")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelLegislatorChanges(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(cancel_button)
        cancel_button.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        cancel_button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
        view.addSubview(legislatorHeadingLabel)
        legislatorHeadingLabel.topAnchor.constraint(equalTo: cancel_button.bottomAnchor, constant: 0).isActive = true
        legislatorHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
        statePicker.frame = CGRect(x: 8, y: 64, width: self.view.bounds.width * 0.4, height: 100.0)
        statePicker.delegate = self
        statePicker.dataSource = self
        //statePicker.selectRow(-1, inComponent: 0, animated: false)
        
        chamberPicker.frame = CGRect(x: statePicker.frame.width, y: 64, width: self.view.bounds.width * 0.2, height: 100.0)
        chamberPicker.delegate = self
        chamberPicker.dataSource = self
        
        let districtPickerX = statePicker.frame.width + self.view.bounds.width * 0.2
        districtPicker.frame = CGRect(x: districtPickerX, y: 64, width: self.view.bounds.width * 0.4, height: 100.0)
        districtPicker.delegate = self
        districtPicker.dataSource = self
        
        view.addSubview(statePicker)
        view.addSubview(chamberPicker)
        view.addSubview(districtPicker)
        
        let scrollViewY = statePicker.frame.height + statePicker.frame.origin.y
        scrollView = UIScrollView(frame: CGRect(x: 0, y: scrollViewY, width: self.view.frame.width, height: self.view.frame.height))
        scrollView?.contentSize = CGSize(width: self.view.frame.width, height: 2000)
        view.addSubview(scrollView!)
        
        /*******
        view.addSubview(legislator_name_field)
        legislator_name_field.topAnchor.constraint(equalTo: view.topAnchor, constant: 144).isActive = true
        legislator_name_field.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        legislator_name_field.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        legislator_name_field.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        ********/
        
        Database.database().reference().child("states/list").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            let children = snapshot.children
            while let snap = children.nextObject() as? DataSnapshot {
                let state_abbrev = snap.key
                if let data = snap.value as? [String:Any],
                    let state_name = data["state_name"] as? String {
                        self.states.append(["state":state_name, "state_abbrev":state_abbrev])
                }
            }
            
            // not exactly sure why viewDidAppear() doesn't work without this, but it doesn't
            self.displayListOfDistricts(state: self.selectedState, chamber: self.selectedChamber)
            DispatchQueue.main.async {
                self.statePicker.reloadAllComponents()
            }
            
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setPickersToDefaultValues()
    }
    
    private func setPickersToDefaultValues() {
        // set a default value for state...
        if let index = self.states.index(where: { (item) -> Bool in
            item["state_abbrev"] == selectedState // test if this is the item you're looking for
        }) {
            self.statePicker.selectRow(index, inComponent: 0, animated: false)
        }
        
        if let index = self.districts.index(where: { (item) -> Bool in
            item == selectedDistrict // test if this is the item you're looking for
        }) {
            self.districtPicker.selectRow(index, inComponent: 0, animated: false)
        }
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
        if(pickerView == statePicker) {
            return states.count
        }
        else if(pickerView == chamberPicker) {
            return chambers.count
        }
        else if(pickerView == districtPicker) {
            return districts.count
        }
        return 0
    }
    
    // source:  https://codewithchris.com/uipickerview-example/
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == statePicker) {
            return states[row]["state"]
        }
        else if(pickerView == chamberPicker) {
            return chambers[row]
        }
        else if(pickerView == districtPicker) {
            return districts[row]
        }
        return ""
    }
    
    
    // source:  https://codewithchris.com/uipickerview-example/
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
        // NOT SURE WHAT WE WANT TO DO HERE AT THE MOMENT
        
        if(pickerView == statePicker) {
            if row < states.count {
                selectedState = states[row]["state_abbrev"]!
            
                if selectedState == "NE" {
                    chambers = nebraskaChambers
                }
                else {
                    chambers = mostChambers
                }
            
                displayListOfDistricts(state: selectedState, chamber: selectedChamber)
                displayLegislators(state: selectedState, chamber: selectedChamber, district: selectedDistrict)
            }
        }
        else if(pickerView == chamberPicker) {
            if row < chambers.count {
                selectedChamber = chambers[row]
                displayListOfDistricts(state: selectedState, chamber: selectedChamber)
                displayLegislators(state: selectedState, chamber: selectedChamber, district: selectedDistrict)
            }
        }
        else if(pickerView == districtPicker) {
            if row < districts.count {
                selectedDistrict = districts[row]
                displayLegislators(state: selectedState, chamber: selectedChamber, district: selectedDistrict)
            }
        }
    }
    
    
    // this is how you control font/alignment/etc of the spinner text
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .left
        if(pickerView == statePicker) {
            label.text = states[row]["state"]
        }
        else if(pickerView == chamberPicker) {
            label.text = chambers[row]
            label.textAlignment = .center
        }
        else if(pickerView == districtPicker) {
            label.text = districts[row]
        }
        return label
    }
    
    
    private func displayListOfDistricts(state: String, chamber: String) {
        
        // query on the state_chamber attribute
        var ch = chamber=="SD" ? "upper" : "lower"
        var state_chamber = "\(state)-\(ch)"
        
        Database.database().reference().child("states/districts/")
            .queryOrdered(byChild: "state_chamber").queryEqual(toValue: state_chamber)
            .observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                self.districts = [String]()
                let children = snapshot.children
                while let snap = children.nextObject() as? DataSnapshot {
                    
                    guard let districtNode = snap.value as? [String:Any] else {
                        return
                    }
                    
                    guard let district = districtNode["name"] as? String else {
                        return
                    }
                    
                    self.districts.append(district)
                }
                
                self.districts = self.districts.sorted(by: {
                    if let n0 = Int($0), let n1 = Int($1) {
                        return n0 < n1
                    }
                    else {
                        return $0 < $1
                    }
                })
                
                DispatchQueue.main.async {
                    self.chamberPicker.reloadAllComponents()
                    self.districtPicker.reloadAllComponents()
                }
            })
    }
    
    
    private func displayLegislators(state: String, chamber: String, district: String) {
        
        // query on the state_chamber_district attribute
        var ch = chamber=="SD" ? "upper" : "lower"
        var state_chamber_district = "\(state)-\(ch)-\(district)"
        
        if legislatorUIs.count > 0 {
            for ui in legislatorUIs {
                ui.removeFromSuperview()
            }
            legislatorUIs.removeAll()
        }
        
        Database.database().reference().child("states/legislators/")
            .queryOrdered(byChild: "state_chamber_district").queryEqual(toValue: state_chamber_district)
            .observe(.value, with: {(snapshot: DataSnapshot) in
                let children = snapshot.children
                var counter = 0
                while let snap = children.nextObject() as? DataSnapshot {
                    //print("snap.value:  \(snap.value)")
                    if let data = snap.value as? [String:Any] {
                        let legislator = Legislator(data: data)
                        
                        if self.legislatorUIs.count <= counter {
                            let r = CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height)
                            let legislatorUI = LegislatorUI(frame: r)
                            self.legislatorUIs.append(legislatorUI)
                            self.scrollView?.addSubview(legislatorUI)
                            
                            if counter == 0 {
                                legislatorUI.topAnchor.constraint(equalTo: (self.scrollView?.topAnchor)!, constant: 16).isActive = true
                                legislatorUI.leadingAnchor.constraint(equalTo: (self.scrollView?.leadingAnchor)!, constant: 0).isActive = true
                            }
                            else {
                                // the constant of 116 is 100 rowheight + padding of 16
                                legislatorUI.topAnchor.constraint(equalTo: self.legislatorUIs[counter-1].bottomAnchor, constant: 100).isActive = true
                                legislatorUI.leadingAnchor.constraint(equalTo: (self.scrollView?.leadingAnchor)!, constant: 0).isActive = true
                            }
                        }
                        
                        var legislatorUI = self.legislatorUIs[counter]
                        legislatorUI.legislatorDelegate = self
                        legislatorUI.setLegislator(legislator: legislator)
                        
                        print("legislator name: \(legislator.first_name) \(legislator.last_name)")
                    }
                    counter = counter + 1
                }
            })
    }
    
    
    @objc private func cancelLegislatorChanges(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // per LegislatorDelegate
    func legislatorSelected(legislator: Legislator) {
        if let vn = videoNode {
            // emails stored under states/legislators are a mess...
            var email = ""
            if legislator.emails != nil && legislator.emails.count > 0 {
                email = legislator.emails[0]
            } else if legislator.email != "" {
                email = legislator.email
            }
            
            // phones are also a mess...
            var phone = ""
            if legislator.phones != nil && legislator.phones.count > 0 {
                phone = legislator.phones[0]
            } else if legislator.phone != "" {
                phone = legislator.phone
            }
            
            let updatedData = ["video/list/\(vn.getKey())/legislator_first_name": legislator.first_name,
                                "video/list/\(vn.getKey())/legislator_last_name": legislator.last_name,
                                "video/list/\(vn.getKey())/legislator_full_name": "\(legislator.first_name) \(legislator.last_name)",
                                "video/list/\(vn.getKey())/leg_id": legislator.leg_id,
                                "video/list/\(vn.getKey())/legislator_state_abbrev": legislator.state,
                                "video/list/\(vn.getKey())/legislator_district": legislator.district,
                                "video/list/\(vn.getKey())/legislator_chamber": legislator.chamber,
                                "video/list/\(vn.getKey())/legislator_email": email,
                                "video/list/\(vn.getKey())/legislator_phone": legislator.phone,
                                "video/list/\(vn.getKey())/legislator_cos_position": legislator.legislator_cos_position,
                                "video/list/\(vn.getKey())/legislator_facebook": legislator.legislator_facebook,
                                "video/list/\(vn.getKey())/legislator_facebook_id": legislator.legislator_facebook_id,
                                "video/list/\(vn.getKey())/legislator_twitter": legislator.legislator_twitter
                                //,"video/list/\(vn.getKey())/youtube_video_description": vn.youtube_video_description
                            ]
             // example of multi-path update
             Database.database().reference().updateChildValues(updatedData, withCompletionBlock: { (error, ref) -> Void in
                 // don't really need to do anything on successful save except dismiss this view
                 self.dismiss(animated: true, completion: nil)
             })
        }
    }
    
    
    // per LegislatorDelegate
    // see LegislatorUI
    func editSocialMedia(legislator: Legislator, handle: String?, handleType: String?) {
        if let handle = handle, let vc = getAppDelegate().editSocialMediaVC {
            vc.modalPresentationStyle = .popover
            vc.socialMediaDelegate = vc // this class implements EditSocialMediaDelegate
            vc.handle = handle
            vc.handleType = handleType
            vc.legislator = legislator
            present(vc, animated: true, completion:nil)
        }
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

