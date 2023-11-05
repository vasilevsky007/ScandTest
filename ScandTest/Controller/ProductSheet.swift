//
//  ProductSheet.swift
//  ScandTest
//
//  Created by Alex on 5.11.23.
//

import UIKit

class ProductSheet: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBAction func shareProduct(_ sender: UIButton) {
        if let product  = displayedProduct {
            var items: [Any] = [
                "\(product.name) only  for \(String(format: "%.2f", product.price))"
                    .appending(product.description != nil ? "\n\(product.description!)\n":"\n")
            ]
            if let url = URL(string: "https://www.your-website.com/productbyid/\(product.id)") {
                items.append(url)
            }
            if let image = imageView.image {
                items.append(image)
            }
            let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(activityController, animated: true)
        }
    }
    
    @IBAction func closeSheet(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    private var displayedProduct: Product?
    
    func setup(_ product: Product) {
        if (self.nameLabel as UILabel? != nil) {
            self.nameLabel.text = product.name
            self.priceLabel.text = String(format: "%.2f", product.price)
            self.descriptionLabel.text = product.description
            var image = UIImage(named: "NoImage")
            if let photo = product.photo {
                switch photo {
                case .image(data: let data):
                    if let imageData = data {
                        image = UIImage(data: imageData)
                    }
                default:
                    break
                }
            }
            self.imageView.image = image
            self.displayedProduct = product
        }
    }
}
