//
//  AdminOrdersTableViewController.swift
//  ScandTest
//
//  Created by Alex on 7.11.23.
//

import UIKit

class AdminOrdersTableViewController: UITableViewController {

    private var db = FirebaseRTDBOrderNetworkMananger()
    
    private var orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "AdminOrderCell", bundle: nil), forCellReuseIdentifier: "AdminOrderCell")
        
        db.listenToNewOrders { [weak self] allOrders in
            self?.orders = allOrders.sorted(by: { order1, order2 in
                order1.time > order2.time
            })
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminOrderCell", for: indexPath) as! AdminOrderCell
        cell.setup(orders[indexPath.row])
        return cell
    }

}
