//
//  RecipeCell.swift
//  Recipes
//
//  Created by Sanket  Ray on 27/02/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var name: UITextView!
    @IBOutlet weak var calories: UILabel!

    
    func highlightText(recipe: Recipe, searchText: String){
        
        guard let recipeName = recipe.name else { return }
        let initialNameText = recipeName
        let nameAttributedText = NSMutableAttributedString(string: initialNameText)
        let rangeName = (initialNameText as NSString).range(of: searchText, options: .caseInsensitive)
        nameAttributedText.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.yellow, range: rangeName)
        name.attributedText = nameAttributedText
        
    }


}
