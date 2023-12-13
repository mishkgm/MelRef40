//  Created by Melnykov Valerii on 14.07.2023
//


import UIKit

enum configView_MWP {
    case first,second,transaction
}

protocol ReusableView_MWPEvent : AnyObject {
    func nextStep(config: configView_MWP)
}

struct ReusableView_MWPModel {
    var title : String
    var items : [ReusableContentCell_MWP]
}

struct ReusableContentCell_MWP {
    var title : String
    var image : UIImage
    var selectedImage: UIImage
}

class ReusableView_MWP: UIView, AnimatedButton_MWPEvent {
    func onClick_MWP() {
// TEXT FOR FUNC REFACTOR
        self.protocolElement?.nextStep(config: self.configView_MWP)
    }
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var content: UICollectionView!
    @IBOutlet private weak var nextStepBtn: AnimatedButton_MWP!
    @IBOutlet private weak var titleWight: NSLayoutConstraint!
    @IBOutlet private weak var buttonBottom: NSLayoutConstraint!
    
    weak var protocolElement : ReusableView_MWPEvent?
    
    public var configView_MWP : configView_MWP = .first
    public var viewModel : ReusableView_MWPModel? = nil
    private let cellName = "ReusableCell_MWP"
    private var selectedStorage : [Int] = []
    private let multic: CGFloat = 0.94
    private let xib = "ReusableView_MWP"
    
 
    
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
                // Устройство без физической кнопки "Home" (например, iPhone X и новее)
            } else {
                // Устройство с физической кнопкой "Home"
                buttonBottom.constant = 47
            }
        } else {
            buttonBottom.constant = 63
        }

        contentView.fixInView_MWP(self)
        nextStepBtn.delegate = self
        nextStepBtn.style = .native
        contentView.backgroundColor = .clear
        setContent_MWP()
        setConfigLabels_MWP()
        configScreen_MWP()
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            let layout = RTLSupportedCollectionViewFlowLayout_MWP()
            layout.scrollDirection = .horizontal
            content.collectionViewLayout = layout
        }
    }
    
    private func setContent_MWP(){
// TEXT FOR FUNC REFACTOR
        content.dataSource = self
        content.delegate = self
        content.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        content.backgroundColor = .clear
//        UIView.appearance().semanticContentAttribute = .forceLeftToRight
    }
    
    private func setConfigLabels_MWP(){
// TEXT FOR FUNC REFACTOR
        titleLb.setShadow_MWP()
        
        titleLb.textColor = .white
        titleLb.font = UIFont(name: Configurations_MWP.fontName, size: 24)
//        titleLb.lineBreakMode = .byWordWrapping
        titleLb.adjustsFontSizeToFitWidth = true
    }
    
    public func setConfigView_MWP(config: configView_MWP) {
// TEXT FOR FUNC REFACTOR
        self.configView_MWP = config
    }
    
    private func setLocalizable_MWP(){
// TEXT FOR FUNC REFACTOR
        self.titleLb.text = viewModel?.title
    }
    
    //MARK: screen configs
    
    private func configScreen_MWP(){
// TEXT FOR FUNC REFACTOR
        if isPad {
            titleWight.setValue(0.35, forKey: "multiplier")
        } else {
            titleWight.setValue(0.7, forKey: "multiplier")
        }
    }
    
    private func getLastElement_MWP() -> Int {
// TEXT FOR FUNC REFACTOR
        return (viewModel?.items.count ?? 0) - 1
    }
}

extension ReusableView_MWP : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
// TEXT FOR FUNC REFACTOR
        setLocalizable_MWP()
        return viewModel?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
// TEXT FOR FUNC REFACTOR
        let cell = content.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! ReusableCell_MWP
        let content = viewModel?.items[indexPath.item]
        cell.cellLabel.text = content?.title.uppercased()
        if selectedStorage.contains(where: {$0 == indexPath.item}) {
            cell.imageLabel.text = "AKTIV CARD"
            cell.cellLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            cell.imageLabel.textColor = UIColor(red: 0.446, green: 0.446, blue: 0.446, alpha: 1)
            cell.imageLabel.font = UIFont(name: Configurations_MWP.fontName, size: 20)
//            cell.cellImage.image = content?.selectedImage
            cell.contentContainer.backgroundColor = #colorLiteral(red: 0.7372549176, green: 0.7372549176, blue: 0.7372549176, alpha: 1)
            cell.cellLabel.font = UIFont(name: Configurations_MWP.fontName, size: 12)
            cell.imageLabel.setShadow_MWP(with: 0.25)
            cell.cellLabel.setShadow_MWP(with: 0.25)
        } else {
            cell.imageLabel.text = "INAKTIV CARD"
            cell.cellLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
//            cell.cellImage.image = content?.image
            cell.imageLabel.textColor = UIColor(red: 0.446, green: 0.446, blue: 0.446, alpha: 0.5)
            cell.contentContainer.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1)
            cell.imageLabel.font = UIFont(name: Configurations_MWP.fontName, size: 14)
            cell.cellLabel.font = UIFont(name: Configurations_MWP.fontName, size: 10)
            cell.imageLabel.setShadow_MWP(with: 0.5)
            cell.cellLabel.setShadow_MWP(with: 0.5)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
// TEXT FOR FUNC REFACTOR
        if selectedStorage.contains(where: {$0 == indexPath.item}) {
            selectedStorage.removeAll(where: {$0 == indexPath.item})
        } else {
            selectedStorage.append(indexPath.row)
        }
        
       
        UIApplication.shared.impactFeedbackGenerator(type: .light)
        collectionView.reloadData()
        collectionView.performBatchUpdates(nil, completion: nil)
        if indexPath.last == getLastElement_MWP() {
            collectionView.scrollToLastItem_MWP(animated: false)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
// TEXT FOR FUNC REFACTOR
        return selectedStorage.contains(indexPath.row) ? CGSize(width: collectionView.frame.height * 0.8, height: collectionView.frame.height) : CGSize(width: collectionView.frame.height * 0.7, height: collectionView.frame.height * 0.85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
// TEXT FOR FUNC REFACTOR
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
// TEXT FOR FUNC REFACTOR
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
// TEXT FOR FUNC REFACTOR
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    
}

class RTLSupportedCollectionViewFlowLayout_MWP: UICollectionViewFlowLayout {

    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }
}
