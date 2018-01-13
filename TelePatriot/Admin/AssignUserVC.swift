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
    
    let instructionsLabel : UILabel = {
        let label = UILabel()
        label.text = "Assign to One More Groups"
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
    
    let okButton : BaseButton = {
        let button = BaseButton(text: "OK")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(assignUser(_:)), for: .touchUpInside)
        return button
    }()
    
    var user : [String:Any]?
    var uid : String?
    var assignUserDelegate : AssignUserDelegate?
    var ref : DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let userAttributes = user!["values"] as? [String:Any],
            let theUid = user!["uid"] as! String?,
            let name = userAttributes["name"] as! String?,
            let email = userAttributes["email"] as! String? else {
                return }
    
        uid = theUid
        
        ref = Database.database().reference()
        
        nameLabel.text = name
        emailLabel.text = email
     
        
        if let isVolunteer = userAttributes["isVolunteer"] as? String {
            volunteerSwitch.setOn(isVolunteer == "true", animated: true)
        }
        else {
            volunteerSwitch.setOn(false, animated: true)
        }
        
        
        if let isDirector = userAttributes["isDirector"] as? String {
            directorSwitch.setOn(isDirector == "true", animated: true)
        }
        else {
            directorSwitch.setOn(false, animated: true)
        }
        
        
        if let isAdmin = userAttributes["isAdmin"] as? String {
            adminSwitch.setOn(isAdmin == "true", animated: true)
        }
        else {
            adminSwitch.setOn(false, animated: true)
        }
        
        
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
        
        view.addSubview(instructionsLabel)
        instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        instructionsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        //instructionsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        view.addSubview(volunteerLabel)
        volunteerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        volunteerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        volunteerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(volunteerSwitch)
        // switch placement is done in the declaration of the switch
        
        view.addSubview(directorLabel)
        directorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        directorLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        //directorLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(directorSwitch)
        // switch placement is done in the declaration of the switch
        
        view.addSubview(adminLabel)
        adminLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        adminLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 350).isActive = true
        //adminLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(adminSwitch)
        // switch placement is done in the declaration of the switch
        
        view.addSubview(okButton)
        okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        okButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func assignUser(_ sender: UIButton) {
        guard user != nil else {return}
        
        doTheBoolean(uiswitch: volunteerSwitch, role: "Volunteer")
        doTheBoolean(uiswitch: directorSwitch, role: "Director")
        doTheBoolean(uiswitch: adminSwitch, role: "Admin")
        
        guard let theUid = uid else {return}
        
        if volunteerSwitch.isOn || directorSwitch.isOn || adminSwitch.isOn {
            // as long as the user is assigned to some role/group, remove him from the /no_roles node
            ref?.child("no_roles").child(theUid).removeValue()
        }
        
        assignUserDelegate?.userAssigned(user: user!)
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol AssignUserDelegate {
    func userAssigned(user : [String:Any])
}
