//
//  ViewController.swift
//  SwiftRuntimeException
//
//  Created by Mitsuhau Emoto on 2019/01/19.
//  Copyright © 2019 Mitsuhau Emoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var tableView: ExcTableView!
    var counter: Int = 0
    var alert: UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTableView()
        
//        ExcBlock.execute({
//            let temps = [0, 1, 2]
//            print("\(temps[10])")
//            // ブロックの中で起こる例外がキャッチできないまま落ちる
//        }) { (exception) in
//            print(exception)
//        }
    }
    
    func addTableView(){
        
        self.removeTableView()
        
        self.tableView = ExcTableView(frame: self.view.bounds,
                                      style: UITableView.Style.plain)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "VanillaCell", bundle: nil),
                                forCellReuseIdentifier: "VanillaCell")
        self.view.addSubview(self.tableView)
    }
    
    func removeTableView()  {
        guard
            let tableView = self.tableView,
            let _ = self.tableView.superview else {
            return
        }
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.removeFromSuperview()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VanillaCell",
                                                 for: indexPath)
        cell.textLabel?.text = "row:\(indexPath.row), counter:\(counter)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        counter += 1
        let ip = IndexPath(row: 100, section: 100)

        self.tableView.exc_reloadRows(at: [ip], with: UITableView.RowAnimation.automatic) { (exception) in
            print("[exc_reloadRows] exception:\(exception)")
            
            self.alert = {
                let alert = UIAlertController(title: "例外が起こりました",
                                              message: exception.description,
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "復元する",
                                              style: UIAlertAction.Style.default,
                                              handler: { (action) in
                                                self.addTableView()
                }))
                return alert
            }()
            if let alert = self.alert{
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

