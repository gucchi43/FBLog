//
//  ColorManager.swift
//  FBLog
//
//  Created by HIroki Taniguti on 2016/11/03.
//  Copyright © 2016年 HIroki Taniguti. All rights reserved.
//


import UIKit
import Colours

final class ColorManager {
    private init() {
    }
    static let sharedSingleton = ColorManager()
    //ムラサキ系の色
    func mainColor() -> UIColor {
        return UIColor.init(fromHexString: "8800FF")
        //            return UIColor.init(hexString: "37CD5F", withAlpha: 1.0)
    }
    //ミズイロ系の色
    func accsentColor() -> UIColor {
        return UIColor.init(fromHexString: "00FFD6")
        //        return UIColor.init(hexString: "cd37a5", withAlpha: 1.0)
    }

    //既存のよくあるボタンの水色のやつ
    func defaultButtonColor() -> UIColor { //skyBuleColor
        return UIColor(red: 19/255.0, green:144/255.0, blue:255/255.0, alpha:1.0)

    }

    //緑系のクリーム色（未読のNotificationの色）
    func noReadColor() -> UIColor {
        return UIColor.init(fromHexString: "CFFFDB")
    }
    
}