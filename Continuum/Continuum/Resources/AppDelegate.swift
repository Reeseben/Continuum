//
//  AppDelegate.swift
//  Continuum
//
//  Created by Ben Erekson on 8/10/21.
//

import UIKit
import CloudKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        checkStatus()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func checkStatus(){
        CKContainer.default().accountStatus { status, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
                
                guard let rootView = UIApplication.shared.windows.first!.rootViewController as? PostListTableViewController else { return }
                
                switch status {
                case .couldNotDetermine:
                    rootView.presentSimpleAlertWith(title: "iCloud servers are not reachable at the moment.", message: nil)
                case .available:
                    print("iCloud account logged in.")
                case .restricted:
                    rootView.presentSimpleAlertWith(title: "iCloud account is marked as restricted.", message: nil)
                case .noAccount:
                    rootView.presentSimpleAlertWith(title: "You need to sign into iCloud to use this app.", message: nil)
                @unknown default:
                    rootView.presentSimpleAlertWith(title: "iCloud servers are not reachable at the moment.", message: nil)
                }
                
            }
        }
    }
    
}

