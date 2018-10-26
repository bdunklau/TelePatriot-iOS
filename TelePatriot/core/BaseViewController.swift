//
//  BaseViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/5/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set the background image for all screens
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "usflag")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        // trying to implement a back button - doesn't seem to do anything
        //let backTitle = NSLocalizedString("Back", comment: "Back button label")
        //self.addBackbutton(title: backTitle)
        
    }
    
    
    // Just do this from any vc instead of showScreen()
    //   self.present(vc, animated: true, completion: nil)
    
//    func showScreen(vc: UIViewController) {
//        var topController: UIViewController = (UIApplication.shared.keyWindow?.rootViewController!)!
//        while(topController.presentedViewController != nil) {
//            topController = topController.presentedViewController!
//        }
//        topController.present(vc, animated: true, completion: nil)
//    }
    
    func closeScreen() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
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


/******************************
 // trying to implement a back button - doesn't seem to do anything
extension UIViewController {
    
    @objc func backButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addBackbutton(title: String) {
        if let nav = self.navigationController,
            let item = nav.navigationBar.topItem {
            item.backBarButtonItem  = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action:
                #selector(self.backButtonAction))
        } else {
            if let nav = self.navigationController,
                let _ = nav.navigationBar.backItem {
                self.navigationController!.navigationBar.backItem!.title = title
            }
        }
    }
}
 *********************/
