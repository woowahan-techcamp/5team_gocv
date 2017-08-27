//
//  AppDelegate.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 3..
//  Copyright © 2017년 busride. All rights reserved.
//
import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var user: User?
    var productList : [Product] = []
    let category = ["전체","도시락","김밥","베이커리","라면","식품","스낵","아이스크림","음료"]
    let priceLevelList = ["비싸다","비싼편","적당","싼편","싸다"]
    let flavorLevelList = ["노맛","별로","적당","괜춘","존맛"]
    let quantityLevelList = ["창렬","적음","적당","많음","혜자"]
    let mainColor =  UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(120.0 / 255.0),  blue: CGFloat(0.0 / 255.0), alpha: CGFloat(1.0))
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    func applicationWillTerminate(_ application: UIApplication) {
    }
}
