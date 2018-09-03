//
//  AppDelegate.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 10/8/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//


// https://www.youtube.com/watch?v=jH2LdL-PsHI
// https://gist.github.com/caldwbr/5abe2dba3d1c2a6b525e141e7e967ac4
import UIKit
import CoreData
import Firebase
import FirebaseAuthUI
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import UserNotifications

// https://stackoverflow.com/a/32555911
// https://github.com/hackiftekhar/IQKeyboardManager
import IQKeyboardManagerSwift

import CallKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var callObserver : CXCallObserver? // not sure if we need this to log call activity
    
    // all viewcontrollers declared here
    let containerViewController = ContainerViewController()
    var adminVC : AdminVC?
    var allActivityVC : AllActivityVC?
    var assignUserVC : AssignUserVC?
    var chooseSpreadsheetTypeVC : ChooseSpreadsheetTypeVC?
    var editSocialMediaVC : EditSocialMediaVC?
    var editVideoMissionDescriptionVC : EditVideoMissionDescriptionVC?
    var editLegislatorForVideoVC : EditLegislatorForVideoVC?
    var limboViewController: LimboViewController?
    var myMissionViewController : MyMissionViewController?
    var missionDetailsVC : MissionDetailsVC?
    var missionSummaryTVC : MissionSummaryTVC?
    //var noMissionVC : NoMissionVC?
    var myLegislatorsVC : MyLegislatorsVC?
    var myProfileVC : MyProfileVC?
    var newPhoneCampaignVC : NewPhoneCampaignVC?
    var searchUsersVC : SearchUsersVC?
    var switchTeamsVC : SwitchTeamsVC?
    var wrapUpCallViewController : WrapUpViewController?
    var leftViewController : SidePanelViewController?
    var unassignedUsersVC : UnassignedUsersVC?
    var userIsBannedVC : UserIsBannedVC?
    var userMustSignCAViewController : UserMustSignCAViewController?
    //var videoChatInstructionsVC : VideoChatInstructionsView?
    var videoChatVC : VideoChatVC?
    var videoInvitationsVC : VideoInvitationsVC?
    var videoOffersVC : VideoOffersVC?
    var videoTypes = [VideoType]()
    
    var myDelegate : AppDelegateDelegate?
    var window: UIWindow?
    
    // https://www.raywenderlich.com/150015/callkit-tutorial-ios
    //lazy var providerDelegate: ProviderDelegate = ProviderDelegate(callManager: self.callManager)
    
    // source:  https://github.com/firebase/quickstart-ios/blob/master/messaging/MessagingExampleSwift/AppDelegate.swift
    let gcmMessageIDKey = "gcm.message_id"
    
    
    override init() {
        //UIApplication.shared.registerForRemoteNotifications()
        
        // https://www.youtube.com/watch?v=jH2LdL-PsHI
        // https://gist.github.com/caldwbr/5abe2dba3d1c2a6b525e141e7e967ac4
        
        adminVC = AdminVC()
        allActivityVC = AllActivityVC()
        assignUserVC = AssignUserVC()
        chooseSpreadsheetTypeVC = ChooseSpreadsheetTypeVC()
        editSocialMediaVC = EditSocialMediaVC()
        editVideoMissionDescriptionVC = EditVideoMissionDescriptionVC()
        editLegislatorForVideoVC = EditLegislatorForVideoVC()
        limboViewController = LimboViewController()
        myMissionViewController = MyMissionViewController()
        missionDetailsVC = MissionDetailsVC()
        myLegislatorsVC = MyLegislatorsVC()
        myProfileVC = MyProfileVC()
        newPhoneCampaignVC = NewPhoneCampaignVC()
        searchUsersVC = SearchUsersVC()
        switchTeamsVC = SwitchTeamsVC()
        wrapUpCallViewController = WrapUpViewController()
        unassignedUsersVC = UnassignedUsersVC()
        missionSummaryTVC = MissionSummaryTVC()
        userIsBannedVC = UserIsBannedVC()
        userMustSignCAViewController = UserMustSignCAViewController()
        //videoChatInstructionsVC = VideoChatInstructionsView()
        videoChatVC = VideoChatVC()
        videoInvitationsVC = VideoInvitationsVC()
        videoOffersVC = VideoOffersVC()
        
        MissionItem.nextViewController = myMissionViewController
        MissionItem2.nextViewController = myLegislatorsVC
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
    }
    
    @objc func refreshToken(notification: NSNotification) {
        let refreshToken = InstanceID.instanceID().token()!
        print("**** \(refreshToken) ****")
    }
    
    
    
    func ConnectToFCM() {
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        if let token = InstanceID.instanceID().token() {
            print("DCS: " + token)
        }
        
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshToken(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        // [END register_for_notifications]
        
        
        // Load a named file for switching between dev and prod firebase instances
        // see https://firebase.google.com/docs/configure/
        //let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist")
        guard let fileopts = FirebaseOptions.init(contentsOfFile: filePath!)
            else { assert(false, "Couldn't load config file")
                return false
        }
        //***// IMPORTANT!!!!!!!!!
        FirebaseApp.configure(options: fileopts)
        
        
        // https://stackoverflow.com/a/32555911
        // https://github.com/hackiftekhar/IQKeyboardManager
        // Automatically moves input fields up when the keyboard is present so the input isn't hidden
        IQKeyboardManager.shared.enable = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window!.rootViewController = containerViewController
        window!.makeKeyAndVisible()
        
        
        leftViewController = SidePanelViewController()
        leftViewController?.menuItems = MenuItems.sharedInstance.mainMenu
        leftViewController?.sections = MenuItems.sharedInstance.mainSections
        leftViewController?.menuController = containerViewController
        
        
        print("AppDelegate: didFinishLaunchingWithOptions: ")
        
        
        // ref:  https://stackoverflow.com/a/42754882
        // in applicationDidFinishLaunching...  Not sure if this supports logging calls or not.
        // There ARE som CallKit classes under /misc that don't support call logging.  Should be cleaned out if
        // they're really not used.  Otherwise just confusion later on when I'm trying to figure out how something works.
        callObserver = CXCallObserver()
        callObserver?.setDelegate(self, queue: nil) // nil queue means main thread
        
        // capture all the different video types...
        // We use this list in VideoChatVC
        Database.database().reference().child("video/types").observe(.value, with:{ (snapshot) in
            let children = snapshot.children
            while let snap = children.nextObject() as? DataSnapshot {
                if let vt = VideoType.getVideoTypeFrom(snapshot: snap) {
                    self.videoTypes.append(vt)
                }
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        return true
    }
    
    // We need to know landscape/portrait orientation
    // because that affects how far the main window should slide over to the right and whether or not we
    // need to allow scrolling of the menu
    // AppDelegate is where this function is referenced
    @objc func rotated() {
        containerViewController.rotated()
        videoChatVC?.rotated()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("AppDelegate: applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("AppDelegate: applicationDidEnterBackground")
        
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("AppDelegate: applicationWillEnterForeground")
    }

    
    /**********
     This is what gets called when the user returns from a phone call
     We need to figure out how to send the user to the "Wrap Up" screen
     **********/
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("AppDelegate: applicationDidBecomeActive")
        
        ConnectToFCM()
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        ConnectToFCM()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("AppDelegate: applicationWillTerminate")
    }

    
    // https://gist.github.com/caldwbr/5abe2dba3d1c2a6b525e141e7e967ac4
    //***// SUPER IMPORTANT FUNCTION!!!!!!!!!!!!!!
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled || GIDSignIn.sharedInstance().handle(
            url,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TelePatriot")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // I don't think we need this...
    // https://www.raywenderlich.com/150015/callkit-tutorial-ios
    //func displayIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)?) {
        //providerDelegate.reportIncomingCall(uuid: uuid, handle: handle, hasVideo: hasVideo, completion: completion)
    //}

    func onCallEnded() {
        // set in MyMissionViewController
        // If the user has a "currentMissionItem", we need to send them to the WrapUpViewController screen
        // so they can enter some notes on the call.
        if let vc = wrapUpCallViewController {
            var gotoWrapUpScreen = false
            if let _ = TPUser.sharedInstance.currentMissionItem {
                
                // call begin is recorded in MyMissionViewController.makeCall()
                endPhoneCallForOriginalStyleMissionItem()
                gotoWrapUpScreen = true
            }
            else if let mi2 = TPUser.sharedInstance.currentMissionItem2 {
                
                // call begin is recorded in OfficeTableViewCell.makeCall()
                endPhoneCallForMissionItem2(mission_item: mi2)
                gotoWrapUpScreen = true
            }
            
            if gotoWrapUpScreen {
                // myDelegate is assigned in ContainerViewController.viewDidLoad()
                // It's probably assigned to CenterViewController
                myDelegate?.show(viewController: vc)
            }
        }
    }
    
    
    private func endPhoneCallForMissionItem2(mission_item: MissionItem2) {
        
        guard let phone = mission_item.getPhone(),
            let mission_name = mission_item.getMission_name(),
            let legislator = mission_item.legislator,
            let legfirstname = legislator.first_name as? String,
            let leglastname = legislator.last_name as? String,
            let legstate = legislator.state as? String,
            let legchamber = legislator.chamber as? String,
            let legdistrict = legislator.district as? String else {
                return
        }
        
        // call begin is recorded in OfficeTableViewCell.makeCall()
        let m = CallLegislatorEvent(event_type: "ended call to",
                                    volunteer_uid: TPUser.sharedInstance.getUid(),
                                    volunteer_name: TPUser.sharedInstance.getName(),
                                    mission_name: mission_name,
                                    phone: phone,
                                    volunteer_phone: "phone number not available", // <- this sucks https://stackoverflow.com/a/40719308
            legislator_name: legfirstname+" "+leglastname,
            legislator_state_abbrev: legstate.uppercased(),
            legislator_chamber: legchamber,
            legislator_district: legdistrict,
            event_date: Util.getDate_Day_MMM_d_hmmss_am_z_yyyy())
        
        
        let ref = Database.database().reference().child("users/\(TPUser.sharedInstance.getUid())/activity")
        ref.child("all").childByAutoId().setValue(m.dictionary())
        ref.child("by_phone_number").child(phone).childByAutoId().setValue(m.dictionary())
    }
    
    
    /***************************************
     This is us wrapping up a phone call
     "Original Style" refers to this as the first kind of phone call and mission type that was ever created
     ***************************************/
    private func endPhoneCallForOriginalStyleMissionItem() {
        guard let mission_name = TPUser.sharedInstance.currentMissionItem?.mission_name else { return }
        guard let supporter_name = TPUser.sharedInstance.currentMissionItem?.name else { return }
        guard let phone = TPUser.sharedInstance.currentMissionItem?.phone else { return }
        
        // just like User.completeMissionItem() in Android
        let m = MissionItemEvent(event_type: "ended call to",
                                 volunteer_uid: TPUser.sharedInstance.getUid(),
                                 volunteer_name: TPUser.sharedInstance.getName(),
                                 mission_name: mission_name,
                                 phone: phone,
                                 volunteer_phone: "phone number not available", // <- this sucks https://stackoverflow.com/a/40719308
            supporter_name: supporter_name,
            event_date: getDateString())
        
        // the "guard" will unwrap the team name.  Otherwise, you'll get nodes written to the
        // database like this...  Optional("The Cavalry")
        guard let team = TPUser.sharedInstance.getCurrentTeam()?.team_name else {
            return
        }
        let ref = Database.database().reference().child("teams/\(team)/activity")
        ref.child("all").childByAutoId().setValue(m.dictionary())
        ref.child("by_phone_number").child(phone).childByAutoId().setValue(m.dictionary())
    }
    
    
    func getDateString() -> String {
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d, h:mm:ss a z yyyy"
        return dateFormatter.string(from: date)
    }
    
}


// ref:  https://stackoverflow.com/a/42754882
var callObserver: CXCallObserver! // add property

// ref:  https://stackoverflow.com/a/42754882
extension AppDelegate: CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        
        if call.hasEnded == true {
            print("Disconnected")
            onCallEnded()
        }
        if call.isOutgoing == true && call.hasConnected == false {
            print("Dialing")
        }
        if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            print("Incoming")
        }
        
        if call.hasConnected == true && call.hasEnded == false {
            print("Connected")
        }
    }
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}
