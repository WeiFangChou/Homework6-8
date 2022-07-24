//
//  ViewController.swift
//  Homework6-8
//
//  Created by WeiFangChou on 2022/7/24.
//

import UIKit
import AVFoundation

class SpeakHistroy{
    var speakText: String
    var speakRate: Float
    var speakSpeed: Float
    init(speakText: String, speakRate: Float, speakSpeed: Float) {
        self.speakText = speakText
        self.speakRate = speakRate
        self.speakSpeed = speakSpeed
    }
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    
    
    @IBOutlet weak var speakTextfield: UITextField!
    

    @IBOutlet weak var speakSpeed: UISlider!
    @IBOutlet weak var speakRate: UISlider!
    @IBOutlet weak var speakHistoryTableView: UITableView!
    
    @IBOutlet weak var speakPlayButton: UIButton!
    var speakHistroy : [SpeakHistroy] = [SpeakHistroy(speakText: "Hello World", speakRate: 1.0, speakSpeed: 1.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        speakRate.minimumValue = 0.5
        speakRate.maximumValue = 2.0
        speakRate.value = 1.0
        // [0.5 - 2] Default = 1
        speakSpeed.minimumValue = 0.0
        speakSpeed.maximumValue = 1.0
        speakSpeed.value = 1.0
        // [0-1] Default = 1
        self.speakHistoryTableView.delegate = self
        self.speakHistoryTableView.dataSource = self
    }

    
    func speakFromText(speakStr:String) -> Bool{
        if(!speakStr.isEmpty){
            let speakUtterance = AVSpeechUtterance(string: speakStr)
            speakUtterance.pitchMultiplier = speakRate.value
            speakUtterance.rate = speakRate.value
            speakUtterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
            let speakSynthesizer = AVSpeechSynthesizer()
            speakSynthesizer.speak(speakUtterance)
            return true
        }
        return false
        
    }
    @IBAction func speak(_ sender: UIButton) {
        
        if let speakText = speakTextfield.text, !speakText.isEmpty{
            if(speakFromText(speakStr: speakText)){
                speakPlayButton.setTitle("暫停", for: .normal)
            }
            let  speak = SpeakHistroy(speakText: speakText, speakRate: speakRate.value, speakSpeed: speakSpeed.value)
            speakHistroy.append(speak)
            speakHistoryTableView.reloadData()
            speakPlayButton.setTitle("播放", for:  .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  speakHistroy.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = speakHistoryTableView.dequeueReusableCell(withIdentifier: "speakHistroyCell", for: indexPath) as? SpeakTableViewCell else {
           return UITableViewCell()
        }
        cell.speakText.text = speakHistroy[indexPath.row].speakText
        cell.speakRate.text = "\(speakHistroy[indexPath.row].speakRate)"
        cell.speakSpeed.text = "\(speakHistroy[indexPath.row].speakSpeed)"
        print("init cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let speak = speakHistroy[indexPath.row]
        speakTextfield.text = speak.speakText
        speakRate.value = speak.speakRate
        speakSpeed.value = speak.speakSpeed
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            speakHistroy.remove(at: indexPath.row)
            speakHistoryTableView.reloadData()
        }
    }
    
}

