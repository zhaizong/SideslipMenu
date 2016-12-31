//
//  MainTabBarController.swift
//  SideslipDemo
//
//  Created by Crazy on 16/12/29.
//  Copyright © 2016年 Crazy. All rights reserved.
//

import UIKit

// 主页 TabBarController

// @since 1.0.0
// @author 赵林洋
class MainTabBarController: UITabBarController {

  // MARK: - Commons
  
  fileprivate let kHomeTabIndex     = 0
//  fileprivate let kContactsTabIndex = 1
  
  // MARK: - Property
  
  fileprivate var _homeViewController: HomeViewController!
//  fileprivate var _contactsController: UIViewController!
  
  /*override var selectedIndex: Int {
    didSet {
      _contactsNavigationViewController.popToRootViewController(animated: true)
    }
  }*/
  
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    switch item.tag {
    case 0:
      UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "ContactsViewController").view.removeFromSuperview()
    default:
      break
    }
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    _setupContentViewControllers()
  }

}

extension MainTabBarController {
  
  fileprivate func _setupContentViewControllers() {
    _homeViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//    _contactsController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "ContactsViewController")
    
    viewControllers = [_homeViewController]
    
    if let homeTabItem = tabBar.items?[kHomeTabIndex] {
      homeTabItem.title = "首页"
      homeTabItem.image = UIImage(named: "Home_unselected")?.withRenderingMode(.alwaysOriginal)
      homeTabItem.selectedImage = UIImage(named: "Home_selected")?.withRenderingMode(.alwaysOriginal)
    }
    /*
    if let contactsTabItem = tabBar.items?[kContactsTabIndex] {
      contactsTabItem.title = "通讯录"
      contactsTabItem.image = UIImage(named: "icon_star_p")?.withRenderingMode(.alwaysOriginal)
    }
    */
  }
  
}
