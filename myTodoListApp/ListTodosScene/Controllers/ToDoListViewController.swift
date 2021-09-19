//
//  ToDoListViewController.swift
//  myTodoListApp
//
//  Created by Decagon on 08/09/2021.
//

import UIKit
import CoreData

class ToDoListViewController: UIViewController {
  var selectedcell: ToDoList? = nil
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var list = [ToDoList]()
  var tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    setTableViewDelegate()
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didTapAddButton) )
    
//    tableView.frame = view.bounds
    navigationItem.title = "To do List"
    customizeBarButton()
    getAllItems()
    // Do any additional setup after loading the view.
  }
  
  func configureTableView(){
    view.addSubview(tableView)
    tableView.rowHeight = 100
    tableView.pin(to: view)
    tableView.register(TodoListCell.self, forCellReuseIdentifier: "TodoListCell")
  }
  
  func customizeBarButton() {
    self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.29, green: 0.05, blue: 0.76, alpha: 1.00)
  }
  
  @objc private func didTapAddButton() {
    // Move to the next screen
    let newViewController = AddTodoViewController()
    newViewController.delegate = self
    self.navigationController?.pushViewController(newViewController, animated: true)
    
  }
  
  func setTableViewDelegate() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  //  CORE DATA : - FUNCTION
  func getAllItems(){
    do {
      list = try context.fetch(ToDoList.fetchRequest())
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
    catch {
      //error
    }
  }
  
  func createItems(_ items: ToDoList){
    do{
      try context.save()
      getAllItems()
    }
    catch{
      // error
    }
  }
}

extension ToDoListViewController:UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as! TodoListCell
    let todo = list[indexPath.row]
    cell.configure(with: TodoListViewModel(with: todo))
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let newViewController = AddTodoViewController()
    newViewController.delegate = self
    self.navigationController?.pushViewController(newViewController, animated: true)
    let indexPath = tableView.indexPathForSelectedRow!
    let selectedcell = list[indexPath.row]
    newViewController.selectedcell = selectedcell
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: "Remove") { (action, view, completionHandler) in
      // which person to remove
      let personToRemove = self.list[indexPath.row]
      //remove the person
      self.context.delete(personToRemove)
      // save data
      do{
        try self.context.save()
      }
      catch {
      }
      self.getAllItems()
    }
    return UISwipeActionsConfiguration(actions: [action])
  }
  
  override func viewDidAppear(_ animated: Bool)
  {
    tableView.reloadData()
  }
}

extension ToDoListViewController : addToDoViewControllerDelegate{
  func saveTodo(_ item: ToDoList) {
    self.createItems(item)
  }
}
 

