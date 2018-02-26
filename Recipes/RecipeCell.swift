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
    
    func highlightText(){
        print("OK.")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
