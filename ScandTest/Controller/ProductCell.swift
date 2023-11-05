//
//  ProductCell.swift
//  ScandTest
//
//  Created by Alex on 5.11.23.
//

import UIKit

class ProductCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(_ product: Product) {
        self.nameLabel.text = product.name
        self.priceLabel.text = String(format: "%.2f", product.price)
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
    }
}
