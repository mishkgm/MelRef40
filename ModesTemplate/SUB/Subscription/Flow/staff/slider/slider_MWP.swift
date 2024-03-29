import Foundation
import UIKit

class SliderCellView_MWP: UIView {
    
    private var fontName: String = Configurations_MWP.fontName
    private var textColot: UIColor = UIColor.white
    
    lazy var titleLabel: UILabel = {
       var label = UILabel()
        label.font = UIFont(name: fontName, size: 12)
        label.textColor = textColot
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            label.textAlignment = .right
        } else {
            label.textAlignment = .left
        }
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
       var label = UILabel()
        label.font = UIFont(name: fontName, size: 12)
        label.textColor = textColot
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            label.textAlignment = .right
        } else {
            label.textAlignment = .left
        }
        return label
    }()
    
    lazy var starIcon: UIImageView = {
       var image = UIImageView()
        image.image = UIImage(named: "star")
        image.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        return image
    }()
    
    lazy var stackView: UIStackView = {
       var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    convenience init(title: String, subTitle: String) {
        self.init()
// TEXT FOR FUNC REFACTOR
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
// TEXT FOR FUNC REFACTOR
        configureView_MWP()
        makeConstraints_MWP()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
// TEXT FOR FUNC REFACTOR
    }
    
    func configureView_MWP() {
// TEXT FOR FUNC REFACTOR
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        addSubview(starIcon)
    }
    
    func makeConstraints_MWP() {
// TEXT FOR FUNC REFACTOR
        starIcon.snp.remakeConstraints { make in
//            make.height.equalTo(50)
            make.width.equalTo(starIcon.snp.height)
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        stackView.snp.remakeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(starIcon.snp_trailingMargin).offset(10)
        }
    }
}
