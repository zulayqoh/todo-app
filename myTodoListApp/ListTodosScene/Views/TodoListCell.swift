//
//  TodoListCell.swift
//  myTodoListApp
//
//  Created by Decagon on 09/09/2021.
//

import UIKit

class TodoListCell: UITableViewCell{
  
  lazy var titleLabel : UILabel = {
    let label = UILabel()
    label.textColor = UIColor.blue
    label.font = UIFont.boldSystemFont(ofSize: 25.0)
    label.translatesAutoresizingMaskIntoConstraints = false
      return label
  }()
  
  lazy var descLabel : UILabel = {
    let label = UILabel()
    label.textColor = UIColor.blue
    label.font = UIFont(name: "Helvetica", size: 20)
    label.translatesAutoresizingMaskIntoConstraints = false
      return label
  }()
    
  var img: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.image = UIImage(named: "importantImage")
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(titleLabel)
    addSubview(descLabel)
    addSubview(img)
    setConstriant()
  }
  
  func configure(with viewModel: TodoListViewModel){
    titleLabel.text = viewModel.title
    descLabel.text = viewModel.desc
    if viewModel.todoImportant == "important" {
      img.image = viewModel.image
    } else {
      img.image = nil
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setConstriant() {
    let stack = UIStackView(arrangedSubviews: [titleLabel,descLabel])
    stack.axis = .vertical
    stack.distribution = .fillProportionally
    stack.spacing = 1
    addSubview(stack)
   
    
    _ = stack.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    
    NSLayoutConstraint.activate([
      img.heightAnchor.constraint(equalToConstant: 30),
      img.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      img.topAnchor.constraint(equalTo: topAnchor, constant: 20),
    ])
  }
}


