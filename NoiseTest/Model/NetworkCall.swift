//
//  NetworkCall.swift
//  NoiseTest
//
//  Created by Fikile Zinde on 2025/01/28.
//

import Foundation

class NetworkCall {
    
    class func postRequest(score: Int, rounds: Int, difficulty: Int, played: [Int], answered: [Int]) {
        guard let url = URL(string: "https://enoqczf2j2pbadx.m.pipedream.net") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "score": score,
            "rounds": rounds,
            "difficulty": difficulty,
            "triplet_played": played,
            "triplet_answered": answered
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("error occured")
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print("success: \(response)")
            } catch {
                print("error: \(error)")
            }
        }
        
        task.resume()
    }
}
