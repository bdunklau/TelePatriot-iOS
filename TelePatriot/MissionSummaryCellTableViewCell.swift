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
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let missionType : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let missionCreatedOn : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let missionCreatedBy : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var mission_id : String?
    var uid : String? /* user id */
    
    var ref : DatabaseReference?
    
    let activateSwitch : UISwitch = {
        let s = UISwitch(frame: CGRect(x: 300, y: 5, width: 30, height: 10))
        return s
    }()
    
    func missionActivated(_ sender: Any) {
    }
    
    /**************
    init() {
        super.init()
        ref = Database.database().reference()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
     ************/

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(missionSummary: MissionSummary, ref: DatabaseReference) {
        
        self.ref = ref
        
        let active = missionSummary.active != nil ? missionSummary.active! : false
        mission_id = missionSummary.mission_id
        /*user id*/ uid = missionSummary.uid
        missionName.text = missionSummary.mission_name
        activateSwitch.setOn(active, animated: true)
        missionType.text = missionSummary.mission_type
        if let d = missionSummary.mission_create_date { missionCreatedOn.text = "Created on "+d }
        if let n = missionSummary.name { missionCreatedBy.text = "By "+n }
        
        self.addSubview(missionName)
        
        missionName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        missionName.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        missionName.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        missionName.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        activateSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        self.addSubview(activateSwitch)
        /********
        activateSwitch.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32).isActive = true
        activateSwitch.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        activateSwitch.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        activateSwitch.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
         ******/
        
        self.addSubview(missionType)
        missionType.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        missionType.topAnchor.constraint(equalTo: self.topAnchor, constant: 32).isActive = true
        missionType.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        //missionType.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        /***********/
        self.addSubview(missionCreatedOn)
        missionCreatedOn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        missionCreatedOn.topAnchor.constraint(equalTo: self.topAnchor, constant: 64).isActive = true
        missionCreatedOn.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        //missionCreatedOn.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        /*********/
        self.addSubview(missionCreatedBy)
        missionCreatedBy.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        missionCreatedBy.topAnchor.constraint(equalTo: self.topAnchor, constant: 96).isActive = true
        missionCreatedBy.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        //missionCreatedBy.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
         /********/
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        var on = sender.isOn
        
        guard let userId = uid, let missionId = mission_id else {
            return }
        
        let onString = on ? "true" : "false"
        
        ref?.child(missionId).child("active").setValue(on);
        ref?.child(missionId).child("uid_and_active").setValue(userId+"_"+onString);
        /**********
         
         activeSwitch.setText(b ? "Active" : "Inactive");
         mission.setActive(b);
         mission.setUid_and_active(mission.getUid()+"_"+b);
         ref.child("active").setValue(b);
         ref.child("uid_and_active").setValue(mission.getUid()+"_"+b);
         **********/
    }
    
}
