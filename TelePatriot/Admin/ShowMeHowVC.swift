//
//  ShowMeHowVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 8/31/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

// like ShowMeHowActivity in Android
class ShowMeHowVC: BaseViewController {

    
    var scrollView : UIScrollView?
    var states = [[String:String]]()
    var selectedState = "tx"
    
    
    let lights_camera_action_heading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Lights, Camera, Action!"
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let shoot_video_instructions : UITextView = {
        let textView = UITextView()
        textView.text = "Go on camera for the Convention of States.  This app will connect you with another user who can guide you through the process of shooting a video that will go directly to your state legislators.\n\nIt's incredibly easy!"
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
    
    let phone_number_heading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Why do we need your phone # ?"
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let phone_number_explanation : UITextView = {
        let textView = UITextView()
        textView.text = "So we can call you to schedule a video chat"
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
    
    let phone_number_field : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "Phone # of this device"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .numberPad
        return field
    }()
    
    let address_heading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Why do we need your address ?"
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let address_explanation : UITextView = {
        let textView = UITextView()
        textView.text = "So we can look up your state legislators for you"
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
    
    
    let residential_address_line1 : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "Address line 1"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let residential_address_line2 : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "Address line 2"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let residential_address_city : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "City"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let residential_address_state_abbrev: UIPickerView = {
        let p = UIPickerView()
        p.translatesAutoresizingMaskIntoConstraints = false // <-- ALWAYS DO THIS - EXCEPT IN THIS CASE
        return p
    }()
    
    
    let residential_address_zip : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "ZIP"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .numberPad
        return field
    }()
    
    
    let send_video_offer_button : BaseButton = {
        let button = BaseButton(text: "Call Me - I'm Ready!")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickCallMe(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let cancel_button : BaseButton = {
        let button = BaseButton(text: "Cancel")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickCancel(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 32, width: self.view.frame.width, height: self.view.frame.height))
        if let scrollView = scrollView {
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: 2000)

            let heightMultiplier : CGFloat = 0.05
            let widthMultiplier : CGFloat = 0.95
            // Do any additional setup after loading the view.
            scrollView.addSubview(lights_camera_action_heading)
            lights_camera_action_heading.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
            lights_camera_action_heading.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(shoot_video_instructions)
            shoot_video_instructions.topAnchor.constraint(equalTo: lights_camera_action_heading.bottomAnchor, constant: 8).isActive = true
            shoot_video_instructions.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 4).isActive = true
            shoot_video_instructions.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: widthMultiplier).isActive = true
            
            scrollView.addSubview(phone_number_heading)
            phone_number_heading.topAnchor.constraint(equalTo: shoot_video_instructions.bottomAnchor, constant: 32).isActive = true
            phone_number_heading.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(phone_number_explanation)
            phone_number_explanation.topAnchor.constraint(equalTo: phone_number_heading.bottomAnchor, constant: 8).isActive = true
            phone_number_explanation.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 4).isActive = true
            
            scrollView.addSubview(phone_number_field)
            phone_number_field.topAnchor.constraint(equalTo: phone_number_explanation.bottomAnchor, constant: 16).isActive = true
            phone_number_field.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            phone_number_field.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: heightMultiplier).isActive = true
            phone_number_field.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: widthMultiplier).isActive = true
            
            scrollView.addSubview(address_heading)
            address_heading.topAnchor.constraint(equalTo: phone_number_field.bottomAnchor, constant: 32).isActive = true
            address_heading.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(address_explanation)
            address_explanation.topAnchor.constraint(equalTo: address_heading.bottomAnchor, constant: 8).isActive = true
            address_explanation.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 4).isActive = true
            
            scrollView.addSubview(residential_address_line1)
            residential_address_line1.topAnchor.constraint(equalTo: address_explanation.bottomAnchor, constant: 16).isActive = true
            residential_address_line1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            residential_address_line1.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: heightMultiplier).isActive = true
            residential_address_line1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: widthMultiplier).isActive = true
            
            scrollView.addSubview(residential_address_line2)
            residential_address_line2.topAnchor.constraint(equalTo: residential_address_line1.bottomAnchor, constant: 8).isActive = true
            residential_address_line2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            residential_address_line2.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: heightMultiplier).isActive = true
            residential_address_line2.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: widthMultiplier).isActive = true
            
            scrollView.addSubview(residential_address_city)
            residential_address_city.topAnchor.constraint(equalTo: residential_address_line2.bottomAnchor, constant: 8).isActive = true
            residential_address_city.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            residential_address_city.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: heightMultiplier).isActive = true
            residential_address_city.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: widthMultiplier).isActive = true
            
            scrollView.addSubview(residential_address_state_abbrev)
            residential_address_state_abbrev.topAnchor.constraint(equalTo: residential_address_city.bottomAnchor, constant: -8).isActive = true
            residential_address_state_abbrev.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            residential_address_state_abbrev.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.15).isActive = true
            residential_address_state_abbrev.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5).isActive = true
            residential_address_state_abbrev.delegate = self
            residential_address_state_abbrev.dataSource = self
            
            scrollView.addSubview(residential_address_zip)
            residential_address_zip.centerYAnchor.constraint(equalTo: residential_address_state_abbrev.centerYAnchor, constant: 0).isActive = true
            residential_address_zip.leadingAnchor.constraint(equalTo: residential_address_state_abbrev.trailingAnchor, constant: 16).isActive = true
            residential_address_zip.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: heightMultiplier).isActive = true
            residential_address_zip.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.4).isActive = true
            
            scrollView.addSubview(send_video_offer_button)
            send_video_offer_button.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
            send_video_offer_button.topAnchor.constraint(equalTo: residential_address_zip.bottomAnchor, constant: 60).isActive = true
            
            scrollView.addSubview(cancel_button)
            cancel_button.centerXAnchor.constraint(equalTo: send_video_offer_button.centerXAnchor, constant: 0).isActive = true
            cancel_button.topAnchor.constraint(equalTo: send_video_offer_button.bottomAnchor, constant: 32).isActive = true
            
            Database.database().reference().child("states/list").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                let children = snapshot.children
                while let snap = children.nextObject() as? DataSnapshot {
                    let state_abbrev = snap.key
                    if let data = snap.value as? [String:Any],
                        let state_name = data["state_name"] as? String {
                        self.states.append(["state":state_name, "state_abbrev":state_abbrev])
                    }
                }
                
                DispatchQueue.main.async {
                    self.residential_address_state_abbrev.reloadAllComponents()
                }
                
                self.loadTestData()
            })
            
            view.addSubview(scrollView)
        }
    }
    
    private func loadTestData() {
//        phone_number_field.text = "5550001212"
//        residential_address_line1.text = "6400 Lakeshore Dr"
//        residential_address_city.text = "Dallas"
//        setState(state_abbrev: "tx")
//        residential_address_zip.text = "75214"
    }
    
    private func setState(state_abbrev: String?) {
        if let state_abbrev = state_abbrev {
            let index = states.index(where: { (item) -> Bool in
                item["state_abbrev"] == state_abbrev // test if this is the item you're looking for
            })
        
            DispatchQueue.main.async {
                self.residential_address_state_abbrev.selectRow(index!, inComponent: 0, animated: false)
                self.residential_address_state_abbrev.reloadAllComponents()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func simpleOKDialog(message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style {
            case .default:
                self.dismiss(animated: true, completion: nil)
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func success() {
        simpleOKDialog(message: "Got it! \nSomeone will contact you soon")
    }
    
    private func error() {
        simpleOKDialog(message: "Houston, we have a problem\nYour info was not received")
    }
    
    @objc private func clickCallMe(_ sender:UIButton) {
        TPUser.sharedInstance.phone = phone_number_field.text
        TPUser.sharedInstance.residential_address_line1 = residential_address_line1.text
        TPUser.sharedInstance.residential_address_line2 = residential_address_line2.text
        TPUser.sharedInstance.residential_address_city = residential_address_city.text
        TPUser.sharedInstance.residential_address_state_abbrev = selectedState
        TPUser.sharedInstance.residential_address_zip = residential_address_zip.text
        let offer = VideoOffer(user: TPUser.sharedInstance)
        offer.save(f: success, e: error)
    }
    
    @objc private func clickCancel(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
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

// https://developer.apple.com/documentation/uikit/uipickerviewdelegate
extension ShowMeHowVC : UIPickerViewDelegate {
    
    // source:  https://codewithchris.com/uipickerview-example/
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]["state"]
    }


    // source:  https://codewithchris.com/uipickerview-example/
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.

        // NOT SURE WHAT WE WANT TO DO HERE AT THE MOMENT

        if row < states.count {
            selectedState = states[row]["state_abbrev"]!
            print(selectedState)
        }
    }
    
    
    
    
}

extension ShowMeHowVC : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    
}
