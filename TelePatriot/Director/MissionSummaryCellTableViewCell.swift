//
//  MissionSummaryCellTableViewCell.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/5/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class MissionSummaryCellTableViewCell: UITableViewCell {

    let missionName : UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let percent_complete : UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let missionType : UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let missionCreatedOn : UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let missionCreatedBy : UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let total_rows_in_spreadsheet : UILabel = {
        let l = UILabel()
        l.textColor = UIColor.gray
        l.font = .systemFont(ofSize: 12)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let total_rows_in_spreadsheet_with_phone : UILabel = {
        let l = UILabel()
        l.textColor = UIColor.gray
        l.font = .systemFont(ofSize: 12)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let total_rows_activated : UILabel = {
        let l = UILabel()
        l.textColor = UIColor.gray
        l.font = .systemFont(ofSize: 12)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let total_rows_deactivated : UILabel = {
        let l = UILabel()
        l.textColor = UIColor.gray
        l.font = .systemFont(ofSize: 12)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let total_rows_completed : UILabel = {
        let l = UILabel()
        l.textColor = UIColor.gray
        l.font = .systemFont(ofSize: 12)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    
    var mission_id : String?
    var uid : String? /* user id */
    
    var ref : DatabaseReference?
    
    let activateSwitch : UISwitch = {
        let s = UISwitch(frame: CGRect(x: 250, y: 5, width: 30, height: 10))
        return s
    }()
    
    
    
    func missionActivated(_ sender: Any) {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // In Android, the class is MissionHolder
    func commonInit(missionSummary: MissionSummary, ref: DatabaseReference) {
        
        self.ref = ref
        
        let active = missionSummary.active != nil ? missionSummary.active! : false
        guard let m_id = missionSummary.mission_id else { return }
        mission_id = m_id
        /*user id*/ uid = missionSummary.uid
        missionName.text = missionSummary.mission_name
        activateSwitch.setOn(active, animated: true)
        missionType.text = missionSummary.mission_type
        if let d = missionSummary.mission_create_date { missionCreatedOn.text = "Created on "+d }
        else { missionCreatedOn.text = "(Loading...)" }
        if let n = missionSummary.name { missionCreatedBy.text = "By "+n }
        
        if let trs = missionSummary.total_rows_in_spreadsheet {
            total_rows_in_spreadsheet.text = "Total rows in spreadsheet: \(trs)"
        } else {
            total_rows_in_spreadsheet.text = "Total rows in spreadsheet: -"
        }
        
        if let trsp = missionSummary.total_rows_in_spreadsheet_with_phone {
            total_rows_in_spreadsheet_with_phone.text = "Total rows with a phone number: \(trsp)"
        } else {
            total_rows_in_spreadsheet_with_phone.text = "Total rows with a phone number: -"
        }
        
        if let tra = missionSummary.total_rows_activated {
            total_rows_activated.text = "Total rows activated: \(tra)"
        } else {
            total_rows_activated.text = "Total rows activated: -"
        }
        
        if let trd = missionSummary.total_rows_deactivated {
            total_rows_deactivated.text = "Total rows inactive: \(trd)"
        } else {
            total_rows_deactivated.text = "Total rows inactive: -"
        }
        
        if let trc = missionSummary.total_rows_completed {
            total_rows_completed.text = "Total rows completed: \(trc)"
        } else {
            total_rows_completed.text = "Total rows completed: -"
        }
        
        if let pc = missionSummary.percent_complete {
            percent_complete.text = "Complete \(pc)%"
        } else {
            percent_complete.text = ""
        }
        
        
        self.addSubview(missionName)
        
        missionName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        missionName.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        missionName.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        //missionName.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        self.addSubview(percent_complete)
        percent_complete.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        percent_complete.topAnchor.constraint(equalTo: missionName.bottomAnchor, constant: 4).isActive = true
        percent_complete.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        
        activateSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        self.addSubview(activateSwitch)
        
        self.addSubview(missionType)
        missionType.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        missionType.topAnchor.constraint(equalTo: percent_complete.bottomAnchor, constant: 16).isActive = true
        missionType.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        self.addSubview(missionCreatedOn)
        missionCreatedOn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        missionCreatedOn.topAnchor.constraint(equalTo: missionType.bottomAnchor, constant: 4).isActive = true
        missionCreatedOn.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        self.addSubview(missionCreatedBy)
        missionCreatedBy.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        missionCreatedBy.topAnchor.constraint(equalTo: missionCreatedOn.bottomAnchor, constant: 4).isActive = true
        missionCreatedBy.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        self.addSubview(total_rows_in_spreadsheet)
        total_rows_in_spreadsheet.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        total_rows_in_spreadsheet.topAnchor.constraint(equalTo: missionCreatedBy.bottomAnchor, constant: 16).isActive = true
        total_rows_in_spreadsheet.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        self.addSubview(total_rows_in_spreadsheet_with_phone)
        total_rows_in_spreadsheet_with_phone.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        total_rows_in_spreadsheet_with_phone.topAnchor.constraint(equalTo: total_rows_in_spreadsheet.bottomAnchor, constant: 4).isActive = true
        total_rows_in_spreadsheet_with_phone.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        self.addSubview(total_rows_activated)
        total_rows_activated.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        total_rows_activated.topAnchor.constraint(equalTo: total_rows_in_spreadsheet_with_phone.bottomAnchor, constant: 4).isActive = true
        total_rows_activated.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        self.addSubview(total_rows_deactivated)
        total_rows_deactivated.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        total_rows_deactivated.topAnchor.constraint(equalTo: total_rows_activated.bottomAnchor, constant: 4).isActive = true
        total_rows_deactivated.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        self.addSubview(total_rows_completed)
        total_rows_completed.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        total_rows_completed.topAnchor.constraint(equalTo: total_rows_deactivated.bottomAnchor, constant: 4).isActive = true
        total_rows_completed.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        
        self.ref?.child(mission_id!).child("active").observe(.value, with: {(snapshot) in
            guard let active = snapshot.value as? Bool else { return }
            self.activateSwitch.setOn(active, animated: true)
        }, withCancel: nil)
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        var on = sender.isOn
        
        print("==================")
        print("switchValueDidChange: sender...")
        print(sender)
        
        guard let userId = uid,
            let missionId = mission_id else {
            return }
        
        let onString = on ? "true" : "false"
        
        ref?.child(missionId).child("active").setValue(on);
        ref?.child(missionId).child("uid_and_active").setValue(userId+"_"+onString);
    }
    
}
