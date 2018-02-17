//
//  AssignUserVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/19/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class AssignUserVC: BaseViewController {
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize+4)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deactivateButton : BaseButton = {
        let button = BaseButton(text: "Deny/Deactivate")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(deactivateUser(_:)), for: .touchUpInside)
        return button
    }()
    
    let instructionsLabel : UILabel = {
        let label = UILabel()
        label.text = "Assign to One More Groups"
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let volunteerLabel : UILabel = {
        let label = UILabel()
        label.text = "Volunteer"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let directorLabel : UILabel = {
        let label = UILabel()
        label.text = "Director"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let adminLabel : UILabel = {
        let label = UILabel()
        label.text = "Admin"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let volunteerSwitch : UISwitch = {
        let s = UISwitch(frame: CGRect(x: 200, y: 245, width: 30, height: 10))
        return s
    }()
    
    let directorSwitch : UISwitch = {
        let s = UISwitch(frame: CGRect(x: 200, y: 295, width: 30, height: 10))
        return s
    }()
    
    let adminSwitch : UISwitch = {
        let s = UISwitch(frame: CGRect(x: 200, y: 345, width: 30, height: 10))
        return s
    }()
    
    let has_user_satisfied_legal_label : UILabel = {
        let label = UILabel()
        label.text = "Legal Requirements"
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let has_signed_petition_Label : UILabel = {
        let label = UILabel()
        label.text = "Petition"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static private let YES = 0
    static private let NO = 1
    static private let UNKNOWN = 2
    
    let has_signed_petition_segmented_control : UISegmentedControl = {
        let s = UISegmentedControl(items: ["Yes", "No", "Unknown"])
        s.frame = CGRect(x: 150, y: 433, width: 200, height: 30)
        return s
    }()
    
    let has_signed_confidentiality_agreement_Label : UILabel = {
        let label = UILabel()
        label.text = "Confidentiality"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let has_signed_confidentiality_agreement_segmented_control : UISegmentedControl = {
        let s = UISegmentedControl(items: ["Yes", "No", "Unknown"])
        s.frame = CGRect(x: 150, y: 475, width: 200, height: 30)
        return s
    }()
    
    let is_banned_Label : UILabel = {
        let label = UILabel()
        label.text = "Banned"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let is_banned_segmented_control : UISegmentedControl = {
        let s = UISegmentedControl(items: ["Yes", "No", "Unknown"])
        s.frame = CGRect(x: 150, y: 517, width: 200, height: 30)
        return s
    }()
    
    let okButton : BaseButton = {
        let button = BaseButton(text: "OK")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(updateUser(_:)), for: .touchUpInside)
        return button
    }()
    
    // consolidate these two soon
    //var user : [String:Any]?
    private var user : TPUser? // We just keep an internal reference to the user to make updating easier
    
    var uid : String?
    //var assignUserDelegate : AssignUserDelegate?
    //var ref : DatabaseReference? // might not need this - the TPUser object has an internal db ref :)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //ref = Database.database().reference()
        
        guard let theUid = uid
            //let name = user?.getName() ,
            //let email = user?.getEmail()
            else {
                return }
        
        let auser = TPUser.create(uid: theUid, callback: {(user: TPUser) -> Void in
            
            self.user = user
            self.nameLabel.text = user.getName()
            self.emailLabel.text = user.getEmail()
            
            // NOTE: In the database, these are actually stored as strings "true" and "false" - oops
            self.volunteerSwitch.setOn(user.isVolunteer, animated: true)
            self.directorSwitch.setOn(user.isDirector, animated: true)
            self.adminSwitch.setOn(user.isAdmin, animated: true)
            
            self.has_signed_petition_segmented_control.selectedSegmentIndex = AssignUserVC.UNKNOWN
            self.has_signed_confidentiality_agreement_segmented_control.selectedSegmentIndex = AssignUserVC.UNKNOWN
            self.is_banned_segmented_control.selectedSegmentIndex = AssignUserVC.UNKNOWN
            
            if let pet = user.has_signed_petition {
                self.has_signed_petition_segmented_control.selectedSegmentIndex = pet ? AssignUserVC.YES : AssignUserVC.NO
            }
            
            if let conf = user.has_signed_confidentiality_agreement {
                self.has_signed_confidentiality_agreement_segmented_control.selectedSegmentIndex = conf ? AssignUserVC.YES : AssignUserVC.NO
            }
            
            if let ban = user.is_banned {
                self.is_banned_segmented_control.selectedSegmentIndex = ban ? AssignUserVC.YES : AssignUserVC.NO
            }
        })
        
        
        view.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        view.addSubview(emailLabel)
        emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 115).isActive = true
        emailLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        //emailLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        view.addSubview(deactivateButton)
        deactivateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deactivateButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 24).isActive = true
        
        view.addSubview(instructionsLabel)
        instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        instructionsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        //instructionsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        view.addSubview(volunteerLabel)
        volunteerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        volunteerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        volunteerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(volunteerSwitch)
        // switch placement is done in the declaration of the switch
        
        view.addSubview(directorLabel)
        directorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        directorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        //directorLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(directorSwitch)
        // switch placement is done in the declaration of the switch
        
        view.addSubview(adminLabel)
        adminLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        adminLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 350).isActive = true
        //adminLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(adminSwitch)
        // switch placement is done in the declaration of the switch
        
        
        view.addSubview(has_user_satisfied_legal_label)
        has_user_satisfied_legal_label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        has_user_satisfied_legal_label.topAnchor.constraint(equalTo: instructionsLabel.topAnchor, constant: 200).isActive = true
        
        
        view.addSubview(has_signed_petition_Label)
        has_signed_petition_Label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        has_signed_petition_Label.topAnchor.constraint(equalTo: has_user_satisfied_legal_label.bottomAnchor, constant: 15).isActive = true
        
        
        view.addSubview(has_signed_petition_segmented_control)
        // placement is done in the declaration of the switch
        
        //view.addSubview(has_signed_petition_Switch)
        // switch placement is done in the declaration of the switch
        
        
        view.addSubview(has_signed_confidentiality_agreement_Label)
        has_signed_confidentiality_agreement_Label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        has_signed_confidentiality_agreement_Label.topAnchor.constraint(equalTo: has_signed_petition_Label.bottomAnchor, constant: 20).isActive = true
        
        
        view.addSubview(has_signed_confidentiality_agreement_segmented_control)
        // placement is done in the declaration of the switch
        
        //view.addSubview(has_signed_confidentiality_agreement_Switch)
        // switch placement is done in the declaration of the switch
        
        
        view.addSubview(is_banned_Label)
        is_banned_Label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        is_banned_Label.topAnchor.constraint(equalTo: has_signed_confidentiality_agreement_Label.bottomAnchor, constant: 20).isActive = true
        
        
        view.addSubview(is_banned_segmented_control)
        // placement is done in the declaration of the switch
        
        //view.addSubview(is_banned_Switch)
        // switch placement is done in the declaration of the switch
        
        
        view.addSubview(okButton)
        okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        okButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc private func deactivateUser(_ sender: UIButton) {
        guard let usr = user else {
            return}
        
        // remove Volunteer, Director and Admin access for the person and set
        // account_disposition:deactivated
        adminSwitch.setOn(false, animated: true)
        directorSwitch.setOn(false, animated: true)
        volunteerSwitch.setOn(false, animated: true)
        
        usr.deactivate(deactivatedBy: TPUser.sharedInstance, callback: callback)
        
        // When we're done, just go back using the BackTracker - genius!
        BackTracker.sharedInstance.goBack()
        
        /*********
         
         extension Date {
         var msSince1970:Int64 {
         return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
         }
         init(ms: Int) {
         self = Date(timeIntervalSince1970: TimeInterval(ms / 1000))
         }
         }
         
         let one = Date().msSince1970
         let two = Date(ms: 0)
         
         print(one)
         print(two)

        ********/
    }
    
    
    @objc private func updateUser(_ sender: UIButton) {
        guard let usr = user else {
            return}
        
        usr.isAdmin = adminSwitch.isOn
        usr.isDirector = directorSwitch.isOn
        usr.isVolunteer = volunteerSwitch.isOn
        
        if has_signed_petition_segmented_control.selectedSegmentIndex == AssignUserVC.YES {
            usr.has_signed_petition = true
        } else if has_signed_petition_segmented_control.selectedSegmentIndex == AssignUserVC.NO {
            usr.has_signed_petition = false
        } else {
            usr.has_signed_petition = nil
        }
        
        if has_signed_confidentiality_agreement_segmented_control.selectedSegmentIndex == AssignUserVC.YES {
            usr.has_signed_confidentiality_agreement = true
        } else if has_signed_confidentiality_agreement_segmented_control.selectedSegmentIndex == AssignUserVC.NO {
            usr.has_signed_confidentiality_agreement = false
        } else {
            usr.has_signed_confidentiality_agreement = nil
        }
        
        if is_banned_segmented_control.selectedSegmentIndex == AssignUserVC.YES {
            usr.is_banned = true
        } else if is_banned_segmented_control.selectedSegmentIndex == AssignUserVC.NO {
            usr.is_banned = false
        } else {
            usr.is_banned = nil
        }
        
        usr.update(callback: callback)
        
        if volunteerSwitch.isOn || directorSwitch.isOn || adminSwitch.isOn {
            // as long as the user is assigned to some role/group, remove him from the /no_roles node
            Database.database().reference().child("no_roles").child(usr.getUid()).removeValue()
        }
        
        // When we're done, just go back using the BackTracker - genius!
        BackTracker.sharedInstance.goBack()
        
    }
    
    /************
    private func doTheBoolean(uiswitch: UISwitch, role: String) {
        
        guard let theUid = uid else {return}
        
        let boolval = uiswitch.isOn
        if boolval {
            ref?.child("users").child(theUid).child("roles").child(role).setValue("true"); // string, not boolean
        }
        else {
            ref?.child("users").child(theUid).child("roles").child(role).removeValue()
        }
    }
     ***********/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // STRAIGHT UP CODE DUPE FROM MyProfileVC
    func callback(error: NSError?) {
        //var error : NSError?
        //error = NSError(domain:"", code:400, userInfo: ["message": "Uh Oh! You got an error.  Try again and if this problem persists, talk to Michelle or Brent"])
        var message = "Account info updated"
        var title = "Success"
        let buttonText = "OK"
        if ((error) != nil) {
            message = "Hmmm - didn't expect this...\nYou should probably talk to Michelle or Brent"
            title = "Error"
            // need to display alert box to user on error or success
            if let msg = error!.userInfo["message"] as? String {
                message = msg
            }
        }
        
        let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: { action in
            switch action.style {
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

}

/******
protocol AssignUserDelegate {
    //func userAssigned(user : [String:Any])   // old way
    func userAssigned(user : TPUser)
}
 *******/
