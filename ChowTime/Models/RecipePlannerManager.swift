//
//  RecipePlannerManager.swift
//  ChowTime
//
//  Created by Jason Zheng on 6/27/21.
//

import Foundation
import Parse

protocol PlannerDelegate {
    func didReceivedUserData(_ data: ConnectUserData)
    func didReceivedMealData(_ data: DailyMealPlanData?,_ update: Bool)
    func didReceivedGeneratorData(_ data: GeneratorData)
    func didUpdatedPlanner()
}

struct RecipePlannerManager {
    var delegate: PlannerDelegate?
    let user = PFUser.current()
    
    func connectUser(name: String, email: String) {
        let url = URL(string: "https://api.spoonacular.com/users/connect?apiKey=\(Keys.SPOON_KEY)")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "name": name,
            "email": email
        ]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: parameters,
            options: []
        )
        request.httpBody = bodyData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error!)
            } else {
                if let safeData = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(ConnectUserData.self, from: safeData)
                        self.delegate?.didReceivedUserData(decodedData)
                    } catch {
                        print("error: ", error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func getTodayMealPlan(update: Bool) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        getMealPlanByDay(date: today, updateNutrOnly: update)
    }
    
    func getMealPlanByDay(date: String, updateNutrOnly: Bool) {
        if let url = URL(string: "https://api.spoonacular.com/mealplanner/\(user!["spoonacularUsername"]!)/day/\(date)?apiKey=\(Keys.SPOON_KEY)&hash=\(user!["spoonacularHash"]!)") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 400 {
                            self.delegate?.didReceivedMealData(nil, updateNutrOnly)
                            print(httpResponse)
                        } else if httpResponse.statusCode == 200{
                            if let safeData = data {
                                do {
                                    let decoder = JSONDecoder()
                                    let decodedData = try decoder.decode(DailyMealPlanData.self, from: safeData)
                                    self.delegate?.didReceivedMealData(decodedData, updateNutrOnly)
                                } catch let DecodingError.dataCorrupted(context) {
                                    print(context)
                                } catch let DecodingError.keyNotFound(key, context) {
                                    print("Key '\(key)' not found:", context.debugDescription)
                                    print("codingPath:", context.codingPath)
                                } catch let DecodingError.valueNotFound(value, context) {
                                    print("Value '\(value)' not found:", context.debugDescription)
                                    print("codingPath:", context.codingPath)
                                } catch let DecodingError.typeMismatch(type, context)  {
                                    print("Type '\(type)' mismatch:", context.debugDescription)
                                    print("codingPath:", context.codingPath)
                                } catch {
                                    print("error: ", error)
                                }
                            }
                        } else {
                            if let safeData = data {
                                print(String(data: safeData, encoding: .utf8)!)
                            }
                            print("error")
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func generateMealPlan(tFrame: String, target: Int) {
        if let url = URL(string: "https://api.spoonacular.com/mealplanner/generate?apiKey=\(Keys.SPOON_KEY)&timeFrame=\(tFrame)&targetCalories=\(target)") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                } else {
                    if let safeData = data {
                        do {
                            let decoder = JSONDecoder()
                            let decodedData = try decoder.decode(GeneratorData.self, from: safeData)
                            self.delegate?.didReceivedGeneratorData(decodedData)
                        } catch {
                            print("error: ", error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func addToMealPlan(date: String, type: String, meal: [String: Any]) {
        let url = URL(string: "https://api.spoonacular.com/mealplanner/\(user!["spoonacularUsername"]!)/items?apiKey=\(Keys.SPOON_KEY)&hash=\(user!["spoonacularHash"]!)")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        print(url)
        print(date)
        print(type)
        print(meal)
        let parameters: [String: Any] = [
            "date": date,
            "position": 0,
            "slot": 1,
            "type": type,
            "value": meal
        ]
        let bodyData = try? JSONSerialization.data(
            withJSONObject: parameters,
            options: []
        )
        request.httpBody = bodyData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error!)
            } else {
                if let safeData = data {
                    print("JSON String: \(String(data: safeData, encoding: .utf8))")
                }
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                    if httpResponse.statusCode == 200 {
                        self.delegate?.didUpdatedPlanner()
                    }
                }
            }
        }
        task.resume()
    }
    
    func deleteFromPlanner(id: String) {
        let url = URL(string: "https://api.spoonacular.com/mealplanner/\(user!["spoonacularUsername"]!)/items/\(id)?hash=\(user!["spoonacularHash"]!)&apiKey=\(Keys.SPOON_KEY)")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error!)
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                    if httpResponse.statusCode == 200 {
                        self.delegate?.didUpdatedPlanner()
                    }
                }
            }
        }
        task.resume()
    }
}
