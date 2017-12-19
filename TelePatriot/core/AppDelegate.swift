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

// https://stackoverflow.com/a/32555911
// https://github.com/hackiftekhar/IQKeyboardManager
import IQKeyboardManagerSwift

import CallKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var callObserver : CXCallObserver?
    
    // all viewcontrollers declared here
    var allActivityVC : AllActivityVC?
    var assignUserVC : AssignUserVC?
    var chooseSpreadsheetTypeVC : ChooseSpreadsheetTypeVC?
    var myMissionViewController : MyMissionViewController?
    //var noMissionVC : NoMissionVC?
    var newPhoneCampaignVC : NewPhoneCampaignVC?
    var switchTeamsVC : SwitchTeamsVC?
    var wrapUpCallViewController : WrapUpViewController?
    var leftViewController : SidePanelViewController?
    var unassignedUsersVC : UnassignedUsersVC?
    
    var myDelegate : AppDelegateDelegate?
    var window: UIWindow?
    
    // https://www.raywenderlich.com/150015/callkit-tutorial-ios
    //lazy var providerDelegate: ProviderDelegate = ProviderDelegate(callManager: self.callManager)
    
    
    override init() {
        // https://www.youtube.com/watch?v=jH2LdL-PsHI
        // https://gist.github.com/caldwbr/5abe2dba3d1c2a6b525e141e7e967ac4
        
        
        // Load a named file for switching between dev and prod firebase instances
        // see https://firebase.google.com/docs/configure/
        //let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist")
        guard let fileopts = FirebaseOptions.init(contentsOfFile: filePath!)
            else { assert(false, "Couldn't load config file")
                return
        }
        //***// IMPORTANT!!!!!!!!!
        FirebaseApp.configure(options: fileopts)
        
        allActivityVC = AllActivityVC()
        assignUserVC = AssignUserVC()
        chooseSpreadsheetTypeVC = ChooseSpreadsheetTypeVC()
        myMissionViewController = MyMissionViewController()
        newPhoneCampaignVC = NewPhoneCampaignVC()
        switchTeamsVC = SwitchTeamsVC()
        wrapUpCallViewController = WrapUpViewController()
        unassignedUsersVC = UnassignedUsersVC()
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // https://stackoverflow.com/a/32555911
        // https://github.com/hackiftekhar/IQKeyboardManager
        // Automatically moves input fields up when the keyboard is present to the input isn't hidden
        IQKeyboardManager.sharedManager().enable = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let containerViewController = ContainerViewController()
        
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
        
        return true
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
        
        
        
        /********************
         This shows the screen we want but not in the context of the CenterViewController
         AND because there's no conditional logic here yet, this screen launches every time the app comes up
        // source: https://stackoverflow.com/a/42454462
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WrapUpViewController") as? WrapUpViewController {
            if let window = self.window, let rootViewController = window.rootViewController {
                var currentController = rootViewController
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
                currentController.present(controller, animated: true, completion: nil)
            }
        }
         ********************/
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
    func displayIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)?) {
        //providerDelegate.reportIncomingCall(uuid: uuid, handle: handle, hasVideo: hasVideo, completion: completion)
    }

    // call begin is recorded in MyMissionViewController.makeCall()
    func onCallEnded() {
        // set in MyMissionViewController
        // If the user has a "currentMissionItem", we need to send them to the WrapUpViewController screen
        // so they can enter some notes on the call.
        if let missionItem = TPUser.sharedInstance.currentMissionItem, let vc = wrapUpCallViewController {
            
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
            
            // myDelegate is assigned in ContainerViewController.viewDidLoad()
            myDelegate?.show(viewController: vc)
        }
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

