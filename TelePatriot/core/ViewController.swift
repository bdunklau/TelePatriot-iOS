//
//  ViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 10/31/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

// see:  https://www.youtube.com/watch?v=rafJcqqyS1E
class ViewController: UIViewController {

    @IBOutlet weak var menuButton1: UIBarButtonItem!
    
    @IBOutlet weak var menuButton2: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        sideMenus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenus() {
        if revealViewController() != nil {
            menuButton1.target = revealViewController()
            menuButton1.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275 // how far the menu slides open
            revealViewController().rightViewRevealWidth = 275 // how far the menu slides open
            
            menuButton2.target = revealViewController()
            menuButton2.action = #selector(SWRevealViewController.rightRevealToggle(_ :))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    /*
    // MARK: - nNavigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
