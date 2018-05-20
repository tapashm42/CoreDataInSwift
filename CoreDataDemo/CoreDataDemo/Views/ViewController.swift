//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by TapashM on 19/05/18.
//  Copyright © 2018 TapashM. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet private weak var tblView: UITableView!
    
    // MARK: - fetchedResultsController used to catched data
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Employee> = {
        // Create Fetched Results Controller
        let fetchedResultsController = CoreDataManager.getFetchedResultsController(entityName: "Employee", predicate: nil, sortingKey: "empID",context: CoreDataStack.shared.persistentContainer.viewContext)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(CoreDataStack.shared.persistentContainer.persistentStoreDescriptions)
        tblView.register(UINib(nibName: "EmployeeCell", bundle:nil), forCellReuseIdentifier: "EmployeeCell")
        tblView.tableFooterView = UIView()
        tblView.estimatedRowHeight = 44
        tblView.rowHeight = UITableViewAutomaticDimension
    }

    @IBAction func OnBatchUpdateAction(_ sender: Any) {
        CoreDataManager.batchUpdate(entityName: "Employee", context: CoreDataStack.shared.persistentContainer.viewContext)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onBatchUpdateDelete(_ sender: Any) {
        CoreDataManager.batchDelete(entityName: "Employee", context: CoreDataStack.shared.persistentContainer.viewContext)
    }
    
}

extension ViewController: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = self.fetchedResultsController.sections?.count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.fetchedResultsController.sections?[section].numberOfObjects)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell") as! EmployeeCell
        cell.mEmployee  = fetchedResultsController.object(at: indexPath)
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tblView.insertSections(IndexSet(integer: sectionIndex), with: .none)
        case .delete:
            self.tblView.deleteSections(IndexSet(integer: sectionIndex), with: .none)
        case .move:
            break
        case .update:
            break
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tblView.reloadData()
    }
}

