//
//  MainStoryboardViewController.swift
//  SideslipDemo
//
//  Created by Crazy on 16/12/29.
//  Copyright © 2016年 Crazy. All rights reserved.
//

import UIKit

public protocol MainStoryboardViewController {
  
  static func instanceFromStoryboard<T>() -> T
}
