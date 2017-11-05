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

    @IBOutlet weak var missionTitleField: UITextField!
    @IBOutlet weak var spreadsheetUrlField: UITextView!
    
    // https://www.youtube.com/watch?v=joVi3thZOqc
    let rootRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        spreadsheetUrlField.layer.borderWidth = 0.5
        spreadsheetUrlField.layer.borderColor = borderColor.cgColor
        spreadsheetUrlField.layer.cornerRadius = 5.0
        
        missionTitleField.placeholder = "Mission Title"
    }
    
    @IBAction func okPressed(_ sender: Any) {
        
        let key = rootRef.child("missions").childByAutoId().key
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
        
        let mission = ["/missions/\(key)": missionVals]
        rootRef.updateChildValues(mission)
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
