//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by AKIRA KANNO on 2018/02/25.
//  Copyright © 2018年 teinen. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var taskDueDateField: UIDatePicker!
    @IBOutlet weak var taskMemoField: UITextView!

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate
        self.taskNameField.delegate = self
        
        // Set border to some fields
        taskNameField.layer.borderColor = UIColor.gray.cgColor
        taskNameField.layer.borderWidth = 0.5
        
        taskDueDateField.layer.borderColor = UIColor.gray.cgColor
        taskMemoField.layer.borderWidth = 0.5
        
        taskMemoField.layer.borderColor = UIColor.gray.cgColor
        taskMemoField.layer.borderWidth = 0.5
    }

    // MARK: Button Tapped Function
    // Save task action
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Get values
        let taskName = taskNameField.text
        let taskDueDate = taskDueDateField.date
        let taskMemo = taskMemoField.text
        
        // Use context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Define Task Model
        let task = Task(context: context)
        
        // Save input data to DB
        task.name = taskName
        task.dueDate = taskDueDate
        task.memo = taskMemo
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        // Return to list page
        dismiss(animated: true, completion: nil)
    }
    
    // Cancel and back to list view
    @IBAction func cancelButtonTapped(_ sender: Any) {
        // Return to list view
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UI Adjust Function
    // Close keyboard when tap screen
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // Close keyboard when done editting task name field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        taskNameField.text = textField.text
        return true
    }
}
