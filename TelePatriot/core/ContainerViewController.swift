//
//  ContainerViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/22/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
//import QuartzCore


/*************************************
 source:  https://www.raywenderlich.com/78568/create-slide-out-navigation-panel-swift
 *************************************/
class ContainerViewController: UIViewController {

    
    var delegate : CenterViewControllerDelegate?
    
    var allowPanningFromRightToLeft = false
    
    enum SlideOutState {
        case bothCollapsed
        case leftPanelExpanded
        case rightPanelExpanded
    }
    
    var adminVC: AdminVC!
    var assignUserVC: AssignUserVC!
    var centerNavigationController: UINavigationController!
    var centerViewController: CenterViewController!
    var chooseSpreadsheetTypeVC: ChooseSpreadsheetTypeVC!
    var directorViewController: DirectorViewController!
    var myMissionViewController: MyMissionViewController!
    var newPhoneCampaignVC: NewPhoneCampaignVC!
    var missionSummaryTVC: MissionSummaryTVC!
    var searchUsersVC: SearchUsersVC!
    var switchTeamsVC: SwitchTeamsVC!
    var unassignedUsersVC: UnassignedUsersVC!
    
    var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .bothCollapsed
            showShadowForCenterViewController(shouldShowShadow: shouldShowShadow)
        }
    }
    
    var leftViewController: SidePanelViewController?
    var rightViewController: SidePanelViewController?
    let centerPanelExpandedOffset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*************
         This puts "Menu" in the upper left of the navigation bar.  And we COULD do this
         but there isn't a need right now because we display a "Get Started" button on the
         default CenterViewController screen and "Get Started" slides out the menu, so users
         will see right away that there is a slide-out menu
         **********/
        
        /*********
        let item2 = UIBarButtonItem(customView: menuButton)
        navigationItem.setLeftBarButtonItems([item2], animated: true)
         *************/
        
        
        // does this hide the back button on all screens?
        //self.navigationItem.hidesBackButton = true  // doesn't appear to have ANY effect  -1/12/18
        
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        // actually, would be a lot better if I instantiated ALL viewcontrollers INSIDE AppDelegate
        // Then I think I could get rid of the storyboard completely
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.myDelegate = centerViewController
        
        // creation and assignment of all these delegates should be more consistent
        appDelegate?.wrapUpCallViewController?.delegate = centerViewController
        
        appDelegate?.myLegislatorsVC?.addressUpdater = centerViewController
        appDelegate?.myProfileVC?.addressUpdater = centerViewController
        
        adminVC = getAdminVC()
        adminVC?.adminDelegate = centerViewController
        
        assignUserVC = getAssignUserVC()
        //assignUserVC.assignUserDelegate = centerViewController
        
        // modeled after the centerViewController stuff above
        directorViewController = getDirectorViewController()
        directorViewController.delegate = centerViewController
        
        myMissionViewController = getMyMissionViewController()
        //myMissionViewController?.noMissionDelegate = centerViewController
        
        newPhoneCampaignVC = getNewPhoneCampaignVC()
        newPhoneCampaignVC?.submitHandler = centerViewController
        
        chooseSpreadsheetTypeVC = getChooseSpreadsheetTypeVC()
        chooseSpreadsheetTypeVC?.delegate = centerViewController
        
        if let searchUsersVC = getSearchUsersVC() {
            searchUsersVC.searchUsersDelegate = centerViewController
        }
        
        switchTeamsVC = getSwitchTeamsVC()
        switchTeamsVC?.delegate = centerViewController
        
        unassignedUsersVC = getUnassignedUsersVC()
        unassignedUsersVC?.unassignedUsersDelegate = centerViewController
        
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMove(toParentViewController: self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    /****************
     This would work, but we would have to set delegate = CenterViewController
    @objc func slideMenu() {
        delegate?.toggleLeftPanel?()
    }
     **************/
}

private extension UIStoryboard {
    
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    /******
    class func leftViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LeftViewController") as? SidePanelViewController
    }
     ********/
    
    class func rightViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "RightViewController") as? SidePanelViewController
    }
    
    class func centerViewController() -> CenterViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "CenterViewController") as? CenterViewController
    }
    
    class func directorViewController() -> DirectorViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "DirectorViewController") as? DirectorViewController
    }
    
    /**********
    class func newPhoneCampaignVC() -> NewPhoneCampaignVC? {
        return mainStoryboard().instantiateViewController(withIdentifier: "NewPhoneCampaignVC") as? NewPhoneCampaignVC
    }
     **********/
    
    class func missionSummaryTVC() -> MissionSummaryTVC? {
        return mainStoryboard().instantiateViewController(withIdentifier: "MissionSummaryTVC") as? MissionSummaryTVC
    }
    
    /***********
    class func chooseSpreadsheetTypeVC() -> ChooseSpreadsheetTypeVC? {
        return mainStoryboard().instantiateViewController(withIdentifier: "ChooseSpreadsheetTypeVC") as? ChooseSpreadsheetTypeVC
    }
     ***********/
    
}

extension ContainerViewController: CenterViewControllerDelegate {
    
    func viewChosen() {
        allowPanningFromRightToLeft = false // see CenterViewController.doView()
    }
    
    func getAssignUserVC() -> AssignUserVC? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.assignUserVC
    }
    
    func getDirectorViewController() -> DirectorViewController? {
        if directorViewController == nil {
            directorViewController = UIStoryboard.directorViewController()
            if directorViewController == nil {
                return nil
            }
            directorViewController.delegate = centerViewController // we do this above - what's up?
        }
        
        return directorViewController
    }
    
    func getNewPhoneCampaignVC() -> NewPhoneCampaignVC? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.newPhoneCampaignVC
    }
    
    /****** not sure why the view wouldn't switch over to this view when no missions are found - oh well
    func getNoMissionVC() -> NoMissionVC? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.noMissionVC
    }
     ******/
    
    func getSwitchTeamsVC() -> SwitchTeamsVC? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.switchTeamsVC
    }
    
    func getAdminVC() -> AdminVC? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.adminVC
    }
    
    func getAllActivityVC() -> AllActivityVC? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.allActivityVC
    }
    
    func getChooseSpreadsheetTypeVC() -> ChooseSpreadsheetTypeVC? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.chooseSpreadsheetTypeVC
    }
    
    func getMyMissionViewController() -> MyMissionViewController? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.myMissionViewController
    }
    
    func getMyLegislatorsVC() -> MyLegislatorsVC? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.myLegislatorsVC
    }
    
    func getMyProfileVC() -> MyProfileVC? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.myProfileVC
    }
    
    func getMissionSummaryTVC() -> MissionSummaryTVC? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.missionSummaryTVC
    }
    
    func getSearchUsersVC() -> SearchUsersVC? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.searchUsersVC
    }
    
    func getUnassignedUsersVC() -> UnassignedUsersVC? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.unassignedUsersVC
    }
    
    
    func getUserIsBannedVC() -> UserIsBannedVC? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.userIsBannedVC
    }
    
    func getUserMustSignCAViewController() -> UserMustSignCAViewController? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.userMustSignCAViewController
    }
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
            allowPanningFromRightToLeft = true
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    /*********/
    func toggleRightPanel() {
        let notAlreadyExpanded = (currentState != .rightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
     /*********/
    
    /**********/ // doesn't look like this is even called anywhere
    func collapseSidePanels() {
        
        switch currentState {
        case .rightPanelExpanded:
            toggleRightPanel()
        case .leftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
     /***********/
    
    func addLeftPanelViewController() {
        guard leftViewController == nil else {
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        // leftViewController is instantiated now in AppDelegate
        leftViewController = appDelegate?.leftViewController  // accessed in CenterViewController.checkLoggedIn()
        addChildSidePanelController(leftViewController!)
        
        /*****
        if let vc = UIStoryboard.leftViewController() {
            vc.menuItems = MenuItems.sharedInstance.mainMenu
            vc.sections = MenuItems.sharedInstance.mainSections
            addChildSidePanelController(vc)
            leftViewController = vc
        }
         *****/
    }
    
    func addRightPanelViewController() {
        guard rightViewController == nil else { return }
        
        if let vc = UIStoryboard.rightViewController() {
            vc.menuItems = MenuItem.rightItems()
            vc.sections = MenuItem.rightSections()
            addChildSidePanelController(vc)
            rightViewController = vc
        }
    }
    
    func animateRightPanel(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .rightPanelExpanded
            animateCenterPanelXPosition(targetPosition: -centerNavigationController.view.frame.width + centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .bothCollapsed
                
                self.rightViewController?.view.removeFromSuperview()
                self.rightViewController = nil
            }
        }
    }
    
    
    func addChildSidePanelController(_ sidePanelController: SidePanelViewController) {
        
        sidePanelController.sidePanelDelegate = centerViewController
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .bothCollapsed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
}

extension ContainerViewController: UIGestureRecognizerDelegate {
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        let gestureIsDraggingFromRightToLeft = !gestureIsDraggingFromLeftToRight
        
        var panAllowed = (gestureIsDraggingFromRightToLeft && allowPanningFromRightToLeft) || (gestureIsDraggingFromLeftToRight)
        
        if !panAllowed {
            return
        }
        
        
        switch recognizer.state {
            
        case .began:
            if currentState == .bothCollapsed {
                if gestureIsDraggingFromLeftToRight {
                    addLeftPanelViewController()
                }
                else {
                    addRightPanelViewController()
                }
                
                showShadowForCenterViewController(shouldShowShadow: true)
            }
            
        case .changed:
            if let rview = recognizer.view {
                rview.center.x = rview.center.x + recognizer.translation(in: view).x
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
            
        case .ended:
            // this seems backwards, but this is the way it works (this is how we prevent swiping from right to left when it doesn't make sense)
            if currentState == .bothCollapsed {
                allowPanningFromRightToLeft = true
            }
            else {
                allowPanningFromRightToLeft = false
            }
            
            if let _ = leftViewController,
                let rview = recognizer.view {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = rview.center.x > view.bounds.size.width
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
                
            }
            else if let _ = rightViewController,
                let rview = recognizer.view {
                let hasMovedGreaterThanHalfway = rview.center.x < 0
                animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
            
        default:
            break
        }
    }
}

extension ContainerViewController: MenuController {
    
    // See SidePanelViewController.teamSelected()
    // I don't want to slide this out when the user first logs in.  See TPUser.fetchCurrentTeam()
    // That is when I DON'T want to slide the menu out.  I just want to make sure the "Team" menu
    // item has been updated
    func slideOutLeftMenu () {
        toggleLeftPanel() // buggy?  It toggles, doesn't necessarily guarantee the menu slides out
    }
}
