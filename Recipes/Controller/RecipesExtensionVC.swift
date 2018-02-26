//
//  RecipesExtensionVC.swift
//  Recipes
//
//  Created by Sanket  Ray on 27/02/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit

extension RecipesViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RecipeCell
        let recipe = fetchedResultsController.object(at: indexPath)
        
        cell.recipeImage.image = UIImage(data: recipe.imageData!)
        cell.recipeImage.layer.cornerRadius = 4
        cell.recipeImage.clipsToBounds = true
        cell.name.text = recipe.name
        cell.calories.text = "\(recipe.calories) Calories"
        
        if let searchText = searchBar.text {
            cell.highlightText(recipe: recipe, searchText: searchText)
        }
        cell.name.textColor = UIColor(red: 0, green: 84/255, blue: 147/255, alpha: 1)
        cell.name.font = UIFont.systemFont(ofSize: 16)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let recipe = fetchedResultsController.object(at: indexPath)
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction: UIContextualAction, sourceView: UIView, completion: (Bool)-> Void) in
            
            managedContext.delete(recipe)
            completion(true)
            
            do {
                try managedContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        delete.image = #imageLiteral(resourceName: "cross")
        
        let configuration =  UISwipeActionsConfiguration(actions: [delete])
        return configuration

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}

