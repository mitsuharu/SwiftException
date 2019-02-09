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
        
    }
    
    func addTableView(){
        
        self.removeTableView()
        
        self.tableView = ExcTableView(frame: self.view.bounds,
                                      style: UITableView.Style.plain)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "VanillaCell", bundle: nil),
                                forCellReuseIdentifier: "VanillaCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(white: 0.99, alpha: 1.0)
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

extension ViewController{
    
    // 配列の範囲外の要素にアクセスする
    func demo1(){
        ExcBlock.execute({
            let temps = [0, 1, 2]
            let temp = temps[10]
            print("temp = \(temp)")
        }) { (exception) in
            print(exception)
            self.alert = {
                let alert = UIAlertController(title: "exception",
                                              message: exception.description,
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK",
                                              style: UIAlertAction.Style.default,
                                              handler:nil))
                return alert
            }()
            if let alert = self.alert{
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // TableViewの範囲外のセルを更新する
    func demo2(){
        
        self.counter += 1
        let ip = IndexPath(row: 100, section: 100)
        
        self.tableView.exc_reloadRows(at: [ip], with: .automatic) { (exception) in
            self.alert = {
                let alert = UIAlertController(title: "exception",
                                              message: exception.description,
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "fix",
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

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "デモ \(section + 1)"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VanillaCell",
                                                 for: indexPath)
        
        var str: String = ""
        if indexPath.section == 0{
            str = "配列の範囲外の要素にアクセスする"
        }else if indexPath.section == 1{
            str = "範囲外のセルを更新する (tap:\(self.counter))"
        }
        
        cell.textLabel?.text = str
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let sec = indexPath.section
        if sec == 0{
            self.demo1()
        }else if sec == 1{
            self.demo2()
        }
        
    }
    
}

