//
//  AppDelegate.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/02.
//

//MARK: Check whether one of these header files are not needed
import UIKit
import CoreData
import Foundation
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var restrictRotation:UIInterfaceOrientationMask = .portrait
//
    var window: UIWindow?
    
    var delegate: CurrentStatusViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (isAllowed, error) in }
        application.isIdleTimerDisabled = true
        
        UITabBar.appearance().barStyle = .black
        
//        let navigationController = UINavigationController(rootViewController: SettingTableViewController())
//
//        navigationController.pushViewController(SetTimerViewController(), animated: true)

        return true
    }
    
    
    
    // MARK: UISceneSession Lifecycle
    
//        func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//            // Called when a new scene session is being created.
//            // Use this method to select a configuration to create the new scene with.
//            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//        }
    
//        func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//            // Called when the user discards a scene session.
//            // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//            // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//            print("did discard scene sessions")
//        }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CoreDataPractice")
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
    
    //MARK: ENTER
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        delegate?.animateCircle()
        
        if TimerManager.shared.isTimeRunning {
            guard let exitDateTime = TimerManager.shared.timeToBeSaved.exitDateTime else { return }
            let enterDateTime = Date()
            
            let formatter = DateFormatter()
            formatter.timeStyle = .long
            formatter.dateStyle = .long
            
            let enterDate = formatter.date(from: formatter.string(from: enterDateTime))
            let exitDate = formatter.date(from: formatter.string(from: exitDateTime))

            let diffComponents = Calendar.current.dateComponents([ .day, .hour, .minute, .second], from: exitDate!, to: enterDate!)
            
            let days = diffComponents.day
            let hours = diffComponents.hour
            let minutes = diffComponents.minute
            let seconds = diffComponents.second

            var newSecondsForAdding = 0
            
            if 0 < days ?? 0 {
                let seconds = days! * 24 * 60 * 60
                newSecondsForAdding += seconds
            }
            if 0 < hours ?? 0 {
                let seconds = hours! * 60 * 60
                newSecondsForAdding += seconds
            }
            if 0 < minutes ?? 0 {
                let seconds = minutes! * 60
                newSecondsForAdding += seconds
            }
            if 0 < seconds ?? 0 {
                newSecondsForAdding += seconds!
            }
            
            TimerManager.shared.onGoingTime += newSecondsForAdding
        }
    }
    
    //MARK: EXIT
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        if TimerManager.shared.isTimeRunning {

            TimerManager.shared.timeToBeSaved.exitDateTime = Date()

            let content = UNMutableNotificationContent()
            content.title = "Break time is Over!"
            content.subtitle = "Get ready"
            content.body = "Time to go back to workout"
            content.badge = 0
            content.sound = UNNotificationSound.criticalSoundNamed(UNNotificationSoundName(rawValue: "HighPitchBellRing"), withAudioVolume: 1.0)
            
            let time = TimerManager.shared.timeToBeSaved.countUptoThisSec - TimerManager.shared.onGoingTime
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(time), repeats: false)
            let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {

        TimerManager.shared.onGoingTime = 0
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["timerdone"])
        
        Storage.store(CalendarManager.shared.workOutWithDate, to: .documents, as: "workOutCalendar.json")
        Storage.store(WorkOutToDoManager.shared.workOutToDos, to: .documents, as: "todos.json")
    }
    
//
//    var restrictRotation:UIInterfaceOrientationMask = .all
//
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
//    {
//        return self.restrictRotation
//    }
    
//    var shouldSupportAllOrientation = false
//    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
//        if (shouldSupportAllOrientation == true){
//            return UIInterfaceOrientationMask.all
//        }
//        return UIInterfaceOrientationMask.portrait
//    }
}

