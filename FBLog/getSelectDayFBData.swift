//
//  getSelectDayFBData.swift
//  FBLog
//
//  Created by HIroki Taniguti on 2016/11/04.
//  Copyright © 2016年 HIroki Taniguti. All rights reserved.
//

import UIKit
import SwiftDate
import FBSDKCoreKit
import SwiftyJSON

class getSelectDayFBData: NSObject {

    func getSelectDayFBData(date: NSDate) {
        let sineTime = String(convertUnixTimeFromNSDate(filterDateStart(date)))
        let untilTime = String(convertUnixTimeFromNSDate(filterDateEnd(date)))
        let parms = ["fields" : "message,full_picture,created_time,id", "since" : sineTime, "until" : untilTime,  "limit" : "3000"]
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
            let jsonData = JSON(response)
            
        })
    }


    //選択した日にちの00:00:00のNSDateをゲット（その日のタイムライン絞るのに使用）
    //引数無しの場合currentDateが使われる（LogViewなどから使われる）
    //引数ありの場合（LookBackから使われる）
    func filterDateStart(targetDate: NSDate) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!  // 24時間表示対策
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)

        let formatDate = formatter.dateFromString(String(targetDate.year) + "/" +
            String(targetDate.month) + "/" +
            String(targetDate.day) + " 00:00:00")!

        print("FilterDateStart", formatDate)
        return formatDate
    }

    //選択した日にちの23:59:59のNSDateをゲット（その日のタイムライン絞るのに使用）
    //引数無しの場合currentDateが使われる（LogViewなどから使われる）
    //引数ありの場合（LookBackから使われる）
    func filterDateEnd(targetDate: NSDate) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!  // 24時間表示対策
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)

        let formatDate = formatter.dateFromString(String(targetDate.year) + "/" +
            String(targetDate.month) + "/" +
            String(targetDate.day) + " 23:59:59")!

        print("FilterDateEnd", formatDate)
        return formatDate
    }

    func convertUnixTimeFromNSDate(date: NSDate) -> Int {
        let unixTime = Int(date.timeIntervalSince1970)
        return unixTime
    }
}
