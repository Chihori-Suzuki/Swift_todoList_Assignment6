//
//  TableViewController.swift
//  SimpleTodoList
//
//  Created by 鈴木ちほり on 2021/01/09.
//

import UIKit

class TableViewController: UITableViewController, AddEditTCVDelegate {

    let cellId = "TodoCell"
    var toDos: [[Todo]] = [
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
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTodoItems))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTodo))
        navigationItem.rightBarButtonItems = [addButton, deleteButton]
        tableView.allowsMultipleSelectionDuringEditing = true
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
    func add(_ toDo: Todo) {
        toDos[1].append(toDo)
//        print("todo count:\(todo[1].count)")
//        print("todo index:\(IndexPath(row: todo[1].count - 1, section: 1))")
        tableView.insertRows(at: [IndexPath(row: toDos[1].count - 1, section: 1)], with: .automatic)
    }
    func edit(_ toDo: Todo) {
        if let indexPath = tableView.indexPathForSelectedRow {
            toDos[indexPath.section].remove(at: indexPath.row)
            toDos[indexPath.section].insert(toDo, at: indexPath.row)
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
        return toDos[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todos = toDos[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
       as! TodoTableViewCell
        cell.update(with: todos)
        cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton
        cell.showsReorderControl = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let addEditTVC = AddEditTableViewController(style: .grouped)
        addEditTVC.delegate = self
        addEditTVC.todoText = toDos[indexPath.section][indexPath.row]
        let addEditNC = UINavigationController(rootViewController: addEditTVC)
        present(addEditNC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let removedTodo = toDos.remove(at: sourceIndexPath.row)
        toDos.insert(removedTodo, at: destinationIndexPath.row)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if !tableView.isEditing {
            print(indexPath)
            if toDos[indexPath.section][indexPath.row].symbol == ""  {
                toDos[indexPath.section][indexPath.row].symbol = "✓"
            }else{
                toDos[indexPath.section][indexPath.row].symbol = ""
            }
        } else {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
//        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @objc func deleteTodoItems() {
        if let indexPaths = tableView.indexPathsForSelectedRows {
            for indexPath in indexPaths.reversed() {
                print(indexPath)
                toDos[indexPath.section].remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                }
        }
    }
}
