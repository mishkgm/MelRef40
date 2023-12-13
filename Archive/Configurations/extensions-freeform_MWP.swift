//  Created by Melnykov Valerii on 14.07.2023
//


import Foundation
import UIKit


extension UIView_MWP {
    public func fixInView_MWP(_ container: UIView!) -> Void{
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    public func onClick_MWP(target: Any, _ selector: Selector) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: selector)
        addGestureRecognizer(tap)
    }
    
    public  func roundCorners_MWP(_ corners: UIRectCorner, radius: CGFloat) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    public  var renderedImage: UIImage {
        
        // rect of capure
        let rect = self.bounds
        
        // create the context of bitmap
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        self.layer.render(in: context)
        // self.layer.render(in: context)
        // get a image from current context bitmap
        let capturedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capturedImage
    }
    
    public func fadeIn_MWP(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };        self.alpha = 0.0
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    public  func fadeOut_MWP(duration: TimeInterval = 1.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };        self.alpha = 1.0
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.isHidden = true
            self.alpha = 0.0
        }, completion: completion)
    }
    
    public  func vibto_MWP(style : UIImpactFeedbackGenerator.FeedbackStyle){
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    public func drawBorder_MWP(edges: [UIRectEdge], borderWidth: CGFloat, color: UIColor, margin: CGFloat) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };        for item in edges {
            let borderLayer: CALayer = CALayer()
            borderLayer.borderColor = color.cgColor
            borderLayer.borderWidth = borderWidth
            switch item {
            case .top:
                borderLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: borderWidth)
            case .left:
                borderLayer.frame =  CGRect(x: 0, y: margin, width: borderWidth, height: frame.height - (margin*2))
            case .bottom:
                borderLayer.frame = CGRect(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth)
            case .right:
                borderLayer.frame = CGRect(x: frame.width - borderWidth, y: margin, width: borderWidth, height: frame.height - (margin*2))
            case .all:
                drawBorder_MWP(edges: [.top, .left, .bottom, .right], borderWidth: borderWidth, color: color, margin: margin)
            default:
                break
            }
            self.layer.addSublayer(borderLayer)
        }
    }
}

extension UIView_MWP {
    
    func pushTransition_MWP(duration:CFTimeInterval, animationSubType: String) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = convertToOptionalCATransitionSubtype_MWP(animationSubType)
        animation.duration = duration
        self.layer.add(animation, forKey: convertFromCATransitionType_MWP(CATransitionType.push))
    }
    
     func convertFromCATransitionSubtype_MWP(_ input: CATransitionSubtype) -> String {
         let i = 0
         let b = 2
         if i < b {
             var _ = i + b
         }
        return input.rawValue
    }
    
     func convertToOptionalCATransitionSubtype_MWP(_ input: String?) -> CATransitionSubtype? {
         let i = 0
         let b = 2
         if i < b {
             var _ = i + b
         }
        guard let input = input else { return nil }
        return CATransitionSubtype(rawValue: input)
    }
    
     func convertFromCATransitionType_MWP(_ input: CATransitionType) -> String {
         let i = 0
         let b = 2
         if i < b {
             var _ = i + b
         }
        return input.rawValue
    }
}

typealias UILabel_MWP = UILabel
extension UILabel_MWP {
    func setShadow_MWP(with opacity: Float = 1.0){
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.masksToBounds = false
    }
}

typealias String_MWP = String
extension String_MWP {
    var underLined: NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
}

extension String_MWP {
    func openURL(){
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };        if let url = URL(string: self) {
            UIApplication.shared.impactFeedbackGenerator(type: .medium)
            UIApplication.shared.open(url)
        }
    }
}

typealias UIApplication_MWP = UIApplication
extension UIApplication_MWP {
   func setRootVC_MWP(_ vc : UIViewController){
       let i = 0
       let b = 2
       if i < b {
           var _ = i + b
       }
       self.windows.first?.rootViewController = vc
       self.windows.first?.makeKeyAndVisible()
     }
 }


extension UIApplication_MWP {
    func notificationFeedbackGenerator(type : UINotificationFeedbackGenerator.FeedbackType) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impactFeedbackGenerator(type : UIImpactFeedbackGenerator.FeedbackStyle) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };        let generator = UIImpactFeedbackGenerator(style: type)
        generator.impactOccurred()
    }
}

extension UIApplication_MWP {
    func isIpad_MWP() -> Bool {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };        if isPad {
            return true
        }
        return false
    }
}

typealias UICollectionView_MWP = UICollectionView
extension UICollectionView_MWP {
    func scrollToLastItem_MWP(at scrollPosition: UICollectionView.ScrollPosition = .centeredHorizontally, animated: Bool = true) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };        let lastSection = numberOfSections - 1
        guard lastSection >= 0 else { return }
        let lastItem = numberOfItems(inSection: lastSection) - 1
        guard lastItem >= 0 else { return }
        let lastItemIndexPath = IndexPath(item: lastItem, section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: scrollPosition, animated: animated)
    }
}
