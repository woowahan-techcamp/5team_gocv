//
//  AppDelegate.swift
//  pyunrihae
//
//  Created by woowabrothers on 2017. 8. 3..
//  Copyright © 2017년 busride. All rights reserved.
//
import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate{
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
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
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
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("\(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                return
            }
            // User is signed in
            // ...
            
            let user_instance = User.init(id: (user?.uid)!, email: (user?.email)!, nickname: (user?.displayName)!)
            DataManager.saveUser(user: user_instance)
            NotificationCenter.default.post(name: NSNotification.Name("userLogined"), object: nil)
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        
        //disconnect 됐으면 signout
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
