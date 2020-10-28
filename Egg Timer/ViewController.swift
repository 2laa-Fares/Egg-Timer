//
//  ViewController.swift
//  Egg Timer
//
//  Created by 2laa Ewis on 10/28/20.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var timer = Timer()
    var totalTime = 0
    var secondsPassed  = 0
    var player: AVAudioPlayer?
    // Time in second which egg takes to mature.
    let eggTimes = ["Soft": 300, "Medium": 480, "Hard": 720]

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        //  To  handle stop time if it pressed before.
        timer.invalidate()
        let hardness = sender.currentTitle!
        totalTime = eggTimes[hardness]!
        
        progressBar.progress = 0.0
        secondsPassed = 0
        titleLabel.text  = hardness
        
        // Set timer to run each second.
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        if(secondsPassed <  totalTime) {
            secondsPassed += 1;
            progressBar.progress = Float(secondsPassed)/Float(totalTime)
        }else{
            timer.invalidate()
            titleLabel.text = "DONE!"
            
            playSound()
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}

