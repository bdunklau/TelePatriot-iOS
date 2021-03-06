//
//  MyCBMissionViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/4/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class MyCBMissionViewController: BaseViewController {

    var missionConfig : Configuration? // set from CenterViewController
    var callButton1 = CallButton(text: "")
    var callButton2 = CallButton(text: "")
    var noMissionLabel = UILabel()
    var mission_name : String?
    var supporter_name : String?
    //var noMissionDelegate : NoMissionDelegate?
    var missionDelegate : MissionDelegate?
    
    let missionNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Mission Name"
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let missionProgressLabel : UILabel = {
        let label = UILabel()
        label.text = "-% Complete (- of - calls made)"
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    let NO_MISSIONS_FOUND_MESSAGE = "No missions found yet for this team..."
    
    let descriptionTextView : UITextView = {
        let textView = UITextView()
        textView.text = "No missions found yet for this team..."
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
    
    let button_leave_notes : BaseButton = {
        let btn = BaseButton(text: "")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(gotoLeaveNotesScreen(_:)), for: .touchUpInside)
        return btn
    }()
    
    //    Example of what comes out of CB from the /volunteers/get_person endpoint
    //
    //    {
    //    "mission_id": 30,
    //    "name": "Idaho Test 2",
    //    "priority": 1,
    //    "description": "Second test mission for Idaho",
    //    "script": "<p>Another test mission, calling districts near Boise</p>",
    //    "status": "active",
    //    "person_id": 2278603,
    //    "first_name": "Barbara",
    //    "last_name": "Shipley",
    //    "phone": "(707) 3184585",
//        "total": 0,
//        "calls_made": 0,
//        "percent_complete": 0
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTheView()
    }
    
    private func loadTheView() {
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height))
        scrollView.contentSize = CGSize(width: 250, height: 1450)
        
        scrollView.addSubview(descriptionHeaderLabel)
        scrollView.addSubview(descriptionTextView)
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(missionNameLabel)
        missionNameLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        missionNameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        
        scrollView.addSubview(missionProgressLabel)
        missionProgressLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        missionProgressLabel.topAnchor.constraint(equalTo: missionNameLabel.bottomAnchor, constant: 8).isActive = true
        
        descriptionHeaderLabel.text = "Mission Description"
        descriptionHeaderLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        descriptionHeaderLabel.topAnchor.constraint(equalTo: missionProgressLabel.bottomAnchor, constant: 16).isActive = true
        descriptionHeaderLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
        //descriptionHeaderLabel.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1).isActive = true
        
        descriptionTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: descriptionHeaderLabel.bottomAnchor).isActive = true
        descriptionTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
        //descriptionTextView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor, multiplier: 0.25).isActive = true
        
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
        
        scrollView.addSubview(button_leave_notes)
        button_leave_notes.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant:0).isActive = true
        button_leave_notes.topAnchor.constraint(equalTo: callButton2.bottomAnchor, constant: 24).isActive = true
        
        
        // might also want to look into this: https://stackoverflow.com/a/31428932
        // to try to get elements positioned relative to the nav bar at the top
        
        getMission_fromCitizenBuilder()
        
        
    }
    
    private func getMission_fromCitizenBuilder() {
        
        guard let teamId = TPUser.sharedInstance.getCurrentTeam()?.getId(),
            let domain = missionConfig?.getCitizenBuilderDomain(),
            let url = URL(string: "https://\(domain)/api/ios/v1/volunteers/get_person?team_id=\(teamId)"),
            let apiKeyName = missionConfig?.getCitizenBuilderApiKeyName(),
            let apiKeyValue = missionConfig?.getCitizenBuilderApiKeyValue()
        else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKeyValue, forHTTPHeaderField: apiKeyName)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, responseError) in
            
            let decoder = JSONDecoder()
            
            guard var cbMissionDetails = try? decoder.decode(CBMissionDetail.self, from: data!),
                let fname = cbMissionDetails.first_name,
                let lname = cbMissionDetails.last_name,
                let phone = cbMissionDetails.phone
            else {
                DispatchQueue.main.async {
                    self.descriptionTextView.text = self.NO_MISSIONS_FOUND_MESSAGE
                    self.callButton1.setTitle("", for: .normal)
                    self.callButton2.setTitle("", for: .normal)
                    self.button_leave_notes.setTitle("", for: .normal)
                }
                TPUser.sharedInstance.unassignCurrentMissionItem()
                return
            }
            
            // store these 3 in the cbMissionDetails object so we don't have to query again for them
            // when it's time to save the call notes
            cbMissionDetails.citizen_builder_domain = domain
            cbMissionDetails.citizen_builder_api_key_name = apiKeyName
            cbMissionDetails.citizen_builder_api_key_value = apiKeyValue
            
            TPUser.sharedInstance.currentCBMissionItem = cbMissionDetails // store this in the user object so we can unassign later from anywhere
            self.callButton1.phone = cbMissionDetails.phone
            DispatchQueue.main.async { self.button_leave_notes.setTitle("Leave Notes", for: .normal) }
            self.supporter_name = "\(fname) \(lname)"
            self.mission_name = cbMissionDetails.name
            
            DispatchQueue.main.async {
                self.callButton1.setTitle("\(fname) \(lname) \(phone)", for: .normal)
                if  let descr = cbMissionDetails.description,
                    let html = cbMissionDetails.script
                {
                    self.missionNameLabel.text = cbMissionDetails.name
                    self.missionProgressLabel.text = "\(cbMissionDetails.percent_complete)% Completed (\(cbMissionDetails.calls_made) of \(cbMissionDetails.total) calls made)"
                    
                    // This is a temporary way of getting 3way call names and phone numbers.  We allow mission directors
                    // to add an html comment in the mission description.  In this html comment is the name and phone
                    // number of a person (probably a legislator) that we want to be the "3way call" party
                    if let _3waycallname = self.get3WayCallName(string: html),
                       let _3waycallphone = self.get3WayCallPhone(string: html)
                    {
                        let button2Text = "\(_3waycallname) \(_3waycallphone)"
                        self.callButton2.setTitle(button2Text, for: .normal)
                        self.callButton2.phone = _3waycallphone
                        TPUser.sharedInstance.currentCBMissionItem?.name2 = _3waycallname
                        TPUser.sharedInstance.currentCBMissionItem?.phone2 = _3waycallphone
                    }
                    else {
                        self.callButton2.setTitle("", for: .normal)
                        TPUser.sharedInstance.currentCBMissionItem?.name2 = nil
                        TPUser.sharedInstance.currentCBMissionItem?.phone2 = nil
                    }
                    let scr = html.htmlToString // htmlToString is an extension below
                    self.descriptionTextView.text = "\(descr)\n\n\n\nScript\n\n\(scr)"
                }
                
                // At some point, we'll get 3way call names and numbers in a more correct way.  When we do, the code
                // below can serve as a starting point.  Until then, we get 3way call names and numbers by looking
                // for an html comment string in the mission description (above)
//                if let name2 = cbMissionDetails.name2, let phone2 = cbMissionDetails.phone2,
//                    name2 != "", phone2 != "" {
//                    let button2Text = "\(cbMissionDetails.name2!) \(cbMissionDetails.phone2!)"
//                    self.callButton2.setTitle(button2Text, for: .normal)
//                    self.callButton2.phone = cbMissionDetails.phone2
//                }
//                else {
//                    self.callButton2.setTitle("", for: .normal)
//                }
                
            }

        }
        
        task.resume()
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
        getMission_fromCitizenBuilder()
    }
    
    
    @objc func gotoLeaveNotesScreen(_ sender: BaseButton) {
        guard let del = missionDelegate else {
            return
        }
        del.leaveNotes()
    }
    
    
    // call end is recorded in AppDelegate.onCallEnded()
    @objc func makeCall(_ sender: CallButton) {
        guard let ph = sender.phone,
            let number = URL(string: "tel://\(ph.digits)"), // digits is an extension below
            let mission_name = mission_name,
            let supporter_name = supporter_name
        else {
            return
        }
        
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
        guard let team_name = TPUser.sharedInstance.getCurrentTeam()?.getName() else {
            return
        }
        let ref = Database.database().reference().child("teams/\(team_name)/activity")
        ref.child("all").childByAutoId().setValue(m.dictionary())
        ref.child("by_phone_number").child(ph).childByAutoId().setValue(m.dictionary())
        
        // now do the call
        UIApplication.shared.open(number)
//        UIApplication.shared.open(URL(string: "tel://2146320000")!) // short circuit to some other number
    }
    
    func getDateString() -> String {
        return Util.getDate_Day_MMM_d_hmmss_am_z_yyyy()
    }
    
    
    func indicateNoMissionsAvailable() {
        descriptionTextView.text = MyMissionViewController.NO_MISSIONS_FOUND_MESSAGE
        callButton1.setTitle("", for: .normal)
        callButton2.setTitle("", for: .normal)
        button_leave_notes.setTitle("", for: .normal)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func get3WayCallName(string: String) -> String? {
        return substring(string: string, s1: "start 3way call name", s2: "end 3way call name")
    }
    
    func get3WayCallPhone(string: String) -> String? {
        return substring(string: string, s1: "start 3way call phone", s2: "end 3way call phone")
    }
    
    func substring(string: String, s1: String, s2: String) -> String? {
        
        if let beginPos = string.range(of: s1),
            let endPos = string.range(of: s2) {
            let range = beginPos.upperBound..<endPos.lowerBound
            let s = string[range]
            return String(s)
        }
        return nil
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

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension StringProtocol {
    var digits: String {
        return String(filter(("0"..."9").contains))
    }
}

protocol MissionDelegate {
    func leaveNotes()
}

