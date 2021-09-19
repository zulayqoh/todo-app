//
//  TodoViewModel.swift
//  myTodoListApp
//
//  Created by Decagon on 15/09/2021.
//

import UIKit.UIImage

struct TodoListViewModel {
  let title: String
  let desc: String
  let todoImportant: String
  var image: UIImage?
  
  init(with model: ToDoList){
    title = model.title!
    desc = model.desc!
    todoImportant = model.important!
    image = UIImage(named: "importantImage")!
    
  }
}
