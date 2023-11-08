//
//  AdminProductDBTableViewController.swift
//  ScandTest
//
//  Created by Alex on 7.11.23.
//

import UIKit

class AdminProductDBTableViewController: UITableViewController {
    
    private let productNetworkManager: ProductNetworkManager = FirestoreProductNetworkManager()
    private lazy var store = ProductStore { [weak self] in
        self?.updateProductsDisplayed()
    }
    
    private var refresh = UIRefreshControl()
    
    private var productsDisplayed = [Product]()
    
    private func updateProductsDisplayed() {
        Task { [weak self] in
            self?.productsDisplayed = await (self?.store.items)!
            self?.tableView.reloadData()
        }
    }
    
    private func fetchProductsfromNetwork() async {
        do {
            let receivedProducts = try await productNetworkManager.loadAllProducts()
            await store.removeAll()
            for product in receivedProducts {
                await store.add(product)
            }
        } catch {
            print("error while loading products from firebase: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "AdminProductCell", bundle: nil), forCellReuseIdentifier: "AdminProductCell")
        self.refresh.addTarget(self, action: #selector(fetchProducts), for: .valueChanged)
        self.refresh.tintColor = .label
        self.tableView.addSubview(self.refresh)
        self.refresh.beginRefreshing()
        self.fetchProducts()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func fetchProducts() {
        Task.detached { [weak self] in
            await self?.fetchProductsfromNetwork()
            await self?.refresh.endRefreshing()
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productsDisplayed.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminProductCell", for: indexPath) as! AdminProductCell
        let accessoryButton = UIButton(type: .roundedRect)
        if indexPath.row == 0 {
            cell.setup(Product(name: "", price: 0))
            accessoryButton.setTitle("Add", for: .normal)
        } else {
            cell.setup(productsDisplayed[indexPath.row - 1])
            accessoryButton.setTitle("Save", for: .normal)
        }
        accessoryButton.addTarget(self, action: #selector(accessoryButtonTapped(_:)), for: .touchUpInside)
        accessoryButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        cell.accessoryView = accessoryButton
        return cell
    }
    
    @objc func accessoryButtonTapped(_ sender: UIButton) {
        let cell = sender.superview as! AdminProductCell
        let updatedProduct = cell.getUpdatedProduct()
        Task {
            //MARK: mb i should integrate store & NM to make all of this more consistent
            await store.update(updatedProduct)
            Task.detached {
                do {
                    try await self.productNetworkManager.updateProduct(updatedProduct)
                } catch {
                    print("error while updating product \(updatedProduct):\n\(error)")
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row > 0 {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
                let product = self.productsDisplayed[indexPath.row - 1]
                Task {
                    await self.store.remove(product)
                    Task.detached {
                        do {
                            try await self.productNetworkManager.deleteProduct(product)
                        } catch {
                            print("error while deleting product \(product):\n\(error)")
                        }
                    }
                }
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
            return swipeConfiguration
        } else {
            return nil
        }
    }
    
    //MARK: this is working only with default cell.accessoryType = .detailButton , i wanted to ese chekmark, but its'not calling this((
//    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        print("accesory tapped")
//        let tappedCell = tableView.cellForRow(at: indexPath) as! AdminProductCell
//        let updatedProduct = tappedCell.getUpdatedProduct()
//        print(updatedProduct)
//        Task {
//            await store.update(updatedProduct)
//            Task.detached {
//                do {
//                    try await self.productNetworkManager.updateProduct(updatedProduct)
//                } catch {
//                    print("error while updating product \(updatedProduct):\n\(error)")
//                }
//            }
//        }
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



