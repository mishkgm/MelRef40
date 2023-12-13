import UIKit
import AVKit
import AVFoundation

enum PremiumMainController_MWPStyle {
    case mainProduct,unlockContentProduct,unlockFuncProduct,unlockOther
}

protocol PremiumMainController_MWPDelegate: AnyObject {
    func openApp_MWP()
    func funcBought()
    func contentBought()
}

class PremiumMainController_MWP: UIViewController {
    
    private weak var player: Player!
    private var view0 = ReusableView_MWP()
    private var view1 = ReusableView_MWP()
    private var viewTransaction = TransactionView_MWP()
    
    @IBOutlet private weak var freeform: UIView!
    @IBOutlet private weak var videoElement: UIView!
    @IBOutlet private weak var restoreBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    public var productBuy : PremiumMainController_MWPStyle = .mainProduct
    
    private var intScreenStatus = 0
    weak var delegate: PremiumMainController_MWPDelegate?
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        initVideoElement_MWP()
        startMaked()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        if !NetworkStatusMonitor_MWP.shared.isNetworkAvailable {
            showMess_MWP()
        }
        NetworkStatusMonitor_MWP.shared.delegate = self
    }
    
    deinit {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        deinitPlayer_MWP()
    }
    
    private func initVideoElement_MWP(){
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
            BGPlayer()
        }
    }
    
    
    //MARK: System events
    
    private func deinitPlayer_MWP() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        if let player {
          self.player.volume = 0
          self.player.url = nil
          self.player.didMove(toParent: nil)
        }
        player = nil
      }

    // MARK: - Setup Video Player

    private func BGPlayer() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        var pathUrl = Bundle.main.url(forResource: ConfigurationMediaSub_MWP.nameFileVideoForPhone, withExtension: ConfigurationMediaSub_MWP.videoFileType)
        if isPad {
            pathUrl = Bundle.main.url(forResource: ConfigurationMediaSub_MWP.nameFileVideoForPad, withExtension: ConfigurationMediaSub_MWP.videoFileType)
        }else{
            pathUrl = Bundle.main.url(forResource: ConfigurationMediaSub_MWP.nameFileVideoForPhone, withExtension: ConfigurationMediaSub_MWP.videoFileType)
        }

       let player = Player()
//        player.muted = true
        player.playerDelegate = self
        player.playbackDelegate = self
        player.view.frame = self.view.bounds

        addChild(player)
        view.addSubview(player.view)
        player.didMove(toParent: self)
        player.url = pathUrl
        if isPad {
            player.playerView.playerFillMode = .resizeAspectFill
        }else{
            player.playerView.playerFillMode = .resize
        }
        player.playbackLoops = true
        view.sendSubviewToBack(player.view)
        self.player = player
    }
    
    private func loopVideoMB(videoPlayer:AVPlayer){
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: .zero)
            videoPlayer.play()
        }
    }
    
    // MARK: - Make UI/UX
    
    private func startMaked() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        setRestoreBtn()
        if productBuy == .mainProduct {
            setReusable(config: .first, isHide: false)
            setReusable(config: .second, isHide: true)
            setTransaction(isHide: true)
        } else {
            setTransaction(isHide: false)
            self.showRestore()
        }
    }
    
    //reusable setup
    
    private func generateContentForView(config: configView_MWP) -> [ReusableContentCell_MWP] {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        var contentForCV : [ReusableContentCell_MWP] = []
        switch config {
        case .first:
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text1ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text2ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text3ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text4ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text5ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text1ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text2ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text3ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text4ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text5ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            return contentForCV
        case .second:
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text1ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text2ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text3ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text4ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text5ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text1ID"), image: UIImage(named: "2_1des")!, selectedImage: UIImage(named: "2_1sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text2ID"), image: UIImage(named: "2_2des")!, selectedImage: UIImage(named: "2_2sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text3ID"), image: UIImage(named: "2_3des")!, selectedImage: UIImage(named: "2_3sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text4ID"), image: UIImage(named: "2_4des")!, selectedImage: UIImage(named: "2_4sel")!))
            contentForCV.append(ReusableContentCell_MWP(title: localizedString(forKey:"Text5ID"), image: UIImage(named: "2_5des")!, selectedImage: UIImage(named: "2_5sel")!))
            return contentForCV
        case .transaction: return contentForCV
        }
    }
    
    private func setReusable(config : configView_MWP, isHide : Bool){
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        var currentView : ReusableView_MWP? = nil
        var viewModel : ReusableView_MWPModel? = nil
        switch config {
        case .first:
            viewModel =  ReusableView_MWPModel(title: localizedString(forKey: "TextTitle1ID").uppercased(), items: self.generateContentForView(config: config))
            currentView = self.view0
        case .second:
            viewModel =  ReusableView_MWPModel(title: localizedString(forKey: "TextTitle2ID").uppercased(), items: self.generateContentForView(config: config))
            currentView = self.view1
        case .transaction:
            currentView = nil
        }
        guard let i = currentView else { return }
        i.protocolElement = self
        i.viewModel = viewModel
        i.configView_MWP = config
        freeform.addSubview(i)
        freeform.bringSubviewToFront(i)
        
        i.snp.makeConstraints { make in
            make.height.equalTo(338)
            make.width.equalTo(freeform).multipliedBy(1)
            make.centerX.equalTo(freeform).multipliedBy(1)
            make.bottom.equalTo(freeform).offset(0)
        }
        i.isHidden = isHide
    }
    //transaction setup
    
    private func setTransaction( isHide : Bool) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        self.viewTransaction.inapp.productBuy = self.productBuy
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.viewTransaction.setLocalization_MWP()
        }
        freeform.addSubview(self.viewTransaction)
        freeform.bringSubviewToFront(self.viewTransaction)
        self.viewTransaction.inapp.productBuy = self.productBuy
        self.viewTransaction.snp.makeConstraints { make in
            //            make.height.equalTo(338)
            make.width.equalTo(freeform).multipliedBy(1)
            make.centerX.equalTo(freeform).multipliedBy(1)
            make.bottom.equalTo(freeform).offset(0)
        }
        self.viewTransaction.isHidden = isHide
        self.viewTransaction.delegate = self
    }
    
    // restore button setup
    
    private func setRestoreBtn(){
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        self.restoreBtn.isHidden = true
        self.restoreBtn.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        self.restoreBtn.setTitle(localizedString(forKey: "restore"), for: .normal)
        self.restoreBtn.titleLabel?.setShadow_MWP()
        self.restoreBtn.tintColor = .white
        self.restoreBtn.setTitleColor(.white, for: .normal)
    }
    
    private func openApp(){
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        if productBuy == .mainProduct {
            delegate?.openApp_MWP()
            let unsubscribedVC = LoadingBrownViewController_MWP()
            unsubscribedVC.modalPresentationStyle = .fullScreen
            let navVC = UINavigationController(rootViewController: unsubscribedVC)
            navVC.setNavigationBarHidden(true, animated: false)
            navVC.navigationBar.isHidden = true
            UIApplication.shared.setRootVC_MWP(navVC)
            
            deinitPlayer_MWP()
        } else {
            if productBuy == .unlockFuncProduct {
                delegate?.funcBought()
            } else {
                delegate?.contentBought()
            }
            self.dismiss(animated: true)
        }
    }
    
    private func showRestore(){
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        self.restoreBtn.isHidden = false
        if productBuy != .mainProduct {
            self.closeBtn.isHidden = false
        }
    }
    
    @IBAction func restoreAction_MWP(_ sender: UIButton) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        self.viewTransaction.restoreAction_MWP()
    }
    
    @IBAction func closeController(_ sender: UIButton) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        self.dismiss(animated: true)
    }
}

extension PremiumMainController_MWP : ReusableView_MWPEvent {
    func nextStep(config: configView_MWP) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        switch config {
        case .first:
            self.view0.fadeOut_MWP()
            self.view1.fadeIn_MWP()
            UIApplication.shared.impactFeedbackGenerator(type: .medium)
//            ThirdPartyServicesManager_.shared.makeATT()
        case .second:
            self.view1.fadeOut_MWP()
            self.viewTransaction.fadeIn_MWP()
            self.showRestore()
            //            self.viewTransaction.title.restartpageControl()
            UIApplication.shared.impactFeedbackGenerator(type: .medium)
        case .transaction: break
        }
    }
}

extension PremiumMainController_MWP: NetworkStatusMonitorDelegate_MWP {
    func showMess_MWP() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        IAPManager_MWP.shared.loadProductsFunc_MWP()
        transactionTreatment_MWP(title: NSLocalizedString( "ConnectivityTitle", comment: ""), message: NSLocalizedString("ConnectivityDescription", comment: ""))
    }
}

extension PremiumMainController_MWP : TransactionView_MWPEvents {
    
    func userSubscribed() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        self.openApp()
    }
    
    func transactionTreatment_MWP(title: String, message: String) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        UIApplication.shared.notificationFeedbackGenerator(type: .warning)
    }
    
    func transactionFailed() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        print(#function)
        UIApplication.shared.notificationFeedbackGenerator(type: .error)
    }
    
    func privacyOpen() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        Configurations_MWP.policyLink.openURL()
    }
    
    func termsOpen() {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
        Configurations_MWP.termsLink.openURL()
    }
}

extension PremiumMainController_MWP: PlayerDelegate_MWP, PlayerPlaybackDelegate_MWP {
    func playerReady(_ player: Player) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
    }

    func playerPlaybackStateDidChange(_ player: Player) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
    }

    func playerBufferingStateDidChange(_ player: Player) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
    }

    func playerBufferTimeDidChange(_ bufferTime: Double) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
    }

    func player(_ player: Player, didFailWithError error: Error?) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
    }

    func playerCurrentTimeDidChange(_ player: Player) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
    }

    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
    }

    func playerPlaybackDidEnd(_ player: Player) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
    }

    func playerPlaybackWillLoop(_ player: Player) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
    }

    func playerPlaybackDidLoop(_ player: Player) {
        for _ in "DOGS" {
            var d = 0
            if let inrail = String(1234) as? String {
                d += 1
            }
        };
    }
}

