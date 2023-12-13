//  Created by Melnykov Valerii on 14.07.2023
//


import UIKit

protocol TransactionView_MWPEvents : AnyObject {
    func userSubscribed()
    func transactionTreatment_MWP(title: String, message: String)
    func transactionFailed()
    func privacyOpen()
    func termsOpen()
}

class TransactionView_MWP: UIView,AnimatedButton_MWPEvent,IAPManagerProtocol_MWP, NetworkStatusMonitorDelegate_MWP {
    func statusChanged() {
        transactionTreatment_MWP(title: NSLocalizedString( "ConnectivityTitle", comment: ""), message: NSLocalizedString("ConnectivityDescription", comment: ""))
    }
    
    func goToTheApp_MWP(type: PremiumMainController_MWPStyle) {
        self.delegate?.userSubscribed()
    }
    
    private let xib = "TransactionView_MWP"
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private(set) weak var title: UILabel!
    @IBOutlet private weak var sliderStack: UIStackView!
    @IBOutlet private weak var trialLb: UILabel!
    @IBOutlet private weak var descriptLb: UILabel!
    @IBOutlet private weak var purchaseBtn: AnimatedButton_MWP!
    @IBOutlet private weak var privacyBtn: UIButton!
    @IBOutlet private weak var policyBtn: UIButton!
    @IBOutlet private weak var trialWight: NSLayoutConstraint!
    @IBOutlet private weak var sliderWight: NSLayoutConstraint!
//    @IBOutlet private weak var sliderTop: NSLayoutConstraint!
    @IBOutlet private weak var conteinerWidth: NSLayoutConstraint!
    @IBOutlet private weak var heightView: NSLayoutConstraint!
    @IBOutlet private weak var starButton: UIImageView!
    
    
    private let currentFont = Configurations_MWP.fontName
    public let inapp = IAPManager_MWP.shared
    private let locale = NSLocale.current.languageCode
    public weak var delegate : TransactionView_MWPEvents?
    private let networkingMonitor = NetworkStatusMonitor_MWP.shared


    override init(frame: CGRect) {
        super.init(frame: frame)
// TEXT FOR FUNC REFACTOR
        Init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
// TEXT FOR FUNC REFACTOR
        Init()
    }
    
    private func Init() {
// TEXT FOR FUNC REFACTOR
        Bundle.main.loadNibNamed(xib, owner: self, options: nil)
        if UIDevice.current.userInterfaceIdiom == .phone {
            // Устройство является iPhone
            if UIScreen.main.nativeBounds.height >= 2436 {
                heightView.constant = 163
            } else {
//                sliderTop.constant = 60
                heightView.constant = 153
            }
        } else {
            conteinerWidth.constant = 400
            heightView.constant = 169
//            sliderTop.constant = 45
        }
        contentView.fixInView_MWP(self)
        contentView.backgroundColor = .clear
        buildConfigs_MWP()
    }
    
    private func buildConfigs_MWP(){
// TEXT FOR FUNC REFACTOR
        configScreen_MWP()
        setSlider_MWP()
        setConfigLabels_MWP()
        setConfigButtons_MWP()
        setLocalization_MWP()
        configsInApp_MWP()
    }
    
    private func setSlider_MWP(){
// TEXT FOR FUNC REFACTOR
        title.text = (localizedString(forKey: "SliderID1").uppercased())
        var texts: [String] = ["\(localizedString(forKey: "SliderID2"))",
                               "\(localizedString(forKey: "SliderID3"))",
                               "\(localizedString(forKey: "SliderID4"))",
                               ]
        for t in texts {
            sliderStack.addArrangedSubview(SliderCellView_MWP(title: t, subTitle: t.lowercased()))
        }
    }
    
    //MARK: config labels
    
    private func setConfigLabels_MWP(){
// TEXT FOR FUNC REFACTOR
        //slider
        title.textColor = .white
        title.font = UIFont(name: currentFont, size: 24)
//        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 4
        title.setShadow_MWP()
        title.lineBreakMode = .byClipping
        if isPad {
            title.font = UIFont(name: currentFont, size: 24)
        }
        trialLb.setShadow_MWP()
        trialLb.font = UIFont(name: currentFont, size: 13)
        trialLb.textColor = .white
        trialLb.textAlignment = .center
        trialLb.numberOfLines = 2
        trialLb.adjustsFontSizeToFitWidth = true
        
        descriptLb.setShadow_MWP()
        descriptLb.textColor = .white
        descriptLb.textAlignment = .center
        descriptLb.numberOfLines = 0
        descriptLb.font = UIFont.systemFont(ofSize: 15)
        
        privacyBtn.titleLabel?.setShadow_MWP()
        privacyBtn.titleLabel?.numberOfLines = 2
        privacyBtn.titleLabel?.textAlignment = .center
        
        privacyBtn.setTitleColor(.white, for: .normal)
        privacyBtn.tintColor = .white
        
        policyBtn.titleLabel?.setShadow_MWP()
        policyBtn.titleLabel?.numberOfLines = 2
        policyBtn.titleLabel?.textAlignment = .center
        policyBtn.setTitleColor(.white, for: .normal)
        policyBtn.tintColor = .white
        privacyBtn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 12)
        policyBtn.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 12)
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            title.textAlignment = .right
        } else {
            title.textAlignment = .left
        }
    }
    
    //MARK: config button
    
    private func setConfigButtons_MWP(){
// TEXT FOR FUNC REFACTOR
        self.purchaseBtn.delegate = self
        self.purchaseBtn.style = .native
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.purchaseBtn.setPulseAnimation_MWP()
        }
    }
    
    //MARK: config localization
    
    public func setLocalization_MWP() {
// TEXT FOR FUNC REFACTOR
//        title.labelTextsForSlider = "\(localizedString(forKey: "SliderID1").uppercased())|n\(localizedString(forKey: "SliderID2").uppercased())|n\(localizedString(forKey: "SliderID3").uppercased()) |n\(localizedString(forKey: "SliderID4").uppercased()) |n\(localizedString(forKey: "SliderID5").uppercased())"
        
        let description = localizedString(forKey: "iOSAfterID")
        let localizedPrice_MWP = inapp.localizedPrice_MWP()
        descriptLb.text = String(format: description, localizedPrice_MWP)
        
        if locale == "en" {
            starButton.isHidden = false
            trialLb.text = "Start 3-days for FREE\n Then \(localizedPrice_MWP)/week".uppercased()
        } else {
            starButton.isHidden = true
            trialLb.text = ""
        }
        privacyBtn.titleLabel?.lineBreakMode = .byWordWrapping
        privacyBtn.setAttributedTitle(localizedString(forKey: "TermsID").underLined, for: .normal)
        policyBtn.titleLabel?.lineBreakMode = .byWordWrapping
        policyBtn.setAttributedTitle(localizedString(forKey: "PrivacyID").underLined, for: .normal)
    }
    
    //MARK: screen configs
    
    private func configScreen_MWP(){
// TEXT FOR FUNC REFACTOR
        if isPad {
            trialWight.setValue(0.28, forKey: "multiplier")
            sliderWight.setValue(0.5, forKey: "multiplier")
        } else {
            trialWight.setValue(0.46, forKey: "multiplier")
            sliderWight.setValue(0.8, forKey: "multiplier")
        }
    }
    
    //MARK: configs
    
    private func configsInApp_MWP(){
// TEXT FOR FUNC REFACTOR
        self.inapp.transactionsDelegate = self
        self.networkingMonitor.delegate = self
    }
    
    public func restoreAction_MWP(){
// TEXT FOR FUNC REFACTOR
        self.transactionTreatment_MWP(title: NSLocalizedString("faledRestore", comment: ""), message: NSLocalizedString("notPurchases", comment: ""))
//        inapp.doRestore_MWP()
    }
    
    //MARK: actions
    
    @IBAction func privacyAction_MWP(_ sender: UIButton) {
// TEXT FOR FUNC REFACTOR
        self.delegate?.termsOpen()
    }
    
    @IBAction func termsAction_MWP(_ sender: UIButton) {
// TEXT FOR FUNC REFACTOR
        self.delegate?.privacyOpen()
    }
    
    func onClick_MWP() {
// TEXT FOR FUNC REFACTOR
        UIApplication.shared.impactFeedbackGenerator(type: .heavy)
//        networkingMonitor.startMonitoring_MWP()
        if NetworkStatusMonitor_MWP.shared.isNetworkAvailable {
            inapp.doPurchase_MWP()
            purchaseBtn.isUserInteractionEnabled = false
        } else {
            transactionTreatment_MWP(title: NSLocalizedString( "ConnectivityTitle", comment: ""), message: NSLocalizedString("ConnectivityDescription", comment: ""))
        }
    }
    
    //inapp
    
    func transactionTreatment_MWP(title: String, message: String) {
// TEXT FOR FUNC REFACTOR
        purchaseBtn.isUserInteractionEnabled = true
        self.delegate?.transactionTreatment_MWP(title: title, message: message)
    }
    
    func infoAlert_MWP(title: String, message: String) {
// TEXT FOR FUNC REFACTOR
        purchaseBtn.isUserInteractionEnabled = true
        self.delegate?.transactionTreatment_MWP(title: title, message: message)
    }
    
    func goToTheApp_MWP() {
// TEXT FOR FUNC REFACTOR
        purchaseBtn.isUserInteractionEnabled = true
        self.delegate?.userSubscribed()
    }
    
    func failed() {
// TEXT FOR FUNC REFACTOR
        purchaseBtn.isUserInteractionEnabled = true
        self.delegate?.transactionFailed()
    }
}
