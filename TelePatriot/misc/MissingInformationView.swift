//
//  MissingInformationView.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 10/19/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit

class MissingInformationView: UIView {

    var missingInformationDelegate : MissingInformationDelegate?
    var uid: String?
    
    let please_enter_information : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Please enter the following"
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    
    let name_field : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "Your name"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let email_field : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "Your email"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let save_button : BaseButton = {
        let button = BaseButton(text: "Save")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveInfo(_:)), for: .touchUpInside)
        return button
    }()
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    // #1
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // #2
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setValues(uid: String, user: [String:String]) {
        self.uid = uid
        if let name = user["name"] {
            name_field.text = name
        }
        if let email = user["email"] {
            email_field.text = email
        }
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        // Create, add and layout to the children views ...
        
        var topMargin:CGFloat = 64
        addSubview(please_enter_information)
        please_enter_information.topAnchor.constraint(equalTo: self.topAnchor, constant: topMargin).isActive = true
        please_enter_information.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        
        if(name_field.text == nil || name_field.text == "") {
            topMargin = topMargin + 32
            addSubview(name_field)
            name_field.topAnchor.constraint(equalTo: self.topAnchor, constant: topMargin).isActive = true
            name_field.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
            name_field.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
            name_field.heightAnchor.constraint(equalToConstant: 32).isActive = true
        }
        
        if(email_field.text == nil || email_field.text == "") {
            topMargin = topMargin + 48
            addSubview(email_field)
            email_field.topAnchor.constraint(equalTo: self.topAnchor, constant: topMargin).isActive = true
            email_field.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
            email_field.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
            email_field.heightAnchor.constraint(equalToConstant: 32).isActive = true
        }
        
        topMargin = topMargin + 64
        addSubview(save_button)
        save_button.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        save_button.topAnchor.constraint(equalTo: self.topAnchor, constant: topMargin).isActive = true
    }
    
    @objc private func saveInfo(_ sender:UIButton) {
        if let uid = uid, let name = name_field.text, let email = email_field.text {
            // missingInformationDelegate is probably LimboViewController
            missingInformationDelegate?.saveInfo(uid: uid, name: name, email: email)
        }
    }

}

protocol MissingInformationDelegate {
    func saveInfo(uid: String, name: String, email: String)
}
