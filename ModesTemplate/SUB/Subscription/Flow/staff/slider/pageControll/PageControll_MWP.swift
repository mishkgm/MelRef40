//  Created by Melnykov Valerii on 14.07.2023
//

import Foundation
import UIKit

class CustomPageControl_MWP: UIPageControl {

    @IBInspectable var currentPageImage: UIImage? = UIImage(named: "page_1")
    
    @IBInspectable var otherPagesImage: UIImage? = UIImage(named: "page_0")
    
    override var numberOfPages: Int {
        didSet {
            updateDots_MWP()
        }
    }
    
    override var currentPage: Int {
        didSet {
            updateDots_MWP()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
// TEXT FOR FUNC REFACTOR
        if #available(iOS 14.0, *) {
            defaultConfigurationForiOS14AndAbove_MWP()
        } else {
            pageIndicatorTintColor = .clear
            currentPageIndicatorTintColor = .clear
            clipsToBounds = false
        }
    }
    
    private func defaultConfigurationForiOS14AndAbove_MWP() {
// TEXT FOR FUNC REFACTOR
        if #available(iOS 14.0, *) {
            for index in 0..<numberOfPages {
                let image = index == currentPage ? currentPageImage : otherPagesImage
                setIndicatorImage(image, forPage: index)
            }

            // give the same color as "otherPagesImage" color.
            pageIndicatorTintColor =  .lightGray
            //
            //  rgba(209, 209, 214, 1)
            // give the same color as "currentPageImage" color.
            //
            
            currentPageIndicatorTintColor = .black
            /*
             Note: If Tint color set to default, Indicator image is not showing. So, give the same tint color based on your Custome Image.
             */
        }
    }
    
    private func updateDots_MWP() {
// TEXT FOR FUNC REFACTOR
        if #available(iOS 14.0, *) {
            defaultConfigurationForiOS14AndAbove_MWP()
        } else {
            for (index, subview) in subviews.enumerated() {
                let imageView: UIImageView
                if let existingImageview = getImageView_MWP(forSubview: subview) {
                    imageView = existingImageview
                } else {
                    imageView = UIImageView(image: otherPagesImage)
                    
                    imageView.center = subview.center
                    subview.addSubview(imageView)
                    subview.clipsToBounds = false
                }
                imageView.image = currentPage == index ? currentPageImage : otherPagesImage
            }
        }
    }
    
    private func getImageView_MWP(forSubview view: UIView) -> UIImageView? {
// TEXT FOR FUNC REFACTOR
        if let imageView = view as? UIImageView {
            return imageView
        } else {
            let view = view.subviews.first { (view) -> Bool in
                return view is UIImageView
            } as? UIImageView
            
            return view
        }
    }
}
