//
//  TableViewController.swift
//  SimpleTodoList
//
//  Created by 鈴木ちほり on 2021/01/09.
//

import UIKit

class TableViewController: UITableViewController, AddEditTCVDelegate {

    let cellId = "TodoCell"
    var todo: [[Todo]] = [
        [
            Todo(symbol: "✓", title: "Feed my cat")
            ,Todo(symbol: "✓", title: "Make a lunch")
        ],
        [
            Todo(symbol: "✓", title: "Clean my room")
            ,Todo(symbol: "✓", title: "do the laundry")
        ],
        [
            Todo(symbol: "✓", title: "Study about Swift language")
            ,Todo(symbol: "✓", title: "return the books")
        ]
    ]
    
    var sectionTitles: [String] = ["High Priority", "Midium Priority", "Low Priority"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: cellId)
        title = "Todo items"
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTodo))
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
    private func navigateToAddEditTVC() {
        let addEditTVC = AddEditTableViewController(style: .grouped)
        addEditTVC.delegate = self
        let addEditNC = UINavigationController(rootViewController: addEditTVC)
        present(addEditNC, animated: true, completion: nil)
    }
    
    @objc func addNewTodo(){
        
        navigateToAddEditTVC()
    }
    func add(_ todos: [Todo]) {
        todo.append(todos)
        print("todo count:\(todo[1].count)")
        print("todo index:\(IndexPath(row: todo[1].count, section: 1))")
        tableView.insertRows(at: [IndexPath(row: todo[1].count, section: 1)], with: .automatic)
    }
    func edit(_ todos: [Todo]) {
        if let indexPath = tableView.indexPathForSelectedRow {
            todo.remove(at: indexPath.row)
            todo.insert(todos, at: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("section : \(section)")
        return todo[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todos = todo[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
       as! TodoTableViewCell
        
        cell.update(with: todos)
        cell.showsReorderControl = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let removedTodo = todo.remove(at: sourceIndexPath.row)
        todo.insert(removedTodo, at: destinationIndexPath.row)
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let addEditTVC = AddEditTableViewController(style: .grouped)
        addEditTVC.delegate = self
        addEditTVC.todoText = todo[indexPath.section][indexPath.row]
        let addEditNC = UINavigationController(rootViewController: addEditTVC)
        present(addEditNC, animated: true, completion: nil)
    }

}