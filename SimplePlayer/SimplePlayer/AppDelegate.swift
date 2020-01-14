//
//  AppDelegate.swift
//  SimplePlayer
//
//  Created by Александр on 03.01.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit
import AVKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        prepareAudioSession()
        let playerController = preparePlayerController()
        prepareWindow(with: playerController)
        disableSnapKitContstraitErrorMessages()
        
        return true
    }
    
    private func prepareAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.interruptSpokenAudioAndMixWithOthers, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    private func preparePlayerController() -> PlayerManager {
        
        let audioPlayer = AudioPlayer()
        let playlist = Playlist()
        let playerController = PlayerManager(player: audioPlayer, for: playlist)
        
        return playerController
        
    }
    
    private func prepareWindow(with playerController: PlayerManager) {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: MainViewController(viewModel: playerController))
        window?.makeKeyAndVisible()
        
    }
    
    private func disableSnapKitContstraitErrorMessages() {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }


}

