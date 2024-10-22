//
//  AppDelegate.swift
//  KnowUrBMI
//
//  Created by Reuben Simphiwe Kuse on 2024/09/16.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestNotificationPermission()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: CalculateViewController())
        return true
    }


    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted!")
                self.scheduleDailyNotifications()
            } else {
                print("Notification permission denied.")
            }
        }
    }
    

    func scheduleDailyNotifications() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "BMI Progress Reminder"
        content.body = "Don't forget to check your BMI progress, workouts, and fasting today!"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 8 // 8 AM
        let triggerAM = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        dateComponents.hour = 12 // 12 PM
        let triggerMidday = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        dateComponents.hour = 18 // 6 PM
        let triggerPM = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let requestAM = UNNotificationRequest(identifier: "BMIReminderAM", content: content, trigger: triggerAM)
        let requestMidday = UNNotificationRequest(identifier: "BMIReminderMidday", content: content, trigger: triggerMidday)
        let requestPM = UNNotificationRequest(identifier: "BMIReminderPM", content: content, trigger: triggerPM)
        
        center.add(requestAM)
        center.add(requestMidday)
        center.add(requestPM)
    }
}



