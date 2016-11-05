//
//  FBDetileViewController.swift
//  FBLog
//
//  Created by HIroki Taniguti on 2016/11/04.
//  Copyright © 2016年 HIroki Taniguti. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftDate
import SDWebImage


class FBDetileViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!

    var json : JSON?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        if let json = json {

            print("選択したjson", json)

            if let created_time = json["created_time"].string{
                print("created_time : ", created_time)
                timeLabel.text = created_time
            }
            if let message = json["message"].string{
                print("message : ", message)
                postTextView.text = message
                postTextView.textColor = UIColor.pinkColor()
            }else {
                //            cell.contentView.backgroundColor = UIColor.greenColor()
                postTextView.text = "No Text"
                postTextView.textColor = UIColor.pinkColor()
            }
            if let imageURL = json["full_picture"].URL {
                print("imageURL : ",imageURL)
                postImageView.setImageWithURL(imageURL)
            }else {
                postImageView.backgroundColor = UIColor.pinkColor()
            }
            if let linkUrl = json["link"].URL {
                print("linkUrl : ", linkUrl)
                linkButton.titleLabel?.text = String(linkUrl)
            }else {
                linkButton.titleLabel?.text = ""
            }
        }
    }


    @IBAction func tapLinkButton(sender: AnyObject) {
        if let url = json!["link"].URL {
            if UIApplication.sharedApplication().canOpenURL(url){
                UIApplication.sharedApplication().openURL(url)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
