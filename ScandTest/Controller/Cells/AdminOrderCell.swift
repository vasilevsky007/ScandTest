//
//  AdminOrderCell.swift
//  ScandTest
//
//  Created by Alex on 7.11.23.
//

import UIKit

class AdminOrderCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var houseLabel: UILabel!
    @IBOutlet weak var apartamentLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(_ order: Order) {
        
        self.timeLabel.text = order.time.formatted(date: .numeric, time: .standard)
        self.orderIdLabel.text = order.id.uuidString
        self.priceLabel.text = String(format: "%.2f", order.products.first?.price ?? 0.0)
        self.productNameLabel.text = order.products.first?.name ?? ""
        self.firstNameLabel.text = order.user.firstName
        self.lastNameLabel.text = order.user.lastName
        self.phoneLabel.text = order.user.phoneNumber
        self.emailLabel.text = order.user.email ?? ""
        self.streetLabel.text = order.user.address.street
        self.houseLabel.text = order.user.address.house
        self.apartamentLabel.text = order.user.address.apartament ?? ""
        self.commentLabel.text = order.comment ?? ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
