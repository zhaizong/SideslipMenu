//
//  HomeViewController.swift
//  SideslipDemo
//
//  Created by Crazy on 16/12/29.
//  Copyright © 2016年 Crazy. All rights reserved.
//

import UIKit

// 主页 ViewController

// @since 1.0.0
// @author 赵林洋
class HomeViewController: UIViewController, MainStoryboardViewController {
  
  // MARK: - IBOutlet
  
  @IBOutlet var panGesture: UIPanGestureRecognizer!
  

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  static func instanceFromStoryboard<T>() -> T {
    let vc = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "HomeViewController")
    return vc as! T
  }
  
  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
  */

}
