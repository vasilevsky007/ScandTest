//
//  AdminProductCell.swift
//  ScandTest
//
//  Created by Alex on 8.11.23.
//

import UIKit

class AdminProductCell: UITableViewCell {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var photoUrlField: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    
    private var displayingProduct: Product!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setup(_ product: Product) {
        self.displayingProduct = product
        self.nameField.text = product.name
        self.priceField.text = String(product.price)
        self.photoUrlField.text = ""
        if let photo = product.photo {
            switch photo {
            case .url(let url):
                self.photoUrlField.text = url.absoluteString
            default:
                break
            }
        }
        self.descriptionText.text = product.description ?? ""
    }
    func getUpdatedProduct() -> Product {
        var updatedProduct: Product = displayingProduct
        updatedProduct.name = nameField?.text ?? ""
        updatedProduct.price = (try? Double(priceField.text ?? "", format: .number)) ?? 0.0
        updatedProduct.photo = .url(URL(string: photoUrlField.text ?? "") ?? URL(string: "")!)
        updatedProduct.description = descriptionText.text ?? ""
        return updatedProduct
    }
}


