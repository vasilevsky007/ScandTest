//
//  OrderViewController.swift
//  ScandTest
//
//  Created by Alex on 6.11.23.
//

import UIKit
import CoreData

class OrderViewController: UIViewController {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var houseField: UITextField!
    @IBOutlet weak var apartamentField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var commentText: UITextView!
    
    private var product: Product!
    private var orderManager = FirebaseRTDBOrderNetworkMananger()
    private var restoredUser: User? {
        didSet {
            if let user = restoredUser {
                firstNameField.text = user.firstName
                lastNameField.text = user.lastName
                phoneField.text = user.phoneNumber
                emailField.text = user.email ?? ""
                streetField.text = user.address.street
                houseField.text = user.address.house
                apartamentField.text = user.address.apartament ?? ""
            }
        }
    }
    private lazy var userCacher: CoreDataUserCacher? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        return CoreDataUserCacher(context: context)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Task {
            restoredUser = try? await userCacher?.load()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Task.detached {
            try? await self.userCacher?.save(self.getUserFromFields())
        }
        super.viewWillDisappear(animated)
    }
    
    
    func getUserFromFields() -> User {
        let address = User.Address(
            street: streetField.text!,
            house: houseField.text!,
            apartament: apartamentField.text! == "" ? nil : apartamentField.text!
        )
        if var user = restoredUser {
            user.firstName = firstNameField.text!
            user.lastName = lastNameField.text!
            user.phoneNumber = phoneField.text!
            user.email = emailField.text! == "" ? nil : emailField.text!
            user.address = address
            return user
        } else {
            let user = User(
                firstName: firstNameField.text!,
                lastName: lastNameField.text!,
                phoneNumber: phoneField.text!,
                email: emailField.text! == "" ? nil : emailField.text!,
                adress: address)
            return user
        }
    }
    
    
    
    @IBAction func sendOrder(_ sender: UIButton) {
        let order = Order(
            products: [product],
            user: getUserFromFields(),
            comment: commentText.text ?? "" == "" ? nil : commentText.text!
        )
        Task {
            do {
                try await orderManager.sendOrder(order: order)
            } catch {
                print("error sending order: \(error)")
            }
        }
    }
    
    
    
    func setup(selectedProduct product: Product) {
        self.product = product
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
