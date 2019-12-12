//
//  InviteByTextMessageVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 10/10/19.
//  Copyright © 2019 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase


// Android equiv:  InviteByTextMessageDlg
class InviteByTextMessageVC: BaseViewController {

    var inviteByTextMessageDelegate: InviteByTextMessageDelegate?
    
    
    let headingLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Invite Someone by Text Message"
        l.font = l.font.withSize(24)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    
    let nameField : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "Full name"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let phoneField : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.keyboardType = .decimalPad  // restricts to numeric only
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "Mobile phone #"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let send_text_button : BaseButton = {
        let button = BaseButton(text: "Send Text")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendTextMessage(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let cancel_button : BaseButton = {
        let button = BaseButton(text: "Cancel")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headingLabel)
        headingLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        
        view.addSubview(nameField)
        nameField.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 32).isActive = true
        nameField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        nameField.heightAnchor.constraint(equalToConstant: CGFloat.init(32)).isActive = true
        nameField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
        
        view.addSubview(phoneField)
        phoneField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 8).isActive = true
        phoneField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        phoneField.heightAnchor.constraint(equalToConstant: CGFloat.init(32)).isActive = true
        phoneField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
        
        view.addSubview(send_text_button)
        send_text_button.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 24).isActive = true
        send_text_button.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -24).isActive = true
        
        view.addSubview(cancel_button)
        cancel_button.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 24).isActive = true
        cancel_button.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 24).isActive = true
    }
    
    
    @objc private func sendTextMessage(_ sender: UIButton) {
        if UIDevice.current.orientation.isPortrait {
            alertToRotatePhone()
            return
        }
        
        
        // get name and phone number
        // construct the [String:Any] and pass back to the caller through the delegate
        guard let name = nameField.text,
            let phone = phoneField.text,
            name != "",
            phone != "" else {
                return
        }
        let userData : [String:String] = ["name": name,
                                          "sms_phone": phone]
        
        // inviteByTextMessageDelegate is inviteSomeoneVC - see inviteSomeoneVC.inviteByTextMessage()
        inviteByTextMessageDelegate?.userInvitedByTextMessage(someone: userData)
    }
    
    
    @objc private func cancel(_ sender: UIButton) {
        if UIDevice.current.orientation.isPortrait {
            alertToRotatePhone()
            return
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    private func alertToRotatePhone() {
        // hack - pop up an alert telling the user the phone has to be in landscape mode
        // and quit early
        let alert = UIAlertController(title: title, message: "Your phone must be in landscape orientation", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Rotate Your Phone", style: .default, handler: { action in
            switch action.style {
            case .default:
                return
            case .cancel:
                return
            case .destructive:
                return
            }
        })
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }

}

protocol InviteByTextMessageDelegate {
    func userInvitedByTextMessage(someone: [String:String])
}
