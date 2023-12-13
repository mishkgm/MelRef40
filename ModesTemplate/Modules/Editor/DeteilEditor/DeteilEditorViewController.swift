//
//  DeteilViewController.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

enum EditorViewType: String, CaseIterable {
    
    case first = "Misс templates"
    case second = "Set solliders"
    case third = "Select texture"
    case fourth = "Set properties"
    
    var cells: [EditorCellType] {
        switch self {
        case .first:
            return [.name, .icon, .fields]
        case .second:
            return [.coordinatesX, .coordinatesW]
        case .third:
            return [.slider]
        case .fourth:
            return [.switchCell]
        }
    }
}

final class DeteilEditorViewController: BaseViewController {
    
    lazy var mainView: DeteilEditorView = {
       var view = DeteilEditorView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.selectorColletion.delegate = self
        view.selectorColletion.dataSource = self
        view.bannerView.subDelegate = self
        return view
    }()
    
    var titleHeader: String = "Editor"
    var viewModel: DeteilEditorViewModel
    private var currentItem: EditorViewType = .first
    private var isAlreadyUp: Bool = false
    
    init(objct: RealmEditorDeteilModel, title: String) {
        viewModel = DeteilEditorViewModel(object: objct)
        super.init(controllerType: .mods)
        self.titleHeader = title
        viewModel.delegate = self
        setupImage()
    }
    
    convenience init(imageData: Data, title: String) {
        self.init(objct: RealmEditorDeteilModel(name: title, imageData: imageData, type: "type", category: "category", xValue: "0.0", yValue: "0.0", heightValue: "0.0", widthValue: "0.0", pixelValue: "0", canBeTaken: false, canGlow: false, canBurn: false, canFloat: false), title: "Editor")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        if mainView.bannerView.isHidden == false {
            IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(DeteilEditorViewController.self)
        } else {
            IQKeyboardManager.shared.disabledDistanceHandlingClasses.removeAll()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    @objc func goBackground() {
        self.mainView.endEditing(true)
    }
    
    @objc func setupIcon() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func saveMod() {
        viewModel.saveMod()
    }
    
    @objc func backButton() {
        saveChangesAlert()
    }
}

// MARK: - ImagePickerDelegate
extension DeteilEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            switch currentItem {
            case .first:
                self.viewModel.updateIcon(data: image.jpegData(compressionQuality: 0.5))
            case .third:
                self.viewModel.updateImage(data: image.jpegData(compressionQuality: 0.5))
            default: break
            }
            self.reloadData()
        }
    }
}

// MARK: - Alerts
extension DeteilEditorViewController: DeteilEditorViewModelDelegate {
    func saveAction() {
        CompleteView.shared.showWithBlurEffect(completeStyle: .saved)
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveChangesAlert() {
        let alert = UIAlertController(title: "Are you sure?", message: "Are your sure you want to leave with no saving?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            self.saveMod()
        }
        alert.addAction(okAction)
        alert.addAction(save)
        self.present(alert, animated: true)
    }
    
    func nothingToSave() {
        let alert = UIAlertController(title: "Nothing to save", message: "Are your sure you want to leave?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        let back = UIAlertAction(title: "back", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        alert.addAction(back)
        self.present(alert, animated: true)
    }
    
    func showNoNameAlert() {
        let alert = UIAlertController(title: "Can’t save mod without name", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        let enterName = UIAlertAction(title: "Enter name", style: .default) { _ in
            self.nameFieldEmty()
        }
        alert.addAction(okAction)
        alert.addAction(enterName)
        self.mainView.endEditing(true)
        self.present(alert, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if currentItem == .first && mainView.bannerView.isHidden == false {
            guard !isAlreadyUp else { return }
            isAlreadyUp = true
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
                UIView.animate(withDuration: animationDuration) {
                    // Поднимаем ваше представление вверх на высоту клавиатуры
                    let popUpY = self.mainView.frame.minY
                    self.mainView.transform = CGAffineTransform(translationX: 0, y: popUpY - keyboardSize.height)
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if currentItem == .first && mainView.bannerView.isHidden == false {
            
            isAlreadyUp = false
            let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
            UIView.animate(withDuration: animationDuration) {
                // Возвращаем ваше представление в исходное положение
                self.mainView.transform = .identity
            }
        }
    }
}

// MARK: - TableView
extension DeteilEditorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentItem.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: currentItem.cells[indexPath.row].cell.cellIdentifier(), for: indexPath) as? EditorCell else { return UITableViewCell() }
        cell.configure(object: viewModel.object)
        cell.openImagePicker = { [weak self] in
            self?.setupIcon()
        }
        cell.endEditing(true)
        cell.selectionStyle = .none
        cell.layoutSubviews()
        cell.updater = viewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isPad ? currentItem.cells[indexPath.row].heightForRow * 1.4 : currentItem.cells[indexPath.row].heightForRow
    }
}

// MARK: - UICollectionView
extension DeteilEditorViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        EditorViewType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesViewCell.cellIdentifier(), for: indexPath) as? CategoriesViewCell else { return UICollectionViewCell() }
        cell.configureCell(item: EditorViewType.allCases[indexPath.row].rawValue, isLoked: false, isSelected: currentItem == EditorViewType.allCases[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 && mainView.bannerView.isHidden == false {
            IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(DeteilEditorViewController.self)
        } else {
            IQKeyboardManager.shared.disabledDistanceHandlingClasses.removeAll()
        }
        self.currentItem = EditorViewType.allCases[indexPath.row]
        self.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.height - 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: isPad ? 60 : 20, bottom: 0, right: isPad ? 60 : 20)
    }
}

// MARK: - UISetup
private extension DeteilEditorViewController {
    
    func nameFieldEmty() {
        self.collectionView(self.mainView.selectorColletion, didSelectItemAt: IndexPath(row: 0, section: 0))
        guard let cell = self.mainView.tableView.visibleCells.first as? NameTextFieldCell<EditorCellType> else { return
        }
        cell.textField.becomeFirstResponder()
    }
    
    func reloadData() {
        setupImage()
        self.mainView.selectorColletion.reloadData()
        self.mainView.tableView.reloadData()
    }
    
    func setupImage() {
        mainView.imageView.image = UIImage(data: viewModel.object.imageData)
    }
    
    func setupNavBar() {
        makeBackButton()
        self.title = titleHeader
        self.navigationItem.rightBarButtonItems = createButton(config: [(AppConfig.Icons.saveicon, #selector(saveMod))])
        let backButton = createButton(config: [(AppConfig.Icons.backButton, #selector(self.backButton))])
        
        self.navigationItem.leftBarButtonItems = backButton
        
    }
}
