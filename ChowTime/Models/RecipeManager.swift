//
//  RecipeManager.swift
//  ChowTime
//
//  Created by Jason Zheng on 4/29/21.
//

import Foundation

protocol RecipeManagerDelegate {
    func didReceivedRecipe(_ recipe: RecipeData)
}

struct RecipeManager {
    var delegate: RecipeManagerDelegate?
    let recipeSearch = "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(Keys.SPOON_KEY)&minCalories=0"
    let recipeInstruction = "https://api.spoonacular.com/recipes/{id}/analyzedInstructions"
    
    func fetchRecipeBySearch(search: String, number: Int, offset: Int) {
        fetchRecipe(parameter: "query", value: search, number: number, offset: offset)
        
    }
    
    func fetchRecipe(parameter: String, value: String, number: Int, offset: Int){
        var urlString = "\(recipeSearch)&\(parameter)=\(value.split(separator: " ").joined(separator: "+"))"
        urlString += "&number=\(number)&offset=\(offset)"
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in if error != nil {
                print(error!)
                } else {
                if let urlContent = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(RecipeData.self, from: urlContent)
                        self.delegate?.didReceivedRecipe(decodedData)
                    }
                    catch let DecodingError.dataCorrupted(context) {
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
                }
            }
        task.resume()
        }
    }
    
    func fetch() {
        // Create URL
        let url = URL(string: recipeSearch)
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error.localizedDescription)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            
        }
        task.resume()
    }
    
    func parseJSON(_ recipeData: Data) {
        
    }
}
