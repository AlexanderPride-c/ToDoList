//
//  TableViewController.swift
//  ToDoList
//
//  Created by Александр Прайд on 09.09.2020.
//  Copyright © 2020 Alexander Pride. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {

    var tasks: [Task] = []
    
    @IBAction func addNewTask(_ sender: Any) {
        let alertController = UIAlertController(title: "New Task", message: "Add your task!", preferredStyle: .alert)
        
        let saveTask = UIAlertAction(title: "Save", style: .default) { action in
            let tf = alertController.textFields?.first
            if let newTask = tf?.text {
                self.saveTask(withTitle: newTask, withFavorite: false)
                
                self.tableView.reloadData()
            }
            
        }
        
        alertController.addTextField { _ in }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in }
        
        alertController.addAction(saveTask)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func saveTask(withTitle title: String, withFavorite favorite: Bool) {
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        taskObject.favorite = favorite
        
        
        do {
            try context.save()
            tasks.insert(taskObject, at: 0)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func removeAll(_ sender: Any) {
        
    }
    
    // получение контекста
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Your Tasks"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.imageView?.image = UIImage(systemName: "paperclip")
        
        return cell
    }
    

}
