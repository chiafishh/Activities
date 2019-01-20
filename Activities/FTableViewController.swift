//
//  FTableViewController.swift
//  Activities
//
//  Created by User23 on 2019/1/11.
//  Copyright © 2019 Chiafishh. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class FTableViewController: UITableViewController {

    var acts =  [Act1]()
    var showInfos = [ShowInfo0]()
    var audioPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let urlStr = "https://cloud.culture.tw/frontsite/trans/SearchShowAction.do?method=doFindIssueTypeJ".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr) {
                 let task = URLSession.shared.dataTask(with: url) { (data, response , error) in
                     let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                     if let data1 = data, let act0 = try? decoder.decode(Act0.self, from: data1) {
                         self.acts = act0.issue
                         print(self.acts)
                         DispatchQueue.main.async {
                            self.tableView.reloadData()
                         }
                     }
                 }
                 task.resume()
             }
        
        //播放音樂：
        //1.設定
        let url = Bundle.main.url(forResource: "piano", withExtension: "mp3")
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer.prepareToPlay()
        }catch{
            print("Error:", error.localizedDescription)
        }
        //2.無限循環播放
        audioPlayer.numberOfLoops = -1
        //3.播放音量：(最小~最大 = 0.0~1.0) 此音樂作為背景音樂，要小聲一點，才不會把朗讀藝文活動詳細資訊的聲音蓋過去
        audioPlayer.volume = 0.5
        //4.播放
        audioPlayer.play()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("count", acts.count )
        return acts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "act0Cell", for: indexPath) as! Act0TableViewCell
        
        // Configure the cell...
        let act1 = acts[indexPath.row]
        cell.titleLabel.text = act1.title
        
        let task = URLSession.shared.dataTask(with: act1.imageUrl) { (data, response , error) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.actImg.image = UIImage(data: data)
                }
            }
        }
        task.resume()
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let controller = segue.destination as? DetailViewController
        if let row = tableView.indexPathForSelectedRow?.row {
            let act1 = acts[row]
            controller?.act1 = act1
        }
    }

}
