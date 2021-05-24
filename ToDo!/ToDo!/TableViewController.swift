//
//  TableViewController.swift
//  ToDo!
//
//  Created by Martín on 22/5/21.
//

import UIKit
import CoreData


var tasks = [NSManagedObject]()

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            tasks = results as! [NSManagedObject]
        } catch let error as NSError {
            print("No ha sido posible cargar \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = tasks[indexPath.row]
        
        cell.textLabel!.text = task.value(forKey: "name") as? String
        
        return cell
    }
    
    
    // Goal: We'll create a button to create new tasks. We will create an UIAlert to show a mark where we could write the task.
    
    @IBAction func addButton(_ sender: Any) {
        
        addNewTask()
        
        func addNewTask() {
            let alert = UIAlertController(title: "New Task", message: "Create your new task:", preferredStyle: .alert)
            
            let saveButton = UIAlertAction(title: "Save", style: .default) { UIAlertAction in
                
                let textField = alert.textFields!.first
                // MARK:- Aqui puede petar
                saveTask(nameTask: textField!.text!)
                self.tableView.reloadData()
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { UIAlertAction in
            }
            
            alert.addTextField { UITextField in
            }
            
            alert.addAction(saveButton)
            alert.addAction(cancelButton)
            
            present(alert, animated: true, completion: nil)
        }
        
        func saveTask(nameTask: String) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)
            let task = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            task.setValue(nameTask, forKey: "name")
            
            do {
                try managedContext.save()
                tasks.append(task)
            } catch let error as NSError {
                print("No ha sido posible guardar \(error), \(error.userInfo) ")
            }
        }
        
        
    }
    
    
    
    
    
    
    
    
    
}
