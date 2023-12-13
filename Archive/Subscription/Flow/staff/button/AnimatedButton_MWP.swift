//  Created by Melnykov Valerii on 14.07.2023
//


import UIKit
import SwiftyGif


protocol AnimatedButton_MWPEvent : AnyObject {
    func onClick_MWP()
}

enum animationButtonStyle_MWP {
    case gif,native
}

class AnimatedButton_MWP: UIView {
    
    @IBOutlet private var contentSelf: UIView!
    @IBOutlet private weak var backgroundSelf: UIImageView!
    @IBOutlet private weak var titleSelf: UILabel!
    
    weak var delegate : AnimatedButton_MWPEvent?
    private let currentFont = Configurations_MWP.fontName
    private var persistentAnimations: [String: CAAnimation] = [:]
    private var persistentSpeed: Float = 0.0
    private let xib = "AnimatedButton_MWP"
    
    public var style : animationButtonStyle_MWP = .native
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        Init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        Init()
    }
    
    // Этот метод будет вызван, когда view добавляется к superview
      override func didMoveToSuperview() {
          super.didMoveToSuperview()
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
          if style == .native {
              setPulseAnimation_MWP()
              addNotificationObservers()
          }
        
      }

      // Этот метод будет вызван перед тем, как view будет удален из superview
      override func willMove(toSuperview newSuperview: UIView?) {
          super.willMove(toSuperview: newSuperview)
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
          if style == .native {
              if newSuperview == nil {
                  self.layer.removeAllAnimations()
                  removeNotificationObservers_MWP()
              }
          }
      }

      private func addNotificationObservers() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
          NotificationCenter.default.addObserver(self, selector: #selector(pauseAnimation_MWP), name: UIApplication.didEnterBackgroundNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(resumeAnimation_MWP), name: UIApplication.willEnterForegroundNotification, object: nil)
      }

      private func removeNotificationObservers_MWP() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
          NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
          NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
      }

      @objc private func pauseAnimation_MWP() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
          self.persistentSpeed = self.layer.speed

          self.layer.speed = 1.0 //in case layer was paused from outside, set speed to 1.0 to get all animations
          self.persistAnimations_MWP(withKeys: self.layer.animationKeys())
          self.layer.speed = self.persistentSpeed //restore original speed

          self.layer.pause()
      }

      @objc private func resumeAnimation_MWP() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
          self.restoreAnimations_MWP(withKeys: Array(self.persistentAnimations.keys))
          self.persistentAnimations.removeAll()
          if self.persistentSpeed == 1.0 { //if layer was plaiyng before backgorund, resume it
              self.layer.resume()
          }
      }
    
    func persistAnimations_MWP(withKeys: [String]?) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        withKeys?.forEach({ (key) in
            if let animation = self.layer.animation(forKey: key) {
                self.persistentAnimations[key] = animation
            }
        })
    }

    func restoreAnimations_MWP(withKeys: [String]?) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        withKeys?.forEach { key in
            if let persistentAnimation = self.persistentAnimations[key] {
                self.layer.add(persistentAnimation, forKey: key)
            }
        }
    }
    
    private func Init() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        Bundle.main.loadNibNamed(xib, owner: self, options: nil)
        contentSelf.fixInView_MWP(self)
        contentSelf.backgroundColor = #colorLiteral(red: 0.4901960784, green: 0.4901960784, blue: 0.4901960784, alpha: 1)
        contentSelf.layer.cornerRadius = 8
        animationBackgroundInit_MWP()
        
    }
    
    private func animationBackgroundInit_MWP() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        titleSelf.text = localizedString(forKey: "iOSButtonID")
        titleSelf.font = UIFont(name: currentFont, size: 29)
        titleSelf.textColor = .white
        titleSelf.minimumScaleFactor = 11/22
        if style == .native {
           setPulseAnimation_MWP()
        }else {
            do {
                let gif = try UIImage(gifName: "btn_gif.gif")
                backgroundSelf.setGifImage(gif)
            } catch {
                print(error)
            }
        }
        
        self.onClick_MWP(target: self, #selector(click_MWP))
    }
    
    @objc func click_MWP(){
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        delegate?.onClick_MWP()
    }
    

    
}

typealias UIView_MWP = UIView
extension UIView_MWP {
    func setPulseAnimation_MWP(){
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1
        pulseAnimation.toValue = 0.95
        pulseAnimation.fromValue = 0.79
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        self.layer.add(pulseAnimation, forKey: "pulse")
    }
}

typealias CALayer_MWP = CALayer
extension CALayer_MWP {
    func pause() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        if self.isPaused_MWP() == false {
            let pausedTime: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil)
            self.speed = 0.0
            self.timeOffset = pausedTime
        }
    }

    func isPaused_MWP() -> Bool {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        return self.speed == 0.0
    }

    func resume() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        let pausedTime: CFTimeInterval = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        let timeSincePause: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
    }
}
