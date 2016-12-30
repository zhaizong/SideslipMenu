//
//  ViewController.swift
//  SideslipDemo
//
//  Created by Crazy on 16/12/29.
//  Copyright © 2016年 Crazy. All rights reserved.
//

import UIKit

// 主页根控制器

// @since 1.0.0
// @author 赵林洋
class ViewController: UIViewController {

  // MARK: - Property
  
  var mainTabBarController: MainTabBarController!
  
  var tapGesture: UITapGestureRecognizer!
  
  var homeNavigationController: UINavigationController!
  var homeViewController: HomeViewController!
  
  var leftMenuViewController: LeftMenuViewController!
  
  var mainView: UIView! // 构造主视图，实现 UINavigationController.view 和 HomeViewController.view 一起缩放
  
  var blackCover: UIView! // 侧滑菜单黑色半透明遮罩层
  
  // 侧滑所需参数
  fileprivate let _fullDistance: CGFloat = 0.78
  fileprivate let _proportion: CGFloat = 0.77
  fileprivate var _distance: CGFloat = 0
  fileprivate var _centerOfLeftViewAtBeginning: CGPoint!
  fileprivate var _proportionOfLeftView: CGFloat = 1
  fileprivate var _distanceOfLeftView: CGFloat = 50
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    _setupApperance()
  }

}

extension ViewController {
  
  fileprivate func _setupApperance() {
    view.backgroundColor = UIColor.yellow
    
    leftMenuViewController = LeftMenuViewController.instanceFromStoryboard()
//    适配 4.7 和 5.5 寸屏幕的缩放操作，有偶发性小 bug
    if SD_Screen_Width > 320 {
      _proportionOfLeftView = SD_Screen_Width / 320
      _distanceOfLeftView += (SD_Screen_Width - 320) * _fullDistance / 2
    }
    leftMenuViewController.view.center = CGPoint(x: leftMenuViewController.view.center.x - 50,
                                                 y: leftMenuViewController.view.center.y)
    leftMenuViewController.view.transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
    
//    动画参数初始化
    _centerOfLeftViewAtBeginning = leftMenuViewController.view.center
//    把侧滑菜单视图加入根容器
    view.addSubview(leftMenuViewController.view)
//    在侧滑菜单之上增加黑色遮罩层，目的是实现视差特效
    blackCover = UIView(frame: view.frame.offsetBy(dx: 0, dy: 0))
    blackCover.backgroundColor = UIColor.black
    view.addSubview(blackCover)
    
//    初始化主视图，即包含 TabBar、NavigationBar和首页的总视图
    mainView = UIView(frame: view.frame)
    
//    初始化 tabBarController
    mainTabBarController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
    
//    取出 TabBar Controller 的视图加入主视图
    mainView.addSubview(mainTabBarController.view)
    
//    从 StoryBoard 取出首页的 Navigation Controller
    homeNavigationController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "HomeNavigationController") as! UINavigationController
//    从 StoryBoard 初始化而来的 Navigation Controller 会自动初始化他的 Root View Controller，即 HomeViewController
//    将其（指针）取出，赋给容器 View Controller 的成员变量 homeViewController
    homeViewController = homeNavigationController.viewControllers.first as! HomeViewController
    
//    分别将 Navigation Bar 和 homeViewController 的视图加入 TabBar Controller 的视图
    mainTabBarController.view.addSubview(homeViewController.navigationController!.view)
    mainTabBarController.view.addSubview(homeViewController.view)
    
//    在 TabBar Controller 的视图中，将 TabBar 视图提到最表层
    mainTabBarController.view.bringSubview(toFront: mainTabBarController.tabBar)
    
    view.addSubview(mainView)
    
//    分别指定 Navigation Bar 左右两侧按钮的事件
    homeViewController.navigationItem.leftBarButtonItem?.action = #selector(_showLeft)
    homeViewController.navigationItem.rightBarButtonItem?.action = #selector(_showRight)
    
//    给主视图绑定 UIPanGestureRecognizer
    if let panGesture = homeViewController.panGesture {
      panGesture.addTarget(self, action: #selector(_pan(_:)))
      mainView.addGestureRecognizer(panGesture)
    }
    
    tapGesture = UITapGestureRecognizer(target: self, action: #selector(_showHome))
  }
  
}

extension ViewController {
  
  @objc fileprivate func _pan(_ panGesture: UIPanGestureRecognizer) {
    let x = panGesture.translation(in: view).x // The translation of the pan gesture in the coordinate system of the specified view.
    let realtimeDistance = _distance + x // 实时距离
    let realtimeProportion = realtimeDistance / (SD_Screen_Width * _fullDistance) // 实时比例
//    如果 UIPanGestureRecognizer 结束
    if panGesture.state == .ended {
      if realtimeDistance > SD_Screen_Width * (_proportion / 3) {
        _showLeft()
      } else if realtimeDistance < SD_Screen_Width * -(_proportion / 3) {
        _showRight()
      } else {
        _showHome()
      }
      return
    }
    
//    计算缩放比例
    if let touchView = panGesture.view {
      var proportion = CGFloat(touchView.frame.origin.x >= 0 ? -1 : 1)
      proportion *= realtimeDistance / SD_Screen_Width
      proportion *= 1 - _proportion
      proportion /= _fullDistance + _proportion / 2 - 0.5
      proportion += 1
      if proportion <= _proportion { // 若比例已经达到最小，则不再继续动画
        return
      }
//      执行视差特效
      blackCover.alpha = (proportion - _proportion) / (1 - _proportion)
//      执行平移和缩放动画
      panGesture.view!.center = CGPoint(x: view.center.x + realtimeDistance,
                                        y: view.center.y)
      panGesture.view!.transform = CGAffineTransform.identity.scaledBy(x: proportion, y: proportion)
//      左侧菜单动画
      leftMenuViewController.view.center = CGPoint(x: _centerOfLeftViewAtBeginning.x + _distanceOfLeftView * realtimeProportion,
                                                   y: _centerOfLeftViewAtBeginning.y - (_proportionOfLeftView - 1) * leftMenuViewController.view.frame.height * realtimeProportion / 2)
      let leftScaleProportion = 0.8 + (_proportionOfLeftView - 0.8) * realtimeProportion
      leftMenuViewController.view.transform = CGAffineTransform.identity.scaledBy(x: leftScaleProportion,
                                                                                  y: leftScaleProportion)
    }
  }
  
}

extension ViewController {
  
  @objc fileprivate func _showLeft() {
//    给首页 加入 点击自动关闭侧滑菜单功能
    mainView.addGestureRecognizer(tapGesture)
//    计算距离，执行菜单自动滑动动画
    _distance = view.center.x * (_fullDistance * 2 + _proportion - 1)
    _doTheAnimate(_proportion, showWhat: "left")
    homeNavigationController.popToRootViewController(animated: true)
  }
  
  @objc fileprivate func _showRight() {
//    给首页 加入 点击自动关闭侧滑菜单功能
    mainView.addGestureRecognizer(tapGesture)
//    计算距离，执行菜单自动滑动动画
    _distance = view.center.x * -(_fullDistance * 2 + _proportion - 1)
    _doTheAnimate(_proportion, showWhat: "right")
  }
  
  @objc fileprivate func _showHome() {
//    从首页 删除 点击自动关闭侧滑菜单功能
    mainView.removeGestureRecognizer(tapGesture)
//    计算距离，执行菜单自动滑动动画
    _distance = 0
    _doTheAnimate(1, showWhat: "home")
  }
  
//  执行三种动画：显示左侧菜单、显示主页、显示右侧菜单
  fileprivate func _doTheAnimate(_ proportion: CGFloat, showWhat: String) {
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { () -> Void in
//      移动首页中心
      self.mainView.center = CGPoint(x: self.view.center.x + self._distance, y: self.view.center.y)
//      缩放首页
      self.mainView.transform = CGAffineTransform.identity.scaledBy(x: proportion, y: proportion)
      if showWhat == "left" {
//        移动左侧菜单的中心
        self.leftMenuViewController.view.center = CGPoint(x: self._centerOfLeftViewAtBeginning.x + self._distanceOfLeftView,
                                                          y: self.leftMenuViewController.view.center.y)
//        缩放左侧菜单
        self.leftMenuViewController.view.transform = CGAffineTransform.identity.scaledBy(x: self._proportionOfLeftView,
                                                                                         y: self._proportionOfLeftView)
      }
      self.blackCover.alpha = showWhat == "home" ? 1 : 0
      
      self.leftMenuViewController.view.alpha = showWhat == "right" ? 0 : 1
    }, completion: nil)
  }
  
}

