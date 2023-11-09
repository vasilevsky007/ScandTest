//
//  OrderViewController.swift
//  ScandTest
//
//  Created by Alex on 6.11.23.
//

import UIKit
import CoreData

class OrderViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate  {

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
    @IBOutlet weak var orderButton: UIButton!
    
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
        self.productNameLabel.text = product.name
        self.productPriceLabel.text = String(format: "%.2f", product.price)
        
        firstNameField.delegate = self
        lastNameField.delegate = self
        streetField.delegate = self
        houseField.delegate = self
        apartamentField.delegate = self
        phoneField.delegate = self
        emailField.delegate = self
        commentText.delegate = self
        
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
    
    func setSendState(isSending: Bool) {
        orderButton.isEnabled = !isSending
        orderButton.tintColor = .systemBackground
        orderButton.configuration?.showsActivityIndicator = isSending
    }
    
    @IBAction func sendOrder(_ sender: UIButton) {
        setSendState(isSending: true)
        let order = Order(
            products: [product],
            user: getUserFromFields(),
            comment: commentText.text ?? "" == "" ? nil : commentText.text!
        )
        Task.detached { [weak self] in
            do {
                try await self?.orderManager.sendOrder(order: order)
                await self?.setSendState(isSending: false)
                try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
                await self?.navigationController?.popViewController(animated: true)
            } catch {
                 /* somehow this will not happen if just internet is down,
                  because FirebaseDatabase ... .setValue(from: )
                  nor throwing error in this case through standard error
                  handling, nor through it's completion handler */
                await self?.setSendState(isSending: false)
                print("error sending order: \(error)")
                let alert = await UIAlertController(
                    title: "Order send failed",
                    message: error.localizedDescription,
                    preferredStyle: .alert)
                let ok = await UIAlertAction(
                    title: "Got it",
                    style: .cancel,
                    handler: nil)
                await alert.addAction(ok)
                await self?.present(alert, animated: true)
            }
        }
    }
    
    func setup(selectedProduct product: Product) {
        self.product = product
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameField:
            lastNameField.becomeFirstResponder()
        case lastNameField:
            streetField.becomeFirstResponder()
        case streetField:
            houseField.becomeFirstResponder()
        case houseField:
            apartamentField.becomeFirstResponder()
        case apartamentField:
            phoneField.becomeFirstResponder()
        case phoneField:
            emailField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}
