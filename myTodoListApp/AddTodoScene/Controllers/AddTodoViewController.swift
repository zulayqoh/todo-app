//
//  AddTodoViewController.swift
//  myTodoListApp
//
//  Created by Decagon on 08/09/2021.
//

import UIKit
import CoreData

protocol addToDoViewControllerDelegate: AnyObject {
  func saveTodo(_ item: ToDoList)
}

class AddTodoViewController: UIViewController {
  
  var selectedcell: ToDoList? = nil
  var delegate: addToDoViewControllerDelegate?
  var list = [ToDoList]()
  
  let saveButton: UIButton = {
    let button = UIButton()
    button.setTitle("Save", for: .normal)
    button.backgroundColor = UIColor(red: 0.29, green: 0.05, blue: 0.76, alpha: 1.00)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
    button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 10
    return button
  }()
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Title"
    label.font = UIFont(name: "Helvetica", size: 25)
    return label
  }()
  
  let descLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Description"
    label.font = UIFont(name: "Helvetica", size: 25)
    return label
  }()
  
  let titleTextField: paddedTextField = {
    let textField = paddedTextField()
    textField.placeholder = "Enter Title"
    textField.layer.borderColor = UIColor.lightGray.cgColor
    textField.layer.borderWidth = 0
    textField.keyboardType = .default
    textField.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
    textField.layer.cornerRadius = 10
    textField.font = UIFont(name: "Helvetica", size: 20)
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  let descTextView: UITextView = {
    let textView = UITextView()
    textView.layer.borderColor = UIColor.lightGray.cgColor
    textView.layer.borderWidth = 0
    textView.keyboardType = .default
    textView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
    textView.textContainerInset = UIEdgeInsets(top: 3, left: 10, bottom: 0, right: 10)
    textView.font = UIFont(name: "Helvetica", size: 20)
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.layer.cornerRadius = 10
    return textView
  }()
  
  let importantLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Important"
    label.font = UIFont(name: "Helvetica", size: 25)
    return label
  }()
  
  let toggle: UISwitch = {
    var switchToggle = UISwitch()
    switchToggle = UISwitch(frame:CGRect(x: 150, y: 300, width: 0, height: 0))
    return switchToggle
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    layoutViews()
    self.navigationItem.title = "Add Todo list"
    
    // Do any additional setup after loading the view.
    if(selectedcell != nil)
    {
      titleTextField.text = selectedcell?.title
      descTextView.text = selectedcell?.desc
      if selectedcell?.important == "important" {
        toggle.isOn = true
      }else {
        toggle.isOn  = false
      }
    }
  }
  
  
  @objc private func didTapSaveButton() {
    if selectedcell == nil {
      let item = ToDoList(context: context)
      item.title = titleTextField.text
      item.desc =  descTextView.text
      if toggle.isOn == true {
        item.important = "important"
      }else {
        item.important = "unimportant"
      }
      do
      {
        if titleTextField.text!.isEmpty || descTextView.text.isEmpty {
          let alert = UIAlertController(title: "Error", message: "Title or description cannot be empty", preferredStyle: .alert)
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
          alert.addAction(cancelAction)
          self.present(alert, animated: true, completion: nil)
        }else {
          delegate?.saveTodo(item)
          navigationController?.popViewController(animated: true)
        }
      }
    }
    // MARK: // EDIT
    else {
      do {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoList")
        let results: NSArray = try context.fetch(request) as NSArray
        for result in results
        {
          let detail = result as! ToDoList
          if(detail == selectedcell)
          {
            detail.title = titleTextField.text
            detail.desc = descTextView.text
            if toggle.isOn {
              detail.important = "important"
            }
            else {
              detail.important = "unimportant"
            }
            if titleTextField.text!.isEmpty || descTextView.text.isEmpty {
              let alert = UIAlertController(title: "Error", message: "Title or description cannot be empty", preferredStyle: .alert)
              let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
              alert.addAction(cancelAction)
              self.present(alert, animated: true, completion: nil)
            } else {
              delegate?.saveTodo(detail)
              navigationController?.popViewController(animated: true)
            }
          }
        }
      }
      catch
      {
        print("Fetch Failed")
      }
    }
  }
}


class paddedTextField: UITextField {
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
  }
  
}

extension AddTodoViewController {
  func layoutViews() {
    view.addSubview(saveButton)
    view.addSubview(titleLabel)
    view.addSubview(titleTextField)
    view.addSubview(descLabel)
    view.addSubview(descTextView)
    
    let stack = UIStackView(arrangedSubviews: [importantLabel,toggle])
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.spacing = 200
    view.addSubview(stack)
    
    NSLayoutConstraint.activate([
      saveButton.heightAnchor.constraint(equalToConstant: 52),
      saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
      saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      
      titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
      titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      titleTextField.heightAnchor.constraint(equalToConstant: 52),
      
      descLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
      descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      
      descTextView.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 16),
      descTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      descTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      descTextView.heightAnchor.constraint(equalToConstant: 200),
      
    ])
    _ = stack.anchor(descTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 16, bottomConstant: 0, rightConstant: -16, widthConstant: 0, heightConstant: 40)
  }
  
}

