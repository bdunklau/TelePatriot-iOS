//
//  LimboViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/14/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

class LimboViewController: UIViewController {

    @IBOutlet weak var limboExplanation: UITextView!
    
    @IBAction func chatHelpPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        limboExplanation.text = TPUser.sharedInstance.getName() /*"Brent Dunklau"*/ + limboExplanation.text
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
