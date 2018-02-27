//
//  RecipeNetworkCall.swift
//  Recipes
//
//  Created by Sanket  Ray on 26/02/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let managedContext = appDelegate.persistentContainer.viewContext

func getRecipes(completion: @escaping (_ name: String, _ imageURL : String, _ calories: Int)->Void) {
    
    let url = URLRequest(url: URL(string: "https://api.edamam.com/search?q=asian&app_id=6cac5a73&app_key=b13dcfd693fa50a2714b9df2f5f0fd2b&from=0&to=15&calories=gte%20591,%20lte%20722&health=alcohol-free")!)
    
    let session = URLSession.shared
    let task = session.dataTask(with: url) { (data, response, error) in
        guard error == nil else{
            print("error while requesting data",error?.localizedDescription ?? "")
            return
        }
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            print("status code was other than 2xx", (response as? HTTPURLResponse)?.statusCode  ?? "","🥚")
            return
        }
        guard let data = data else {
            print("request for data failed")
            return
        }
        let parsedResult : [String:AnyObject]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        }catch {
            print("error parsing data")
            return
        }
        guard let hits = parsedResult["hits"] as? [AnyObject] else {
            print("Failed to get hits")
            return
        }
        //        iterate over all the recipes
        for recipes in hits {
            guard let recipe = recipes["recipe"] as? [String: AnyObject] else {
                print("Could not get recipe")
                return
            }
            guard let imageURL = recipe["image"] as? String else {
                print("Could not get image URL")
                return
            }
            guard let name = recipe["label"] as? String else {
                print("Could not get recipe name")
                return
            }
            guard let calories = recipe["calories"] as? Double else {
                print("Unable to get calorific value")
                return
            }
            
            print(name)
            completion(name, imageURL, Int(calories))
        }
    }
    task.resume()
    
}

func getImageData(url: String, completion: @escaping (_ data: Data)->Void) {
    
    let url = NSURLRequest(url: URL(string: url)!)
    let session = URLSession.shared
    let task = session.dataTask(with: url as URLRequest) { (data, response, error) in
        guard error == nil else{
            print("error while requesting data")
            return
        }
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            print("response other than 2xx")
            return
        }
        guard let data = data else {
            print("error getting data")
            return
        }
        print("got data from URL")
        completion(data)
        
    }
    task.resume()
}








