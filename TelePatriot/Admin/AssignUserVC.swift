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
    
    /*************
    let deactivateButton : BaseButton = {
        let button = BaseButton(text: "Deny/Deactivate")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(activateOrDeactivateUser(_:)), for: .touchUpInside)
        return button
    }()
    ************/
    
    let enabledDisabledLabel : UILabel = {
        let label = UILabel()
        label.text = ""  //"Enabled/Disabled"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let enabledDisabledSwitch : UISwitch = {
        let s = UISwitch(frame: CGRect(x: 200, y: 145, width: 30, height: 10))
        s.addTarget(self, action: #selector(enabledDisabledChanged(_:)), for: .touchUpInside)
        return s
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
    
    let volunteerSwitch : UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    let directorLabel : UILabel = {
        let label = UILabel()
        label.text = "Director"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let directorSwitch : UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    let videoCreatorLabel : UILabel = {
        let label = UILabel()
        label.text = "Video Creator"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let videoCreatorSwitch : UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    let adminLabel : UILabel = {
        let label = UILabel()
        label.text = "Admin"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let adminSwitch : UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
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
    
    let okbutton : BaseButton = {
        let button = BaseButton(text: "") // we'll display the "OK" once the user data has been loaded, so the admin can't click prematurely
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(updateUser(_:)), for: .touchUpInside)
        return button
    }()
    
    // consolidate these two soon
    //var user : [String:Any]?
    private var user : TPUser? // We just keep an internal reference to the user to make updating easier
    
    var passedInUser : TPUser? // passed in from UnassignedUsersVC and SearchUsersVC
    
    //var uid : String?
    //var assignUserDelegate : AssignUserDelegate?
    //var ref : DatabaseReference? // might not need this - the TPUser object has an internal db ref :)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //ref = Database.database().reference()
        
        guard let puser = passedInUser
            //let name = user?.getName() ,
            //let email = user?.getEmail()
            else {
                return }
        
        
        
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
        
        view.addSubview(enabledDisabledLabel)
        enabledDisabledLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        enabledDisabledLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16).isActive = true
        
        // just being careful.  We enable this below once the user has been loaded
        enabledDisabledSwitch.isEnabled = false
        view.addSubview(enabledDisabledSwitch)
        enabledDisabledSwitch.centerYAnchor.constraint(equalTo: enabledDisabledLabel.centerYAnchor, constant: 0).isActive = true
        enabledDisabledSwitch.leadingAnchor.constraint(equalTo: enabledDisabledLabel.trailingAnchor, constant: 48).isActive = true
        
        /*************
        view.addSubview(deactivateButton)
        deactivateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deactivateButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 24).isActive = true
        **************/
        
        view.addSubview(instructionsLabel)
        instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        instructionsLabel.topAnchor.constraint(equalTo: enabledDisabledLabel.bottomAnchor, constant: 32).isActive = true
        //instructionsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        view.addSubview(volunteerLabel)
        volunteerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        volunteerLabel.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 16).isActive = true
        //volunteerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(volunteerSwitch)
        volunteerSwitch.centerYAnchor.constraint(equalTo: volunteerLabel.centerYAnchor, constant: 0).isActive = true
        volunteerSwitch.leadingAnchor.constraint(equalTo: enabledDisabledSwitch.leadingAnchor, constant: 0).isActive = true
        
        view.addSubview(directorLabel)
        directorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        directorLabel.topAnchor.constraint(equalTo: volunteerLabel.bottomAnchor, constant: 16).isActive = true
        //directorLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(directorSwitch)
        directorSwitch.centerYAnchor.constraint(equalTo: directorLabel.centerYAnchor, constant: 0).isActive = true
        directorSwitch.leadingAnchor.constraint(equalTo: volunteerSwitch.leadingAnchor, constant: 0).isActive = true
        
        view.addSubview(videoCreatorLabel)
        videoCreatorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        videoCreatorLabel.topAnchor.constraint(equalTo: directorLabel.bottomAnchor, constant: 16).isActive = true
        
        view.addSubview(videoCreatorSwitch)
        videoCreatorSwitch.centerYAnchor.constraint(equalTo: videoCreatorLabel.centerYAnchor, constant: 0).isActive = true
        videoCreatorSwitch.leadingAnchor.constraint(equalTo: volunteerSwitch.leadingAnchor, constant: 0).isActive = true
        
        
        view.addSubview(adminLabel)
        adminLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        adminLabel.topAnchor.constraint(equalTo: videoCreatorLabel.bottomAnchor, constant: 16).isActive = true
        //adminLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(adminSwitch)
        adminSwitch.centerYAnchor.constraint(equalTo: adminLabel.centerYAnchor, constant: 0).isActive = true
        adminSwitch.leadingAnchor.constraint(equalTo: volunteerSwitch.leadingAnchor, constant: 0).isActive = true
        
        
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
        
        
        view.addSubview(okbutton)
        okbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        okbutton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        
        puser.currentlyBeingReviewed(by: TPUser.sharedInstance)
        
        //setActivateDeactivateButton(button: deactivateButton, user: puser)
        
        TPUser.create(uid: puser.getUid(), callback: {(user: TPUser) -> Void in
            
            self.user = user
            self.nameLabel.text = user.getName()
            self.emailLabel.text = user.getEmail()
            
            // NOTE: In the database, these are actually stored as strings "true" and "false" - oops
            self.volunteerSwitch.setOn(user.isVolunteer, animated: true)
            self.directorSwitch.setOn(user.isDirector, animated: true)
            self.videoCreatorSwitch.setOn(user.isVideoCreator, animated: true)
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
            
            self.enabledDisabledSwitch.setOn(!user.isDisabled(), animated: true)
            if user.isDisabled() {
                self.enabledDisabledLabel.text = "Disabled"
            }
            else {
                self.enabledDisabledLabel.text = "Enabled"
            }
            
            self.enabledDisabledSwitch.isEnabled = true
            self.okbutton.setTitle("OK", for: .normal)
        })
    }
    
    /***********
    private func setActivateDeactivateButton(button: UIButton, user: TPUser) {
        if user.isDeactivated() {
            // make the button blue and change text to say "Approve/Activate"
            button.setTitle("Approve/Activate", for: .normal)
            button.setTitleColor(UIButton().tintColor, for: .normal)
        }
        else {
            
            button.setTitle("Deny/Deactivate", for: .normal)
            button.setTitleColor(.red, for: .normal)
        }
    }
     ***********/
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*******************
    private func deactivateUser(user: TPUser) {
        
        // remove Volunteer, Director and Admin access for the person and set
        // account_disposition:deactivated
        adminSwitch.setOn(false, animated: true)
        directorSwitch.setOn(false, animated: true)
        volunteerSwitch.setOn(false, animated: true)
        
        user.deactivate(deactivatedBy: TPUser.sharedInstance, callback: callback)
    }
    
    
    @objc private func activateOrDeactivateUser(_ sender: UIButton) {
        guard let usr = user else {
            return}
        
        if usr.isDisabled() {
            usr.activate(activatedBy: TPUser.sharedInstance, callback: callback)
        }
        else {
            deactivateUser(user: usr)
        }
        
        // When we're done, just go back using the BackTracker - genius!
        BackTracker.sharedInstance.goBack()
    }
    ******************/
    
    
    /************************
     NOTE that disabling someone's account does not automatically remove them from the
     teams they're on.  That would make sense.  But the app just isn't programmed that way
     right now.  At one time, we cleared the user's list of teams whenever the enable/disable
     switch was moved to "disabled".  But that occurred before the user was saved.
     And I wanted to make sure we didn't lose team membership info prior to actually saving
     the user.  Otherwise, the admin could toggle to disabled, then back to enabled, never actually
     changing the state of the user but losing all the team info in the process.
    ************************/
    @objc func enabledDisabledChanged(_ sender: UISwitch) {
        enabledDisabledLabel.text = sender.isOn ? "Enabled" : "Disabled"
        if sender.isOn {
            volunteerSwitch.isEnabled = true
            directorSwitch.isEnabled = true
            adminSwitch.isEnabled = true
        }
        else {
            volunteerSwitch.setOn(false, animated: true)
            directorSwitch.setOn(false, animated: true)
            adminSwitch.setOn(false, animated: true)
            volunteerSwitch.isEnabled = false
            directorSwitch.isEnabled = false
            adminSwitch.isEnabled = false
        }
        if let usr = self.user {
            usr.setEnabled(sender.isOn) // handles both the enabled AND disabled case
        }
    }
    
    
    @objc private func updateUser(_ sender: UIButton) {
        guard let usr = user else {
            return}
        
        usr.isAdmin = adminSwitch.isOn
        usr.isDirector = directorSwitch.isOn
        usr.isVolunteer = volunteerSwitch.isOn
        usr.isVideoCreator = videoCreatorSwitch.isOn
        
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
