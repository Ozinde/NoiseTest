//
//  ViewController.swift
//  NoiseTest
//
//  Created by Oneh Zinde on 2025/01/27.
//

import UIKit

class ViewController: UIViewController {
    
    /// Actions
    @IBAction func startTapped(_ sender: UIButton) {
        guard let storyboard = storyboard else {
                    return
                }
                
                let vc = storyboard.instantiateViewController(withIdentifier: "TestViewController")
                vc.modalTransitionStyle = .flipHorizontal
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

