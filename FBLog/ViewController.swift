//
//  ViewController.swift
//  FBLog
//
//  Created by HIroki Taniguti on 2016/11/03.
//  Copyright © 2016年 HIroki Taniguti. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftDate
import SwiftyJSON

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapSecondButton(sender: AnyObject) {
        var parseError : NSError?
        let parms = ["fields" : "message,full_picture,created_time,id", "limit" : "3000"]
        let graphRequest = FBSDKGraphRequest(graphPath: "me/posts", parameters: parms )
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            guard let response = result else {
                print("No response received")
                if let error = error {
                    print("errorInfo:", error.localizedDescription)
                }
                return }
            print("response", response)
            print("connection", connection)
            let json = JSON(response)
            let data = json["data"]
            for (key,subJson):(String, JSON) in data {
                print("key, subJson", key, subJson)
                if let message = subJson["message"].string{
                }
                if let created_time = subJson["created_time"].string{
                    let monthDic = self.convertMonthDic(created_time)
                    self.setFBMonthDic(monthDic)
                    let fbMonthDic = CalendarFBArray.sharedSingleton.FBMonthDic
                    print("ここが大切fbMonthDic", fbMonthDic)
                }
            }
        })
        let compFbMonthDic = CalendarFBArray.sharedSingleton.FBMonthDic
        print("完成compFbMonthDic", compFbMonthDic)
    }

    //dayString ex)
    //"created_time" : "2016-10-20T09:47:26+0000"
    //2016-10-20T09:47:26+0000 -> [20161020&f, 2016/10]
    //createdTime、dayString(GMT0)、convertedKey、convertedObject（GMT9, localTime）
    func convertMonthDic(dayString: String) -> [String : String]{
        print("dayString", dayString)
        let date = dayString.toDate(DateFormat.Custom("yyyy-MM-dd'T'HH:mm:ssZ"))!
        let convertedObject = date.toString(DateFormat.Custom("yyyyMMdd"))! + "&f"
        let convertedKey = date.toString(DateFormat.Custom("yyyy/MM"))!
        let convertedArray = [convertedKey : convertedObject]
        return convertedArray
    }

    func setFBMonthDic(keyDic: [String : String]){
        let monthKey = keyDic.keys.first!
        let monthValue = keyDic.values.first!
        if CalendarFBArray.sharedSingleton.FBMonthDic[monthKey]?.isEmpty == false { //keyがあるか？ value = [String]のはず
            //keyがあった時
            if (CalendarFBArray.sharedSingleton.FBMonthDic[monthKey]! as [String]).last != monthValue { //valuesの中の最後が追加するStringと同じか？
                //Stringが違う時
                let newValues = CalendarFBArray.sharedSingleton.FBMonthDic[monthKey]! as [String] + [monthValue]
                print("oldValues : ", CalendarFBArray.sharedSingleton.FBMonthDic[monthKey]! as [String])
                print("newValues : ", newValues)
                print("前の tweetedDayDic", CalendarFBArray.sharedSingleton.FBMonthDic[monthKey])
                CalendarFBArray.sharedSingleton.FBMonthDic.updateValue(newValues, forKey: monthKey)
                print("後の tweetedDayDic", CalendarFBArray.sharedSingleton.FBMonthDic[monthKey])
                print("後の tweetedDayDic All ver", CalendarFBArray.sharedSingleton.FBMonthDic)
            }else {
                //Stringが同じ時
                print("もうこのValuesは追加されている")
            }
        } else {
            //keyがなかった時
            CalendarFBArray.sharedSingleton.FBMonthDic.updateValue([monthValue], forKey: monthKey)
        }
    }


    @IBAction func tapGetFBData(sender: AnyObject) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(["public_profile", "email", "user_friends","user_posts"], fromViewController: self) { (result, error) in
            if (error != nil) {
                // エラーが発生した場合
                print("Process error")
            } else if result.isCancelled {
                // ログインをキャンセルした場合
                print("Cancelled")
            } else {
                // その他
                print("Login Succeeded")
                print("resulr", result)
                print("result.grantedPermissions", result.grantedPermissions)
                print("result.declinedPermissions", result.declinedPermissions)
                loginManager.logInWithPublishPermissions(["publish_actions"], fromViewController: self, handler: { (result, error) in
                    if (error != nil) {
                        // エラーが発生した場合
                        print("Process error")
                    } else if result.isCancelled {
                        // ログインをキャンセルした場合
                        print("Cancelled")
                    }else {

                        let token = FBSDKAccessToken.currentAccessToken()
                        let fbLinkDic = ["uerID" : token.userID, "token" : token.tokenString, "expirationDate" : token.expirationDate]

                        print("認証成功!!!")
                        print("resultどなるううううう", result)
                    }
                })
            }
        }
    }

}





//    func tapFBTestButton(sender: AnyObject) {
//        //        let params = ["message": post]
//        //        let friendGraphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/feed", parameters: ["fields": "messe", "limit": "100"], )
//        //        let testGraphRequest = FBSDKGraphRequest(graphPath: "me/posts", parameters: ["fields": "id, name"])
//
//        let parms = ["fields" : "message,full_picture,created_time,id", "limit" : "3000"]
//        let graphRequest = FBSDKGraphRequest(graphPath: "me/posts", parameters: parms )
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            guard let response = result else {
//                print("No response received")
//                if let error = error {
//                    print("errorInfo:", error.localizedDescription)
//                }
//                return }
//            print("response", response)
//            print("connection", connection)
//        })
//    }
//
//    func tabFBTestSecondButton(sender: AnyObject) {
//        //        NCMBFacebookUtils.linkUser(NCMBUser.currentUser(), withReadPermission: ["public_profile", "email", "user_friends"]) { (user, error) in
//        //            if let error = error {
//        //                print("error:can't get public_profile permission", error.localizedDescription)
//        //            }else{
//        //                NCMBFacebookUtils.linkUser(user, withPublishingPermission: ["user_posts"]) { (user, error) in
//        //                    if let error = error {
//        //                        print("error:can't get user_posts permission", error.localizedDescription)
//        //                    }else {
//        //                        print("GET!!! user_posts permissin")
//        //                    }
//        //                }
//        //            }
//        //        }
//
//        func test() {
//        NCMBFacebookUtils.linkUser(NCMBUser.currentUser(), withReadPermission: ["user_posts"]) { (user, error) in
//            if let error = error {
//                print("error:can't get public_profile permission", error.localizedDescription)
//            }else{
//                print("GET!!! user_posts permissin")
//                //                NCMBFacebookUtils.linkUser(user, withPublishingPermission: ["user_posts"]) { (user, error) in
//                //                    if let error = error {
//                //                        print("error:can't get user_posts permission", error.localizedDescription)
//                //                    }else {/Users/gucchi/Desktop/original_app/FBLog/FBLog/Info.plist
//                //                        print("GET!!! user_posts permissin")
//                //                    }
//                //                }
//            }
//        }
//    }
//
//}

