//
//  LeftMenuViewController.swift
//  SideslipDemo
//
//  Created by Crazy on 16/12/29.
//  Copyright © 2016年 Crazy. All rights reserved.
//

import UIKit

// 侧滑菜单 ViewController

// @since 1.0.0
// @author 赵林洋
class LeftMenuViewController: UIViewController, MainStoryboardViewController {

  // MARK: - IBOutlet
  
  @IBOutlet weak var menuTableView: UITableView!
  
  @IBOutlet weak var avatarImageView: UIImageView!
  
  @IBOutlet weak var heightLayoutConstraintOfMenuTableView: NSLayoutConstraint!
  
  // MARK: - Property
  
  fileprivate var _titleDatas = ["开通会员", "QQ钱包", "网上营业厅", "个性装扮", "我的收藏", "我的相册", "我的文件"]
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    _setupApperance()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  static func instanceFromStoryboard<T>() -> T {
    let vc = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "LeftMenuViewController")
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

extension LeftMenuViewController {
  
  fileprivate func _setupApperance() {
    menuTableView.dataSource = self
    menuTableView.delegate = self
    menuTableView.tableFooterView = UIView(frame: .zero)
    
    heightLayoutConstraintOfMenuTableView.constant = SD_Screen_Height < 500 ? SD_Screen_Height * (568 - 221) / 568 : 347
    view.frame = CGRect(origin: .zero, size: CGSize(width: 320 * 0.78, height: SD_Screen_Height))
  }
  
}

extension LeftMenuViewController: UITableViewDataSource, UITableViewDelegate {
  
//  UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return _titleDatas.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "left_menu_table_cell", for: indexPath)
    cell.backgroundColor = UIColor.clear
    cell.textLabel!.text = _titleDatas[indexPath.row]
    return cell
  }
  
//  UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    // TODO: - 
  }
}
