//
//  CalendarFBArray.swift
//  FBLog
//
//  Created by HIroki Taniguti on 2016/11/04.
//  Copyright © 2016年 HIroki Taniguti. All rights reserved.
//

import UIKit

final class CalendarFBArray {
    private init() {
    }
    static let sharedSingleton = CalendarFBArray()

    var FBMonthDic = [String: [String]]()
    var FBWeekDic = [String: [String]]()
    var FBOneDayArray = [String]()
}
