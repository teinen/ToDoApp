//
//  ViewController.swift
//  ToDoApp
//
//  Created by teinen on 2018/02/25.
//  Copyright © 2018年 teinen. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    @IBOutlet weak var taskListView: UITableView!
    
    var tasks:[Task] = []
    var tasksToShow:[String] = []
    
    private let segueEditTaskViewController = "SegueEditTaskViewController"
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Navigation Bar Color
        // self.navigationController!.navigationBar.barTintColor = UIColor.cyan
        
        // Set data source and delegate
        taskListView.dataSource = self
        taskListView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch Data from CoreData
        self.fetchData()
        
        // Reload list view
        taskListView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.taskListView.setEditing(editing, animated: animated)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Return if destination is wrong
        guard let destinationViewController = segue.destination as? AddTaskViewController else {
            return
        }
        
        // Pass context to destinationViewController
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        destinationViewController.context = context
        
        if segue.identifier == segueEditTaskViewController {
            // Get inde path
            let indexPath = taskListView.indexPathForSelectedRow
            
            // Get task name to be edited
            let editedName = tasksToShow[(indexPath?.row)!]
            
            // Create fetch request
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name = %@", editedName)
            
            // Try to get data from CoreData
            do {
                let task = try context.fetch(fetchRequest)
                destinationViewController.task = task[0]
            } catch {
                print("Fetch Failed.")
            }
        }
    }
    
    // Close add ToDo view when tap cancel button
    @IBAction func unwindWhewnTapCancel(segue: UIStoryboardSegue) {
        
    }
    
    // Close Add/Modify ToDo view when tap save button
    @IBAction func unwindWhenTapSave(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddTaskViewController, let task = sourceViewController.task {
            
            if let selectedIndexPath = taskListView.indexPathForSelectedRow {
                // Update an existing task.
                tasks[selectedIndexPath.row] = task
                taskListView.reloadRows(at: [selectedIndexPath], with: .none)

            } else {
                // Add a new task.
                let newIndexPath = IndexPath(row: tasks.count, section: 0)
                
                tasks.append(task)
                tasksToShow.append(task.name!)
                
                taskListView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }

    // MARK: Table View Fucntion
    // Get Table Cell count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // Create Table Cell Data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = taskListView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as? TaskTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        cell.taskLable.text = "\(tasksToShow[indexPath.row])"

        return cell
    }
    
    // Delete Task Data
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Only if Editing Style is 'Delete'
        if editingStyle == .delete {
            // get item name to delete
            let deleteName = tasksToShow[indexPath.row]
            
            // create fecth request to delete target item
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format:"name = %@", deleteName)
            
            // Delete data
            do {
                let task = try context.fetch(fetchRequest)
                context.delete(task[0])
            } catch {
                print("Fetching Failed.")
            }
            
            // Save data after delete target data
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            // Fetch all data
            fetchData()
        }
        
        // Reload taskTableView
        taskListView.reloadData()
    }
    
    // MARK: CoreData function
    func fetchData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            // create fetch request
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            
            tasks = try context.fetch(fetchRequest)
            
            // Reset tasks info
            tasksToShow = []
            
            // Add task name to show in list view
            for task in tasks {
                tasksToShow.append(task.name!)
            }

        } catch {
            print("Data fetching was failed.")
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

