//
//  TaskListTableViewController.swift
//  Task2
//
//  Created by Nicholas Laughter on 5/19/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController, ButtonTableViewCellDelegate, NSFetchedResultsControllerDelegate {
    
    var task: Task?
    var dueDateValue: NSDate = NSDate()
    var dateTextField: UITextField!
    var nameText: String!
    var notesText: String?
    
    @IBOutlet var datePickerSubview: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TaskController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = TaskController.sharedInstance.fetchedResultsController.sections,
            index = Int(sections[section].name) else { return nil }
        if index == 0 {
            return "Complete"
        } else {
            return "Inomplete"
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TaskController.sharedInstance.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = TaskController.sharedInstance.fetchedResultsController.sections?[section]
        return section!.numberOfObjects ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath) as? ButtonTableViewCell,
                let task = TaskController.sharedInstance.fetchedResultsController.objectAtIndexPath(indexPath) as? Task else { return UITableViewCell() }
        cell.updateWithTask(task)
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            guard let task = TaskController.sharedInstance.fetchedResultsController.objectAtIndexPath(indexPath) as? Task else { return }
            TaskController.sharedInstance.removeTask(task)
        }
    }
    
    func buttonCellButtonTapped(sender: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(sender),
            task = TaskController.sharedInstance.fetchedResultsController.objectAtIndexPath(indexPath) as? Task else {return}
        TaskController.sharedInstance.isIncompleteValueToggle(task)
        sender.updateButton(task.isIncomplete.boolValue)
    }
    
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        self.dateTextField.text = sender.date.stringValue()
        self.dueDateValue = datePickerSubview.date
    }
    
    @IBAction func addTaskButtonTapped(sender: AnyObject) {
        addTaskAlert()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.task = (TaskController.sharedInstance.fetchedResultsController.objectAtIndexPath(indexPath) as! Task)
        self.nameText = task?.name
        self.notesText = task?.notes
        editTaskAlert()
    }
    
    func updateWithTask(task: Task) {
        let name = task.name
        let due = task.due
        let notes = task.notes
        self.nameText = name
        self.dateTextField.text = due?.stringValue()
        self.notesText = notes
    }
    
    func addTaskAlert() {
        let alertController = UIAlertController(title: "Add Task", message: "Add an item to be done", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (nameTextField) in
            nameTextField.placeholder = "Task title"
        }
        alertController.addTextFieldWithConfigurationHandler { (dueTextField) in
            self.dateTextField = dueTextField
            dueTextField.text = self.dueDateValue.stringValue()
            dueTextField.inputView = self.datePickerSubview
        }
        alertController.addTextFieldWithConfigurationHandler { (notesTextField) in
            notesTextField.placeholder = "Notes"
        }
        let addAction = UIAlertAction(title: "Add", style: .Default) { (_) in
            guard let textFields = alertController.textFields,
                taskNameTextFieldText = textFields.first!.text else { return }
            let taskNotesTextFieldText = textFields[2].text
            let due = self.datePickerSubview.date
            TaskController.sharedInstance.addTask(taskNameTextFieldText, notes: taskNotesTextFieldText, due: due)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func editTaskAlert() {
        let alertController = UIAlertController(title: "Edit Task", message: "Edit your task's details", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (nameTextField) in
            nameTextField.text = self.nameText
        }
        alertController.addTextFieldWithConfigurationHandler { (dueTextField) in
            self.self.dateTextField = dueTextField
            dueTextField.inputView = self.datePickerSubview
        }
        alertController.addTextFieldWithConfigurationHandler { (notesTextField) in
            notesTextField.text = self.notesText
        }
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (_) in
            guard let textFields = alertController.textFields,
                taskNameTextFieldText = textFields.first!.text else { return }
            let taskNotesTextFieldtText = textFields[2].text
            self.nameText = taskNameTextFieldText
            self.notesText = taskNotesTextFieldtText
            TaskController.sharedInstance.updateTask(self.task!, name: taskNameTextFieldText, notes: taskNotesTextFieldtText, due: self.dueDateValue, isIncomplete: true)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
        updateWithTask(self.task!)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        case .Insert:
            guard let indexPath = newIndexPath else { return }
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
        case .Move:
            guard let indexPath = indexPath,
                newIndexPath = newIndexPath else { return }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Right)
        case .Update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Left)
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Right)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}