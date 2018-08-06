//
//  TPUserTableViewCell.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/19/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class TPUserTableViewCell: UITableViewCell {
    
    let nameLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let emailLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let joinedLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let petitionLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let confidentialityAgreementLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let bannedLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private func ok_image() -> UIImage {
        return UIImage(named: "ok.png")!
    }
    
    private func warn_image() -> UIImage {
        return UIImage(named: "warning.png")!
    }
    
    private func error_image() -> UIImage {
        return UIImage(named: "error.png")!
    }
    
    /********
    private func warn_icon() -> UIImageView  {
        return status_image(img: warn_image())
    }
    
    private func error_icon() -> UIImageView  {
        return status_image(img: error_image())
    }
    
    private func ok_icon() -> UIImageView  {
        return status_image(img: ok_image())
    }
     ********/
    
    private func status_image(img: UIImage) -> UIImageView {
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }
    
    let petitionIcon : UIImageView = {
        let img = UIImage(named: "warning.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let confidentialityAgreementIcon : UIImageView = {
        let img = UIImage(named: "error.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let bannedIcon : UIImageView = {
        let img = UIImage(named: "warning.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    var ref : DatabaseReference?
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        // cell has...
        // Name
        // Joined:  join date
        // icon Petition: unknown
        // icon Confidentiality Agreement: unknown
        // icon Banned: unknown
    }
    
    func commonInit(user: TPUser, ref: DatabaseReference) {
        
        guard let name = user.getName() as String?,
            let email = user.getEmail() as String?else {
                return }
        
        if let joinDate = user.created {
            joinedLabel.text = "Joined: "+joinDate  // see UserHolder.setUser() in Android
        } else {
            joinedLabel.text = "Joined: (not available)"
        }
        
        if let has_signed_petition = user.has_signed_petition {
            let yn = has_signed_petition ? "Signed" : "Not Signed"
            petitionLabel.text = "Petition: "+yn  // see UserHolder.setUser() in Android
            petitionIcon.image = has_signed_petition ? ok_image() : warn_image()
        } else {
            petitionLabel.text = "Petition: unknown"
            petitionIcon.image = warn_image()
        }
        
        if let has_signed_confidentiality_agreement = user.has_signed_confidentiality_agreement {
            let yn = has_signed_confidentiality_agreement ? "Signed" : "Not Signed"
            confidentialityAgreementLabel.text = "Confidentiality Agreement: "+yn  // see UserHolder.setUser() in Android
            confidentialityAgreementIcon.image = has_signed_confidentiality_agreement ? ok_image() : error_image()
        } else {
            confidentialityAgreementLabel.text = "Confidentiality Agreement: unknown"
            confidentialityAgreementIcon.image = warn_image() // <-- not the greatest...
            // A warning is fine when we are on-boarding someone.  But we may want the error icon when we are
            // about to assign someone to a team - because we don't want people assigned to real missions that
            // haven't signed the conf agreement yet.  But perhaps
        }
        
        if let is_banned = user.is_banned {
            let yn = is_banned ? "Yes" : "No"
            bannedLabel.text = "Banned: "+yn  // see UserHolder.setUser() in Android
            bannedIcon.image = is_banned ? error_image() : ok_image()
        } else {
            bannedLabel.text = "Banned: unknown"
            bannedIcon.image = warn_image()
        }
        
        self.ref = ref
        
        self.addSubview(nameLabel)
        nameLabel.text = name
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        //nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        //nameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        self.addSubview(emailLabel)
        emailLabel.text = email
        emailLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16).isActive = true
        emailLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        //emailLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        //emailLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        self.addSubview(joinedLabel)
        joinedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        joinedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        joinedLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        //joinedLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        
        self.addSubview(petitionIcon)
        petitionIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        petitionIcon.topAnchor.constraint(equalTo: joinedLabel.bottomAnchor, constant: 4).isActive = true
        //petitionIcon.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        //petitionIcon?.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        self.addSubview(petitionLabel)
        petitionLabel.leadingAnchor.constraint(equalTo: petitionIcon.trailingAnchor, constant: 4).isActive = true
        petitionLabel.centerYAnchor.constraint(equalTo: petitionIcon.centerYAnchor).isActive = true
        //petitionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        //petitionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        
        self.addSubview(confidentialityAgreementIcon)
        confidentialityAgreementIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        confidentialityAgreementIcon.topAnchor.constraint(equalTo: petitionLabel.bottomAnchor, constant: 4).isActive = true
        //confidentialityAgreementIcon?.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        self.addSubview(confidentialityAgreementLabel)
        confidentialityAgreementLabel.leadingAnchor.constraint(equalTo: confidentialityAgreementIcon.trailingAnchor, constant: 4).isActive = true
        confidentialityAgreementLabel.centerYAnchor.constraint(equalTo: confidentialityAgreementIcon.centerYAnchor).isActive = true
        //confidentialityAgreementLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        
        self.addSubview(bannedIcon)
        bannedIcon.leadingAnchor.constraint(equalTo: confidentialityAgreementIcon.leadingAnchor, constant: 0).isActive = true
        bannedIcon.topAnchor.constraint(equalTo: confidentialityAgreementIcon.bottomAnchor, constant: 0).isActive = true
        
        
        self.addSubview(bannedLabel)
        bannedLabel.leadingAnchor.constraint(equalTo: confidentialityAgreementLabel.leadingAnchor, constant: 0).isActive = true
        bannedLabel.centerYAnchor.constraint(equalTo: bannedIcon.centerYAnchor).isActive = true
        //bannedLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
    }
    
}
