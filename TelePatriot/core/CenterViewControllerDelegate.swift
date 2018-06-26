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
    func getAdminVC() -> AdminVC?
    func getAllActivityVC() -> AllActivityVC?
    func getAssignUserVC() -> AssignUserVC?
    func getChooseSpreadsheetTypeVC() -> ChooseSpreadsheetTypeVC?
    func getDirectorViewController() -> DirectorViewController?
    func getMissionDetailsVC() -> MissionDetailsVC?
    func getMissionSummaryTVC() -> MissionSummaryTVC?
    func getMyMissionViewController() -> MyMissionViewController?
    //func getNoMissionVC() -> NoMissionVC?
    func getMyLegislatorsVC() -> MyLegislatorsVC?
    func getMyProfileVC() -> MyProfileVC?
    func getNewPhoneCampaignVC() -> NewPhoneCampaignVC?
    func getSearchUsersVC() -> SearchUsersVC?
    func getSwitchTeamsVC() -> SwitchTeamsVC?
    func getUnassignedUsersVC() -> UnassignedUsersVC?
    func getUserIsBannedVC() -> UserIsBannedVC?
    func getUserMustSignCAViewController() -> UserMustSignCAViewController?
    func getVideoChatViewController() -> VideoChatVC?
    func getVideoInvitationsViewController() -> VideoInvitationsVC?
    func viewChosen()
}
