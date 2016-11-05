//
//  DeviseSize.swift
//  FBLog
//
//  Created by HIroki Taniguti on 2016/11/03.
//  Copyright © 2016年 HIroki Taniguti. All rights reserved.
//

import UIKit

struct DeviseSize {

    //CGRectを取得
    static func bounds()->CGRect{
        return UIScreen.mainScreen().bounds;
    }

    //画面の横サイズを取得
    static func screenWidth()->Int{
        return Int( UIScreen.mainScreen().bounds.size.width);
    }

    //画面の縦サイズを取得
    static func screenHeight()->Int{
        return Int(UIScreen.mainScreen().bounds.size.height);
    }
}