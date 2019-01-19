//
//  ViewController.swift
//  SwiftRuntimeException
//
//  Created by Mitsuhau Emoto on 2019/01/19.
//  Copyright © 2019 Mitsuhau Emoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: ExcTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
//        ExcBlock.execute({
//            let temps = [0, 1, 2]
//            print("\(temps[10])")
//            // ブロックの中で起こる例外がキャッチできないまま落ちる
//        }) { (exception) in
//            print(exception)
//        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.textLabel?.text = "row:\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ip = IndexPath(row: 100, section: 100)

        self.tableView.exc_reloadRows(at: [ip], with: UITableView.RowAnimation.automatic) { (exception) in
            print("[exc_reloadRows] exception:\(exception)")
        }
    }
    
}

