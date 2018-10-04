//
//  SocialSignInVCProtocol.swift
//  GoogleFacebookSignIn
//
//  Created by 0x384c0 on 10/4/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//
import UIKit
import GoogleSignIn
import Google
import FBSDKLoginKit

//MARK: Model
struct User{
    let
    name:String,
    email:String,
    imageURL:String?
}

//MARK: VC Protocol
protocol SocialSignInVCProtocol:class {
    func requestGIDSignin()
    func requestFBSignin()
    func didSignin(user: User)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}
extension SocialSignInVCProtocol where Self:UIViewController{
    func requestGIDSignin(){
        GIDSigninHelper.shared.signIn(vc: self)
    }
    func requestFBSignin(){
        FBSigninHelper.shared.signIn(vc: self)
    }
}

//MARK: Helpers
protocol SocialSignInHelperProtocol {
    static var shared:SocialSignInHelperProtocol{get}
    func signIn(vc:SocialSignInVCProtocol)
    func signout()
    
    func canOpen(url:URL) -> Bool
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
}
class FBSigninHelper:SocialSignInHelperProtocol{
    static let shared:SocialSignInHelperProtocol = FBSigninHelper()
    func signIn(vc:SocialSignInVCProtocol){
        self.vc = vc
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email", "public_profile"], from: vc as? UIViewController) { (result, error) in
            if error != nil{
                print("error start graph request")
                return
            }
            self.getFBUserInfo()
        }
    }
    func signout() {
        FBSDKLoginManager().logOut()
    }
    func canOpen(url: URL) -> Bool {
        return url.absoluteString.hasPrefix("fb")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool{
        return FBSDKApplicationDelegate
            .sharedInstance()!
            .application(app,
                         open: url,
                         sourceApplication: (options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String),
                         annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    private weak var vc:SocialSignInVCProtocol?
    private func getFBUserInfo(){
        FBSDKGraphRequest.init(
            graphPath: "/me",
            parameters: ["fields": "id, name, email, picture.type(large)"])?
            .start(completionHandler: {[unowned self] (connection, result, err) -> Void in
                if err != nil{
                    print("error start graph request")
                    return
                }
                
                if let result = result as? Dictionary<String,Any>,
                    let email = result["email"],
                    let name  = result["name"],
                    let imageURL = ((result["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                    
                    
                    let user = User(
                        name: name as! String,
                        email: email  as! String,
                        imageURL: imageURL
                    )
                    self.vc?.didSignin(user: user)
                }
            })
    }
}
class GIDSigninHelper:NSObject,SocialSignInHelperProtocol,GIDSignInDelegate,GIDSignInUIDelegate{
    static let shared:SocialSignInHelperProtocol = GIDSigninHelper()
    
    func signIn(vc:SocialSignInVCProtocol){
        self.vc = vc
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    func signout() {
        GIDSignIn.sharedInstance().signOut()
    }
    func canOpen(url: URL) -> Bool {
        return url.absoluteString.contains("com.googleusercontent.apps")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        var error: NSError?
        GGLContext.sharedInstance()?.configureWithError(&error)
        if let error = error{ print(error) }
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool{
        return GIDSignIn
            .sharedInstance()
            .handle(url as URL?,
                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                    annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    private weak var vc:SocialSignInVCProtocol?
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let fullName = user.profile.name
            let email = user.profile.email
            let imageProfile = user.profile.imageURL(withDimension: 400)
            
            let user = User(
                name: fullName ?? "noname",
                email: email ?? "NoMail",
                imageURL: imageProfile?.absoluteString
            )
            vc?.didSignin(user: user)
        } else {
            print("\(String(describing: error))")
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("DISCONNECTED")
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        vc?.present(viewController, animated: true, completion: nil)
    }
}
