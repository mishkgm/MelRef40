//  Created by Melnykov Valerii on 14.07.2023
//


import UIKit

class ReusableCell_MWP: UICollectionViewCell {
    
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        setupCell_MWP()
    }
    
    func setupCell_MWP() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        imageLabel.textColor = UIColor(red: 0.446, green: 0.446, blue: 0.446, alpha: 1)
        cellLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        cellLabel.font = UIFont(name: Configurations_MWP.fontName, size: 10)
        imageLabel.font = UIFont(name: Configurations_MWP.fontName, size: 10)
        contentContainer.layer.cornerRadius = 8
        titleContainer.layer.cornerRadius = 8
        imageLabel.setShadow_MWP(with: 0.5)
        cellLabel.setShadow_MWP(with: 0.5)
        cellImage.layer.cornerRadius = 8
//        cellImage.layer.borderColor = UIColor.black.cgColor
//        cellImage.layer.borderWidth = 2
    }
}
