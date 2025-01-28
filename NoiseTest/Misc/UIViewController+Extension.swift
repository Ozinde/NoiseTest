//
//  UIViewController+Extension.swift
//  NoiseTest
//
//  Created by Fikile Zinde on 2025/01/28.
//

import Foundation
import UIKit
import Network

extension UIViewController {
    
    /// Alert controller displayed when there is an error.
    func showAlert(title:String, message: String) {
            DispatchQueue.main.async {
                let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alertVC.popoverPresentationController?.sourceView = self.view
                // Presentation of the alert
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    
    /// Function that monitors the network
      func monitorNetwork() {
          let monitor = NWPathMonitor()
          monitor.pathUpdateHandler = {
              path in
              if path.status != .satisfied {
                  
                  DispatchQueue.main.async {
                      self.showAlert(title: "Something Went Wrong", message: "Please check your network connection.")
                  }
              } else {
                  print("There is an internet connection")
              }
              
          }
          
          let queue = DispatchQueue(label: "Network")
          monitor.start(queue: queue)
      }
      
      func tapVibe() {
          let generator = UIImpactFeedbackGenerator(style: .heavy)
          generator.impactOccurred()
      }
}
