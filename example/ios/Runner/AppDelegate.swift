//
//  AppDelegate.swift
//  SDKExample
//
//  Created by Ahmed Mohamed on 20/07/2026.
//

import Flutter
import UIKit
import ModdakirNativeSDK
import ModdakirCalls

@main
class AppDelegate: FlutterAppDelegate, FlutterPluginRegistrant {
    
    
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Register Flutter plugins for FlutterViewControllers created from the storyboard.
        pluginRegistrant = self

        // Start network monitoring so NetworkReachability.shared.isConnected is always accurate.
        NetworkReachability.shared.startMonitoring()

        observeAppLifecycleNotifications()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - FlutterPluginRegistrant

    func register(with registry: FlutterPluginRegistry) {
        GeneratedPluginRegistrant.register(with: registry)
    }

    
    // MARK: UISceneSession Lifecycle
    
    override func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // MARK: - Background / Foreground Lifecycle
    // Forward to SDKManager so the SDK can keep audio alive in background.
    // Notifications are used because the app adopts UIScene, in which case UIKit
    // does not call the UIApplicationDelegate lifecycle methods.

    private func observeAppLifecycleNotifications() {
        let center = NotificationCenter.default

        center.addObserver(
            self,
            selector: #selector(handleDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        center.addObserver(
            self,
            selector: #selector(handleWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )

        center.addObserver(
            self,
            selector: #selector(handleWillTerminate),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }

    @objc private func handleDidEnterBackground() {
        SDKManager.shared.applicationDidEnterBackground()
    }

    @objc private func handleWillEnterForeground() {
        SDKManager.shared.applicationWillEnterForeground()
    }

    @objc private func handleWillTerminate() {
        SDKManager.shared.applicationWillTerminate()
    }
    
}