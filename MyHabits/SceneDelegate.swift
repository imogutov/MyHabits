import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let infoImage = UIImage(systemName: "info.circle.fill")
    let habitsImage = UIImage(systemName: "rectangle.grid.1x2.fill")
    
    let habitsViewController = HabitsViewController()
    
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        func createHabitsViewController() -> UINavigationController {
            let habitsVC = HabitsViewController()
            habitsVC.title = "habits"
            habitsVC.tabBarItem = UITabBarItem(title: "Привычки", image: habitsImage, tag: 0)
            return UINavigationController(rootViewController: habitsVC)
        }
        
        func createInfoViewController() -> UINavigationController {
            let infoVC = InfoViewController()
            infoVC.title = "Информация"
            infoVC.tabBarItem = UITabBarItem(title: "Информация", image: infoImage, tag: 1)
            return UINavigationController(rootViewController: infoVC)
        }
        
        func createTabBarController() -> UITabBarController {
            let tabBarController = UITabBarController()
            UITabBar.appearance().backgroundColor = .systemGray6
            UITabBar.appearance().tintColor = Colors.purple
            tabBarController.viewControllers = [createHabitsViewController(), createInfoViewController()]
            return tabBarController
        }
        
        window.rootViewController = createTabBarController()
        window.makeKeyAndVisible()
        
        self.window = window
    }
}


