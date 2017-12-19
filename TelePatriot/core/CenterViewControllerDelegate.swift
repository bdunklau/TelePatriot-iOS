//
//  CenterViewControllerDelegate.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/22/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
    
    // See ContainerViewController - that is (probably) the implementation of this protocol
    @objc optional func toggleLeftPanel()
    @objc optional func toggleRightPanel()
    @objc optional func collapseSidePanels()
    func getAllActivityVC() -> AllActivityVC?
    func getAssignUserVC() -> AssignUserVC?
    func getChooseSpreadsheetTypeVC() -> ChooseSpreadsheetTypeVC?
    func getDirectorViewController() -> DirectorViewController?
    func getMissionSummaryTVC() -> MissionSummaryTVC?
    func getMyMissionViewController() -> MyMissionViewController?
    //func getNoMissionVC() -> NoMissionVC?
    func getNewPhoneCampaignVC() -> NewPhoneCampaignVC?
    func getSwitchTeamsVC() -> SwitchTeamsVC?
    func getUnassignedUsersVC() -> UnassignedUsersVC?
    func viewChosen()
}
