//
//  MissionSummaryCellTableViewCell.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/5/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

class MissionSummaryCellTableViewCell: UITableViewCell {

    @IBOutlet weak var missionName: UILabel!
    
    @IBOutlet weak var missionType: UILabel!
    
    @IBOutlet weak var missionCreatedOn: UILabel!
    
    @IBOutlet weak var missionCreatedBy: UILabel!
    
    @IBAction func missionActivated(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(missionSummary: MissionSummary) {
        missionName.text = missionSummary.mission_name
        missionType.text = missionSummary.mission_type
        missionCreatedOn.text = missionSummary.mission_create_date
        missionCreatedBy.text = missionSummary.name
    }
    
}
