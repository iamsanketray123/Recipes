//
//  RecipesViewController.swift
//  Recipes
//
//  Created by Sanket  Ray on 27/02/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD

class RecipesViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try self.fetchedResultsController.performFetch()
        }catch{
            print("An error occured while fetching favorite restaurants")
        }
        
        if entityIsEmpty() {
            DispatchQueue.main.async{
                SVProgressHUD.show(withStatus: "Downloading...")
                SVProgressHUD.setDefaultMaskType(.gradient)
                
                getRecipes { (name, imageURL, calories) in
                    getImageData(url: imageURL, completion: { (data) in
                        self.saveToDatabase(name: name, data: data, calories: calories)
                        SVProgressHUD.dismiss()
                    })
                }
            }
        }
        
    }
    
    func entityIsEmpty()-> Bool {
        let request = NSFetchRequest<Recipe>(entityName : "Recipe")
        do {
            let count = try managedContext.count(for: request)
            return count == 0
        } catch {
            print("Error:",error.localizedDescription)
            return true
        }
    }
    
    
    func saveToDatabase(name: String, data: Data, calories: Int) {
        DispatchQueue.main.async{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: managedContext)!
            let recipe = NSManagedObject(entity: entity, insertInto: managedContext) as! Recipe
            
            recipe.name = name
            recipe.calories = Int32(calories)
            recipe.imageData = data
            
            do{
                try managedContext.save()
            }catch{
                print("Error saving")
            }
        }
    }
    
    
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<Recipe> in
        let fetchRequest = NSFetchRequest<Recipe>(entityName : "Recipe")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    
}



extension RecipesViewController : NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let insertIndexPath = newIndexPath{
                self.table.insertRows(at: [insertIndexPath], with: .fade)
            }
        case .delete:
            if let deleteIndexpath = indexPath{
                self.table.deleteRows(at: [deleteIndexpath], with: .fade)
            }
        case .move:
            if let deleteIndexPath = indexPath {
                self.table.deleteRows(at: [deleteIndexPath], with: .fade)
            }
            if let insertIndexPath = newIndexPath {
                self.table.insertRows(at: [insertIndexPath], with: .fade)
            }
        default:
            print()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            let sectionIndexSet = NSIndexSet(index: sectionIndex)
            self.table.insertSections(sectionIndexSet as IndexSet, with: .fade)
        case .delete:
            let sectionIndexSet = NSIndexSet(index: sectionIndex)
            self.table.deleteSections(sectionIndexSet as IndexSet, with: .fade)
        default:
            print("Nothing")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.table.numberOfRows(inSection: 0)
    }
}

extension RecipesViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            let indexPath = IndexPath(item: 0, section: 0)
            self.table.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
        
        do {
            try self.fetchedResultsController.performFetch()
            table.reloadData()
        }catch {
            print("Error:",error.localizedDescription)
        }
        
        if searchText.count == 0 {
            fetchedResultsController.fetchRequest.predicate = nil
            do {
                try self.fetchedResultsController.performFetch()
                table.reloadData()
            }catch {
                print("Error:",error.localizedDescription)
            }
        }
    }
}




