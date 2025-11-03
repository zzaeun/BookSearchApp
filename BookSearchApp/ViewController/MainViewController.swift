import UIKit
import SnapKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.backgroundColor = .systemGray6
        addVC()
    }
    
    private func addVC() {
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.title = "검색"
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass.fill"))
        
        let containBookVC = UINavigationController(rootViewController: ContainBookViewController())
        containBookVC.title = "담은 책 리스트"
        containBookVC.tabBarItem = UITabBarItem(title: "담은 책 리스트", image: UIImage(systemName: "books.vertical"), selectedImage: UIImage(systemName: "books.vertical.fill"))
        
        self.viewControllers = [searchVC, containBookVC]
    }
}
