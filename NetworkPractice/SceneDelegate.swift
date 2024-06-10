//
//  SceneDelegate.swift
//  NetworkPractice
//
//  Created by 김정윤 on 6/5/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // SceneDelegate의 프로퍼티에 설정
        window = UIWindow(windowScene: windowScene)
        let lottoView = LottoViewController()
        let movieView = MovieViewController()
        let weatherView = WeatherViewController()
        let trendView = TrendViewController()
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .systemBackground
        tabBarController.setViewControllers([lottoView, movieView, weatherView, trendView], animated: true)
        if let items = tabBarController.tabBar.items {
            items[0].selectedImage = UIImage(systemName: "number.circle.fill")
            items[0].image = UIImage(systemName: "number.circle")
            
            items[1].selectedImage = UIImage(systemName: "fpopcorn.circle.fill")
            items[1].image = UIImage(systemName: "popcorn.circle")
            
            items[2].selectedImage = UIImage(systemName: "cloud.rainbow.half.fill")
            items[2].image = UIImage(systemName: "cloud.rainbow.half")
            
            items[3].selectedImage = UIImage(systemName: "star.fill")
            items[3].image = UIImage(systemName: "star")
        }
        
        // 처음 보여질 화면(=탭바)을 root로 설정하고 보여주기
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

