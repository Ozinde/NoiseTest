//
//  TestViewController.swift
//  NoiseTest
//
//  Created by Oneh Zinde on 2025/01/27.
//

import UIKit
import AVFoundation

class TestViewController: UIViewController {
    
    var noiseLevel = 5
    var players: [URL: AVAudioPlayer] = [:]
    var duplicatePlayers: [AVAudioPlayer] = []
    var numberSet = Set<Int>()
    var currentRound = 1
    var seconds = 3
    var myTimer: Timer?
    
    /// Outlets
    @IBOutlet weak var numberInputField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var roundLabel: UILabel!
    
    /// Actions
    @IBAction func submitTapped(_ sender: UIButton) {
        submit()
    }
    
    @IBAction func exitTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberInputField.delegate = self

        randomDigits(numberOfRandoms: 3, minNum: 1, maxNum: 9)
        startCountdown()
    }
    
    func startCountdown() {
            myTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                self?.seconds -= 1
                if self?.seconds == 0 {
                    print("Go!")
                    self?.playTest()
                    timer.invalidate()
                } else if let seconds = self?.seconds {
                    print(seconds)
                }
            }
        }
    
    func playTest() {
        var numbers = [String]()
        for i in numberSet {
            numbers.append(String(i))
        }
        
        playNoise(fileName: noiseLevel)
        playSounds(soundFileNames: numbers, withDelay: 3)
    }
    
    func playNoise(fileName: Int) {
        
        let noise = String(fileName)
        guard let url = Bundle.main.url(forResource: "noise_\(noise)", withExtension: "m4a") else {
            print("path not found")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            players[url] = player
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSound(soundFileName: String) {

        guard let bundle = Bundle.main.path(forResource: soundFileName, ofType: "m4a") else { return }
        let soundFileNameURL = URL(fileURLWithPath: bundle)

        if let player = players[soundFileNameURL] { //player for sound has been found

            if !player.isPlaying { //player is not in use, so use that one
                player.prepareToPlay()
                player.play()
            } else { // player is in use, create a new, duplicate, player and use that instead

                do {
                    let duplicatePlayer = try AVAudioPlayer(contentsOf: soundFileNameURL)

                    duplicatePlayer.delegate = self
                    //assign delegate for duplicatePlayer so delegate can remove the duplicate once it's stopped playing

                    duplicatePlayers.append(duplicatePlayer)
                    //add duplicate to array so it doesn't get removed from memory before finishing

                    duplicatePlayer.prepareToPlay()
                    duplicatePlayer.play()
                } catch let error {
                    print(error.localizedDescription)
                }

            }
        } else { //player has not been found, create a new player with the URL if possible
            do {
                let player = try AVAudioPlayer(contentsOf: soundFileNameURL)
                players[soundFileNameURL] = player
                player.prepareToPlay()
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    func playSounds(soundFileNames: [String], withDelay: Double) { //withDelay is in seconds
        for (index, soundFileName) in soundFileNames.enumerated() {
            let delay = withDelay * Double(index)
            let _ = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(playSoundNotification(_:)), userInfo: ["fileName": soundFileName], repeats: false)
        }
    }

    @objc func playSoundNotification(_ notification: NSNotification) {
        if let soundFileName = notification.userInfo?["fileName"] as? String {
            playSound(soundFileName: soundFileName)
        }
    }
    
    func randomDigits(numberOfRandoms: Int, minNum: Int, maxNum: Int) {
        
        while numberSet.count < numberOfRandoms {
            numberSet.insert(Int(arc4random_uniform(UInt32(maxNum))) + minNum)
            print("Numberset: \(numberSet)")
        }
        
    }
    
    func submit() {
        
        guard let text = numberInputField.text, text.count > 2 else {
            print("momo")
            return
        }
        
        if currentRound < 11 {
            seconds = 2
            textCheck()
        } else {
            print("All done")
        }
        
    }
    
    func textCheck() {
        var inputSet = [Int]()
        guard let text = numberInputField.text else {
            print("B")
            return
        }
        
        let numbers = Array(text)
        
        for i in numbers {
            if let num = Int(String(i)) {
                inputSet.append(num)
            }
            
            print("nums: \(inputSet.count)")
            
        }
        
        if Set(inputSet) == numberSet {
            print("yay")
            noiseLevel += 1
        } else {
            print("boo")
            noiseLevel -= 1
        }
        
        newTest()
        
    }
    
    func newTest() {
        numberInputField.text = ""
        currentRound += 1
        
        roundLabel.text = "Round \(currentRound)"
        
        numberSet.removeAll()
        randomDigits(numberOfRandoms: 3, minNum: 1, maxNum: 9)
        
        print("current: \(currentRound)")
        print("noise: \(noiseLevel)")
        startCountdown()
    }
    
    deinit {
        // ViewController going away.  Kill the timer.
        myTimer?.invalidate()
    }
    
}

extension TestViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let index = duplicatePlayers.firstIndex(of: player) {
            duplicatePlayers.remove(at: index)
        }
    }
}

extension TestViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        let textLength = text.count + string.count - range.length
        if textLength > 3 {
            return false
        }
        
        
        if string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil {
            return true
        } else {
            return false
        }
    }
}
