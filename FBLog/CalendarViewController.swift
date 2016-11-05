//
//  CalendarViewController.swift
//  FBLog
//
//  Created by HIroki Taniguti on 2016/11/03.
//  Copyright © 2016年 HIroki Taniguti. All rights reserved.
//
//CALayerクラスのインポート
import UIKit
import QuartzCore
import SwiftDate
import SwiftyJSON
import FBSDKCoreKit
import SDWebImage

class CalendarViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //メンバ変数の設定（配列格納用）
    var count: Int!
    var mArray: NSMutableArray!

    //メンバ変数の設定（カレンダー用）
    var now: NSDate!
    var year: Int!
    var month: Int!
    var day: Int!
    var maxDay: Int!
    var dayOfWeek: Int!

    //メンバ変数の設定（カレンダー関数から取得したものを渡す）
    var comps: NSDateComponents!

    //メンバ変数の設定（カレンダーの背景色）
    var calendarBackGroundColor: UIColor!

    //プロパティを指定
    @IBOutlet var calendarBar: UILabel!
    @IBOutlet weak var calendarDayTitleLabel: UILabel!
    @IBOutlet var prevMonthButton: UIButton!
    @IBOutlet var nextMonthButton: UIButton!

    //カレンダーの位置決め用メンバ変数
    var calendarLabelIntervalX: Int!
    var calendarLabelX: Int!
    var calendarLabelY: Int!
    var calendarLabelWidth: Int!
    var calendarLabelHeight: Int!
    var calendarLableFontSize: Int!

    var buttonRadius: Float!

    var calendarIntervalX: Int!
    var calendarX: Int!
    var calendarIntervalY: Int!
    var calendarY: Int!
    var calendarSize: Int!
    var calendarFontSize: Int!

    var collectionViewFrame: CGRect?
    var collectionView: UICollectionView!

    var jsonObject : JSON?
    var selectedJson : JSON?

    override func viewDidLoad() {

        super.viewDidLoad()

        //        let VC = ViewController()
        //        VC.getAllPic()

        //現在起動中のデバイスを取得（スクリーンの幅・高さ）
        let screenWidth  = DeviseSize.screenWidth()
        let screenHeight = DeviseSize.screenHeight()

        //IBで設置されてるボタンの色をカスタマイズ
        calendarBar.backgroundColor = ColorManager.sharedSingleton.mainColor()
        prevMonthButton.backgroundColor = ColorManager.sharedSingleton.mainColor()
        nextMonthButton.backgroundColor = ColorManager.sharedSingleton.mainColor()
        calendarDayTitleLabel.textColor = ColorManager.sharedSingleton.mainColor()

        //iPhone4s
        if (screenWidth == 320 && screenHeight == 480) {

            calendarLabelIntervalX = 5;
            calendarLabelX         = 45;
            //            calendarLabelY         = 93;
            calendarLabelY         = 108;
            calendarLabelWidth     = 40;
            calendarLabelHeight    = 25;
            calendarLableFontSize  = 14;

            buttonRadius           = 20.0;

            calendarIntervalX      = 5;
            calendarX              = 45;
            //            calendarIntervalY      = 120;
            calendarIntervalY      = 135;
            calendarY              = 45;
            calendarSize           = 40;
            calendarFontSize       = 17;
            collectionViewFrame = CGRectMake(0, 388, CGFloat(screenWidth), CGFloat(screenHeight) - (388 + CGFloat(calendarSize)))

            //iPhone5またはiPhone5s
        } else if (screenWidth == 320 && screenHeight == 568) {

            calendarLabelIntervalX = 5;
            calendarLabelX         = 45;
            //            calendarLabelY         = 93;
            calendarLabelY         = 108;
            calendarLabelWidth     = 40;
            calendarLabelHeight    = 25;
            calendarLableFontSize  = 14;

            buttonRadius           = 20.0;

            calendarIntervalX      = 5;
            calendarX              = 45;
            //            calendarIntervalY      = 120;
            calendarIntervalY      = 135;
            calendarY              = 45;
            calendarSize           = 40;
            calendarFontSize       = 17;
            collectionViewFrame = CGRectMake(0, 388, CGFloat(screenWidth), CGFloat(screenHeight) - (388 + CGFloat(calendarSize)))

            //iPhone6
        } else if (screenWidth == 375 && screenHeight == 667) {

            calendarLabelIntervalX = 15;
            calendarLabelX         = 50;
            //            calendarLabelY         = 95;
            calendarLabelY         = 110;
            calendarLabelWidth     = 45;
            calendarLabelHeight    = 25;
            calendarLableFontSize  = 16;

            buttonRadius           = 20;

            calendarIntervalX      = 15;
            calendarX              = 50;
            //            calendarIntervalY      = 125;
            calendarIntervalY      = 140;
            calendarY              = 50;
            calendarSize           = 45;
            calendarFontSize       = 19;
            collectionViewFrame = CGRectMake(0, 438, CGFloat(screenWidth), CGFloat(screenHeight) - (438 + CGFloat(calendarSize)))

            //iPhone6 plus
        } else if (screenWidth == 414 && screenHeight == 736) {

            calendarLabelIntervalX = 15;
            calendarLabelX         = 55;
            //            calendarLabelY         = 95;
            calendarLabelY         = 110;
            calendarLabelWidth     = 55;
            calendarLabelHeight    = 25;
            calendarLableFontSize  = 18;

            buttonRadius           = 20;

            calendarIntervalX      = 18;
            calendarX              = 55;
            //            calendarIntervalY      = 125;
            calendarIntervalY      = 140;
            calendarY              = 55;
            calendarSize           = 50;
            calendarFontSize       = 21;
            collectionViewFrame = CGRectMake(0, 468, CGFloat(screenWidth), CGFloat(screenHeight) - (468 + CGFloat(calendarSize)))
        }

        // レイアウト作成
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumInteritemSpacing = 5.0
        flowLayout.minimumLineSpacing = 5.0
        flowLayout.itemSize = CGSizeMake(collectionViewFrame!.width / 2, collectionViewFrame!.height)

        // コレクションビュー作成
        collectionView = UICollectionView(frame: collectionViewFrame!, collectionViewLayout: flowLayout)
        //        collectionView.backgroundColor = ColorManager.sharedSingleton.mainColor()
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView!.delegate = self
        collectionView!.dataSource = self
        view.addSubview(collectionView!)

        //ボタンを角丸にする
        prevMonthButton.layer.cornerRadius = CGFloat(buttonRadius)
        nextMonthButton.layer.cornerRadius = CGFloat(buttonRadius)

        //現在の日付を取得する
        now = NSDate()

        //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let range: NSRange = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit:NSCalendarUnit.Month, forDate:now)

        //最初にメンバ変数に格納するための現在日付の情報を取得する
        comps = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Weekday],fromDate:now)

        //年月日と最後の日付と曜日を取得(NSIntegerをintへのキャスト不要)
        let orgYear: NSInteger      = comps.year
        let orgMonth: NSInteger     = comps.month
        let orgDay: NSInteger       = comps.day
        let orgDayOfWeek: NSInteger = comps.weekday
        let max: NSInteger          = range.length

        year      = orgYear
        month     = orgMonth
        day       = orgDay
        dayOfWeek = orgDayOfWeek
        maxDay    = max

        //空の配列を作成する（カレンダーデータの格納用）
        mArray = NSMutableArray()

        //曜日ラベル初期定義
        let monthName:[String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]

        //曜日ラベルを動的に配置
        setupCalendarLabel(monthName)

        //初期表示時のカレンダーをセットアップする
        setupCurrentCalendar()

        //最初は今日はを選択した状態
        todaySelect()
    }

    //曜日ラベルの動的配置関数
    func setupCalendarLabel(array: NSArray) {

        let calendarLabelCount = 7

        for i in 0...6 {

            //ラベルを作成
            let calendarBaseLabel: UILabel = UILabel()

            //X座標の値をCGFloat型へ変換して設定
            calendarBaseLabel.frame = CGRectMake(
                CGFloat(calendarLabelIntervalX + calendarLabelX * (i % calendarLabelCount)),
                CGFloat(calendarLabelY),
                CGFloat(calendarLabelWidth),
                CGFloat(calendarLabelHeight)
            )

            //日曜日の場合は赤色を指定
            if (i == 0) {

                //RGBカラーの設定は小数値をCGFloat型にしてあげる
                calendarBaseLabel.textColor = UIColor(
                    red: CGFloat(0.831), green: CGFloat(0.349), blue: CGFloat(0.224), alpha: CGFloat(1.0)
                )

                //土曜日の場合は青色を指定
            } else if(i == 6) {

                //RGBカラーの設定は小数値をCGFloat型にしてあげる
                calendarBaseLabel.textColor = UIColor(
                    red: CGFloat(0.400), green: CGFloat(0.471), blue: CGFloat(0.980), alpha: CGFloat(1.0)
                )

                //平日の場合は灰色を指定
            } else {

                //既に用意されている配色パターンの場合
                calendarBaseLabel.textColor = UIColor.lightGrayColor()

            }

            //曜日ラベルの配置
            calendarBaseLabel.text = String(array[i] as! NSString)
            calendarBaseLabel.textAlignment = NSTextAlignment.Center
            calendarBaseLabel.font = UIFont(name: "System", size: CGFloat(calendarLableFontSize))
            self.view.addSubview(calendarBaseLabel)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetail" {
            let fbDetileVC = segue.destinationViewController as! FBDetileViewController
            //            postDetailVC.hidesBottomBarWhenPushed = true // trueならtabBar隠す
            fbDetileVC.json = self.selectedJson
        }
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let count = PicDataArray.sharedSingleton.PicOneDayAssetArray.count
        var count = 0
        if let jsonObject = jsonObject{
            count = jsonObject.count
        }
        print("collectionViewのcount : ", count)
        return count
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        selectedJson = jsonObject![indexPath.row]
        performSegueWithIdentifier("toDetail", sender: nil)
//
//        let asset: PHAsset = PicDataArray.sharedSingleton.PicOneDayAssetArray[indexPath.row]
//        let imageView = UIImageView()
//        imageView.backgroundColor = UIColor.purpleColor()
//        let manager: PHImageManager = PHImageManager()
//        manager.requestImageDataForAsset(asset, options: nil) { (data, title, orientation, dic) in
//            let image = UIImage(data: data!)
//            self.tapPostImage(image!)
//        }

        
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        collectionView.backgroundColor = UIColor.grayColor()

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        cell.backgroundColor = UIColor.purpleColor()

        let messageLabel = UILabel(frame: CGRectMake(0, 0, 300, 300))
        let imageView = UIImageView()

        let data = jsonObject![indexPath.row]
        if let imageURL = data["full_picture"].URL {
            print("indexPath.row, imageURL : ", indexPath.row, imageURL)
            imageView.setImageWithURL(imageURL)
            cell.backgroundView = imageView
            messageLabel.text = ""
        }else {
            cell.backgroundView = nil
            if let message = data["message"].string{
                print("indexPath.row, message : ", indexPath.row, message)
                messageLabel.text = "Exist Text"

                messageLabel.layer.position = cell.layer.position
                messageLabel.textAlignment = NSTextAlignment.Center
                messageLabel.textColor = UIColor.pinkColor()
                cell.addSubview(messageLabel)
//                cell.backgroundView!.addSubview(messageLabel)
            }else {
                messageLabel.text = "No Text"
                messageLabel.layer.position = cell.layer.position
                messageLabel.textAlignment = NSTextAlignment.Center
                messageLabel.sizeThatFits(cell.frame.size)
                messageLabel.textColor = UIColor.pinkColor()
                cell.addSubview(messageLabel)
//                cell.backgroundView!.addSubview(messageLabel)
            }
        }
        return cell
    }

    //投稿写真タップ
    func tapPostImage(image : UIImage) {
        print("tapPostImage")
    }

    //カレンダーを生成する関数
    func generateCalendar() {

        let viewID = String(format: "%04d", year) + "/" + String(format: "%02d", month)

        var FBValues = [String]()
        let FBData = CalendarFBArray.sharedSingleton.FBMonthDic
        print("viewID : ", viewID)
        if let values = FBData[viewID] {
            FBValues = values
            print("FBValues", FBValues)
        }

        //タグナンバーとトータルカウントの定義
        var tagNumber = 1
        let total     = 42

        //祝祭日のメソッドを定義した祝祭日判定フラグ
        let holidayObject = CalculateCalendarLogic()
        var holidayFlag: Bool = false

        //7×6=42個のボタン要素を作る
        for i in 0...41{

            //配置場所の定義
            let positionX   = calendarIntervalX + calendarX * (i % 7)
            let positionY   = calendarIntervalY + calendarY * (i / 7)
            let buttonSizeX = calendarSize;
            let buttonSizeY = calendarSize;

            //ボタンをつくる
            let button: UIButton = UIButton()
            button.frame = CGRectMake(
                CGFloat(positionX),
                CGFloat(positionY),
                CGFloat(buttonSizeX),
                CGFloat(buttonSizeY)
            );

            //ボタンの初期設定をする
            if (i < dayOfWeek - 1) {

                //日付の入らない部分はボタンを押せなくする
                button.setTitle("", forState: .Normal)
                button.enabled = false
                holidayFlag = false

            } else if (i == dayOfWeek - 1 || i < dayOfWeek + maxDay - 1) {

                //日付の入る部分はボタンのタグを設定する（日にち）
                button.setTitle(String(tagNumber), forState: .Normal)
                let FBTag = String(format: "%04d", year) + String(format: "%02d", month) + String(format: "%02d", tagNumber) + "&f"
                print("i ,FBTag :", i , FBTag)
                print("FBValues" , FBValues)
                if FBValues.indexOf(FBTag) != nil {
                    print("この日は写真あるぜ:", FBTag)
                    button.setTitleColor(ColorManager.sharedSingleton.mainColor(), forState: .Normal)
                }else {
                    button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                }

                //祝祭日の判定を行う
                holidayFlag = holidayObject.judgeJapaneseHoliday(year, month: month, day: tagNumber)

                button.tag = tagNumber
                tagNumber += 1

            } else if (i == dayOfWeek + maxDay - 1 || i < total) {

                //日付の入らない部分はボタンを押せなくする
                button.setTitle("", forState: .Normal)
                button.enabled = false
                holidayFlag = false
            }

            //ボタンの配色の設定
            //日曜日または祝祭日(振替休日) => 赤色, 土曜日 => 青色, 平日 => グレー色
            //@remark:このサンプルでは正円のボタンを作っていますが、背景画像の設定等も可能です。
            if (i % 7 == 0 || holidayFlag == true) {
                calendarBackGroundColor = UIColor(
                    red: CGFloat(0.831), green: CGFloat(0.349), blue: CGFloat(0.224), alpha: CGFloat(1.0)
                )
            } else if (i % 7 == 6) {
                calendarBackGroundColor = UIColor(
                    red: CGFloat(0.400), green: CGFloat(0.471), blue: CGFloat(0.980), alpha: CGFloat(1.0)
                )
            } else {
                calendarBackGroundColor = UIColor.lightGrayColor()
            }

            //ボタンのデザインを決定する
            button.backgroundColor = calendarBackGroundColor
            button.titleLabel!.font = UIFont(name: "System", size: CGFloat(calendarFontSize))
            button.layer.cornerRadius = CGFloat(buttonRadius)

            //配置したボタンに押した際のアクションを設定する
            button.addTarget(self, action: #selector(CalendarViewController.buttonTapped(_:)), forControlEvents: .TouchUpInside)

            //ボタンを配置する
            self.view.addSubview(button)
            mArray.addObject(button)
        }

    }

    //タイトル表記(何年何月)を設定する関数
    func setupCalendarTitleLabel() {
        calendarBar.text = String("\(year)/\(month)")
        //        calendarDayTitleLabel.text = String("\(year)/\(month)/\(day)")
    }

    //サブタイトル表記(何年何月)を設定する関数
    func updateCalendarTitleLabel(title: String){
        calendarBar.text = title
        let count = jsonObject?.count
        if count > 0{
            calendarDayTitleLabel.text = title + "!  \(count)件発見!!😜"
        }else {
            calendarDayTitleLabel.text = title + "!  なかったようだ😭"
        }
    }

    //現在（初期表示時）の年月に該当するデータを取得する関数
    func setupCurrentCalendarData() {

        /*************
         * (重要ポイント)
         * 現在月の1日のdayOfWeek(曜日の値)を使ってカレンダーの始まる位置を決めるので、
         * yyyy年mm月1日のデータを作成する。
         * 後述の関数 setupPrevCalendarData, setupNextCalendarData も同様です。
         *************/
        let currentCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let currentComps: NSDateComponents = NSDateComponents()

        currentComps.year  = year
        currentComps.month = month
        currentComps.day   = 1

        let currentDate: NSDate = currentCalendar.dateFromComponents(currentComps)!
        recreateCalendarParameter(currentCalendar, currentDate: currentDate)
    }

    //前の年月に該当するデータを取得する関数
    func setupPrevCalendarData() {

        //現在の月に対して-1をする
        if (month == 0) {
            year = year - 1;
            month = 12;
        } else {
            month = month - 1;
        }

        //setupCurrentCalendarData()と同様の処理を行う
        let prevCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let prevComps: NSDateComponents = NSDateComponents()

        prevComps.year  = year
        prevComps.month = month
        prevComps.day   = 1

        let prevDate: NSDate = prevCalendar.dateFromComponents(prevComps)!
        recreateCalendarParameter(prevCalendar, currentDate: prevDate)
    }

    //次の年月に該当するデータを取得する関数
    func setupNextCalendarData() {

        //現在の月に対して+1をする
        if (month == 12) {
            year = year + 1;
            month = 1;
        } else {
            month = month + 1;
        }

        //setupCurrentCalendarData()と同様の処理を行う
        let nextCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let nextComps: NSDateComponents = NSDateComponents()

        nextComps.year  = year
        nextComps.month = month
        nextComps.day   = 1

        let nextDate: NSDate = nextCalendar.dateFromComponents(nextComps)!
        recreateCalendarParameter(nextCalendar, currentDate: nextDate)
    }

    //カレンダーのパラメータを再作成する関数
    func recreateCalendarParameter(currentCalendar: NSCalendar, currentDate: NSDate) {

        //引数で渡されたものをもとに日付の情報を取得する
        let currentRange: NSRange = currentCalendar.rangeOfUnit(NSCalendarUnit.Day, inUnit:NSCalendarUnit.Month, forDate:currentDate)

        comps = currentCalendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Weekday],fromDate:currentDate)

        //年月日と最後の日付と曜日を取得(NSIntegerをintへのキャスト不要)
        let currentYear: NSInteger      = comps.year
        let currentMonth: NSInteger     = comps.month
        let currentDay: NSInteger       = comps.day
        let currentDayOfWeek: NSInteger = comps.weekday
        let currentMax: NSInteger       = currentRange.length

        year      = currentYear
        month     = currentMonth
        day       = currentDay
        dayOfWeek = currentDayOfWeek
        maxDay    = currentMax
    }

    //表示されているボタンオブジェクトを一旦削除する関数
    func removeCalendarButtonObject() {

        //ビューからボタンオブジェクトを削除する
        for i in 0..<mArray.count {
            mArray[i].removeFromSuperview()
        }

        //配列に格納したボタンオブジェクトも削除する
        mArray.removeAllObjects()
    }

    //現在のカレンダーをセットアップする関数
    func setupCurrentCalendar() {

        setupCurrentCalendarData()
        generateCalendar()
        setupCalendarTitleLabel()
    }

    //カレンダーボタンをタップした時のアクション
    func buttonTapped(button: UIButton) {

        //@todo:画面遷移等の処理を書くことができます。
        let selectDateString = String(format: "%04d", year) + String(format: "%02d", month) + String(format: "%02d", button.tag)
        let date = selectDateString.toDate(.Custom("yyyyMMdd"))
//        let getFBData = getSelectDayFBData()
//        getFBData.getSelectDayFBData(date!)
        getOneDayFBData(date!)
        //コンソール表示
        print("\(year)年\(month)月\(button.tag)日が選択されました！")
        let titleString = String(month) + "月" + String(button.tag) + "日"
        updateCalendarTitleLabel(titleString)
    }

    func getOneDayFBData(date: NSDate) {
        let getFBData = getSelectDayFBData()
        let sineTime = String(getFBData.convertUnixTimeFromNSDate(getFBData.filterDateStart(date)))
        let untilTime = String(getFBData.convertUnixTimeFromNSDate(getFBData.filterDateEnd(date)))
        let parms = ["fields" : "message,full_picture,created_time,id,link,place,picture", "since" : sineTime, "until" : untilTime]
        
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
            self.jsonObject = json["data"]
            print("self.jsonObject", self.jsonObject)
            self.collectionView.reloadData()

//            for (key,subJson):(String, JSON) in data {
//                print("key, subJson", key, subJson)
//                if let message = subJson["message"].string{
//                    messageArray.append(message)
//                    print("messageArray", messageArray)
//                }
//                if let created_time = subJson["created_time"].string{
//                    let monthDic = self.convertMonthDic(created_time)
//                    self.setFBMonthDic(monthDic)
//                    let fbMonthDic = CalendarFBArray.sharedSingleton.FBMonthDic
//                    print("ここが大切fbMonthDic", fbMonthDic)
//                    timeArray.append(created_time)
//                    print("timeArray", timeArray)
//                }
//            }

        })
    }

    func todaySelect() {
////        日本時間にあわせるためひとまずGMT分足してる(応急処置ナウ)
//        let date = NSDate() + 9.hours
//        let day = date.day
//        print("date(今日のはず)", date)
//        let getOneDayPic = GetOneDayPic()
//        getOneDayPic.getOnePicData(date)
//        collectionView.reloadData()
//        let titleString = String(month) + "月" + String(day) + "日"
//        updateCalendarTitleLabel(titleString)
    }

    //前の月のボタンを押した際のアクション
    @IBAction func getPrevMonthData(sender: UIButton) {
        prevCalendarSettings()
    }

    //次の月のボタンを押した際のアクション
    @IBAction func getNextMonthData(sender: UIButton) {
        nextCalendarSettings()
    }

    //左スワイプで前月を表示
    @IBAction func swipePrevCalendar(sender: UISwipeGestureRecognizer) {
        prevCalendarSettings()
    }

    //右スワイプで次月を表示
    @IBAction func swipeNextCalendar(sender: UISwipeGestureRecognizer) {
        nextCalendarSettings()
    }

    //前月を表示するメソッド
    func prevCalendarSettings() {
        removeCalendarButtonObject()
        setupPrevCalendarData()
        generateCalendar()
        setupCalendarTitleLabel()
    }
    
    //次月を表示するメソッド
    func nextCalendarSettings() {
        removeCalendarButtonObject()
        setupNextCalendarData()
        generateCalendar()
        setupCalendarTitleLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func prevGamen(segue: UIStoryboardSegue) {
        //処理無し
    }
}
