//
//  NewPhoneCampaignVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/5/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

class NewPhoneCampaignVC: UIViewController {

    @IBOutlet weak var missionTitleField: UITextField!
    @IBOutlet weak var spreadsheetUrlField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        spreadsheetUrlField.layer.borderWidth = 0.5
        spreadsheetUrlField.layer.borderColor = borderColor.cgColor
        spreadsheetUrlField.layer.cornerRadius = 5.0
        
        missionTitleField.placeholder = "Mission Title"
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
