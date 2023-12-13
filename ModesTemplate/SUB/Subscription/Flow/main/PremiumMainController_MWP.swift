import UIKit
import AVKit
import AVFoundation

enum PremiumMainController_MWPStyle: CaseIterable {
    case mainProduct,unlockContentProduct,unlockFuncProduct,unlockOther
}

protocol PremiumMainController_MWPDelegate: AnyObject {
    func openApp_MWP()
    func funcBought()
    func contentBought()
    func otherBought()
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
// TEXT FOR FUNC REFACTOR
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
// TEXT FOR FUNC REFACTOR
        initVideoElement_MWP()
        startMaked()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
// TEXT FOR FUNC REFACTOR
        if !NetworkStatusMonitor_MWP.shared.isNetworkAvailable {
            statusChanged()
        }
        NetworkStatusMonitor_MWP.shared.delegate = self
    }
    
    deinit {
// TEXT FOR FUNC REFACTOR
        deinitPlayer_MWP()
    }
    
    private func initVideoElement_MWP(){
// TEXT FOR FUNC REFACTOR
        DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
            BGPlayer()
        }
    }
    
    
    //MARK: System events
    
    private func deinitPlayer_MWP() {
// TEXT FOR FUNC REFACTOR
          self.player.volume = 0
          self.player.url = nil
          self.player.didMove(toParent: nil)
        player = nil
      }

    // MARK: - Setup Video Player

    private func BGPlayer() {
// TEXT FOR FUNC REFACTOR
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
// TEXT FOR FUNC REFACTOR
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: .zero)
            videoPlayer.play()
        }
    }
    
    // MARK: - Make UI/UX
    
    private func startMaked() {
// TEXT FOR FUNC REFACTOR
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
// TEXT FOR FUNC REFACTOR
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
// TEXT FOR FUNC REFACTOR
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
// TEXT FOR FUNC REFACTOR
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
// TEXT FOR FUNC REFACTOR
        self.restoreBtn.isHidden = true
        self.restoreBtn.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        self.restoreBtn.setTitle(localizedString(forKey: "restore"), for: .normal)
        self.restoreBtn.titleLabel?.setShadow_MWP()
        self.restoreBtn.tintColor = .white
        self.restoreBtn.setTitleColor(.white, for: .normal)
    }
    
    private func openApp(){
// TEXT FOR FUNC REFACTOR
        switch productBuy {
        case .mainProduct:
            delegate?.openApp_MWP()
        case .unlockContentProduct:
            delegate?.contentBought()
            self.dismiss(animated: true)
        case .unlockFuncProduct:
            delegate?.funcBought()
            self.dismiss(animated: true)
        case .unlockOther:
            delegate?.otherBought()
            self.dismiss(animated: true)
        }
    }
    
    private func showRestore(){
// TEXT FOR FUNC REFACTOR
        self.restoreBtn.isHidden = false
        if productBuy != .mainProduct {
            self.closeBtn.isHidden = false
        }
    }
    
    @IBAction func restoreAction_MWP(_ sender: UIButton) {
// TEXT FOR FUNC REFACTOR
        DispatchQueue.main.async {
            self.viewTransaction.restoreAction_MWP()
        }
    }
    
    @IBAction func closeController(_ sender: UIButton) {
// TEXT FOR FUNC REFACTOR
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
}

extension PremiumMainController_MWP : ReusableView_MWPEvent {
    func nextStep(config: configView_MWP) {
// TEXT FOR FUNC REFACTOR
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
    func statusChanged() {
        IAPManager_MWP.shared.loadProductsFunc_MWP()
        transactionTreatment_MWP(title: NSLocalizedString( "ConnectivityTitle", comment: ""), message: NSLocalizedString("ConnectivityDescription", comment: ""))
    }
}

extension PremiumMainController_MWP : TransactionView_MWPEvents {
    
    func userSubscribed() {
// TEXT FOR FUNC REFACTOR
        self.openApp()
    }
    
    func transactionTreatment_MWP(title: String, message: String) {
// TEXT FOR FUNC REFACTOR
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            UIApplication.shared.notificationFeedbackGenerator(type: .warning)
        }
    }
    
    func transactionFailed() {
// TEXT FOR FUNC REFACTOR
        print(#function)
        UIApplication.shared.notificationFeedbackGenerator(type: .error)
    }
    
    func privacyOpen() {
// TEXT FOR FUNC REFACTOR
        Configurations_MWP.policyLink.openURL()
    }
    
    func termsOpen() {
// TEXT FOR FUNC REFACTOR
        Configurations_MWP.termsLink.openURL()
    }
}

extension PremiumMainController_MWP: PlayerDelegate_MWP, PlayerPlaybackDelegate_MWP {
    func playerReady(_ player: Player) {
// TEXT FOR FUNC REFACTOR
    }

    func playerPlaybackStateDidChange(_ player: Player) {
// TEXT FOR FUNC REFACTOR
    }

    func playerBufferingStateDidChange(_ player: Player) {
// TEXT FOR FUNC REFACTOR
    }

    func playerBufferTimeDidChange(_ bufferTime: Double) {
// TEXT FOR FUNC REFACTOR
    }

    func player(_ player: Player, didFailWithError error: Error?) {
// TEXT FOR FUNC REFACTOR
    }

    func playerCurrentTimeDidChange(_ player: Player) {
// TEXT FOR FUNC REFACTOR
    }

    func playerPlaybackWillStartFromBeginning(_ player: Player) {
// TEXT FOR FUNC REFACTOR
    }

    func playerPlaybackDidEnd(_ player: Player) {
// TEXT FOR FUNC REFACTOR
    }

    func playerPlaybackWillLoop(_ player: Player) {
// TEXT FOR FUNC REFACTOR
    }

    func playerPlaybackDidLoop(_ player: Player) {
// TEXT FOR FUNC REFACTOR
    }
}

