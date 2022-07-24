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

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AVSpeechSynthesizerDelegate{

    
    
    @IBOutlet weak var speakTextfield: UITextField!
    

    @IBOutlet weak var speakSpeed: UISlider!
    @IBOutlet weak var speakRate: UISlider!
    @IBOutlet weak var speakHistoryTableView: UITableView!
    
    @IBOutlet weak var speakPlayButton: UIButton!
    var speakUtterance = AVSpeechUtterance()
    
    var speakSynthesizer = AVSpeechSynthesizer()
    var speakHistroy : [SpeakHistroy] = [SpeakHistroy(speakText: "I Love Swift", speakRate: 1.0, speakSpeed: 1.0)]
    
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
        self.speakSynthesizer.delegate = self
    }

    

    @IBAction func speak(_ sender: UIButton) {
        
        
        if(speakSynthesizer.isPaused){
            speakSynthesizer.continueSpeaking()
            
        }else if(speakSynthesizer.isSpeaking){
            speakSynthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
            
        }else{
            if let speakText = speakTextfield.text, !speakText.isEmpty{
                speakUtterance = AVSpeechUtterance(string: speakText)
                speakUtterance.pitchMultiplier = speakRate.value
                speakUtterance.rate = speakRate.value
                speakUtterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
                speakSynthesizer.speak(speakUtterance)
                speakHistroy.insert(SpeakHistroy(speakText: speakText, speakRate: speakRate.value, speakSpeed: speakSpeed.value),at: 0)
                speakHistoryTableView.reloadData()

            }
            
        }
        
        
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.speakPlayButton.setTitle("播放", for: .normal)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.speakPlayButton.setTitle("暫停", for: .normal)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        self.speakPlayButton.setTitle("繼續播放", for: .normal)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        self.speakPlayButton.setTitle("暫停", for: .normal)
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    }
    
}

