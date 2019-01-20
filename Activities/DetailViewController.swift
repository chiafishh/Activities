//
//  DetailViewController.swift
//  Activities
//
//  Created by User02 on 2019/1/14.
//  Copyright © 2019 Chiafishh. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {

    var act1: Act1?
    var showInfo0: ShowInfo0?
    var web = "0"
    var speakdetail:String = "0"
    var speaking = 0 //按說話按鈕 按一下變0 再按一下變1
    
    @IBOutlet var actImg2: UIImageView!
    @IBOutlet var actImg3: UIImageView!
    @IBOutlet var titleLabel2: UILabel!

    @IBOutlet var detail: UITextView!
    @IBOutlet var scrollV: UIScrollView!
    
    @IBOutlet var showInfoTime: UILabel!
    @IBOutlet var showInfoLocationTextField: UITextView!
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var BuyTicketButton: UIButton!
    
    @IBOutlet var speak: UIButton!
    
    var speechUtterance = AVSpeechUtterance()
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        speaking = 0
        let noInfo = "無資訊"
        if let act1 = act1{
            navigationItem.title = "詳細資訊"
            titleLabel2.text = act1.title
            
            if act1.showInfo?.count != 0{
                showInfoTime.text = act1.showInfo![0].time!
                showInfoLocationTextField.text = act1.showInfo![0].locationName! + "\n" + act1.showInfo![0].location!
                
                //顯示價格
                if act1.showInfo![0].price! != ""{
                    priceLabel.text = act1.showInfo![0].price
                }
                else{
                    priceLabel.text = "免費"
                }
            }
            else{                
                showInfoTime.text = noInfo
                showInfoLocationTextField.text = noInfo
                priceLabel.text = noInfo
            }
            
            
            
            
            
            detail.text = act1.descriptionFilterHtml
            speakdetail = detail.text//給朗讀詳細內容的功能使用
            
            //若有買票網址，按鈕顯示“我要索票“，顏色呈咖啡色，按鈕可以使用；若無，按鈕顯示“無法索票“，顏色呈灰色，按鈕不可使用
            BuyTicketButton.setTitle("無法索票",for: .normal)
            BuyTicketButton.isEnabled = false
            BuyTicketButton.setTitleColor(UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.0), for: .normal)
            if act1.webSales != ""{
                BuyTicketButton.isEnabled = true
                BuyTicketButton.setTitle("我要索票",for: .normal)
                BuyTicketButton.setTitleColor(UIColor(red:0.55, green:0.33, blue:0.12, alpha:1.0), for: .normal)
                web = act1.webSales!
            }
            
            let task = URLSession.shared.dataTask(with: act1.imageUrl) { (data, response , error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.actImg2.image = UIImage(data: data)//上方小圖
                        self.actImg3.image = UIImage(data: data)//底部大圖
                    }
                }
            }
            task.resume()
        }
    }
 
    //一進來這個view，就顯示scroll bar，讓使用者知道可以往下滑
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.detail.flashScrollIndicators()
        self.scrollV.flashScrollIndicators()
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        synthesizer.stopSpeaking(at: .immediate)//可以點選按鈕請手機朗讀詳細文字，當離開此頁就閉嘴
        print("viewDidDisappear")
    }
    
    //點選“我要索票”按鈕去買票網站
    @IBAction func BuyTicket(_ sender: AnyObject) {
        if let url = URL(string: web) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    //點選說話按鈕請手機朗讀詳細文字，第一次點選會朗讀，再次點選會閉嘴，再次點選會朗讀
    @IBAction func speakPressed(_ sender: Any) {
        speechUtterance = AVSpeechUtterance(string: speakdetail)
        print(speakdetail)
        
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
        synthesizer.speak(speechUtterance)//朗讀
        if speaking == 0
        {
            speaking = 1
            print("speak")
        }
        else
        {
            speaking = 0
            print("stop")
            synthesizer.stopSpeaking(at: .immediate)//閉嘴
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
