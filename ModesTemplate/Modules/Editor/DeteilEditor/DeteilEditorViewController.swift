//
//  DeteilViewController.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 30.11.2023.
//

import Foundation
import UIKit

enum EditorViewType: String, CaseIterable {
    
    case first = "Misk templates"
    case second = "Set soliders"
    case third = "Select texture"
    case fourth = "Set propetries"
    
    var cells: [EditorCellType] {
        switch self {
        case .first:
            return [.name, .icon, .fields]
        case .second:
            return [.titalCell, .coordinatesX, .coordinatesW]
        case .third:
            return [.titalCell, .slider]
        case .fourth:
            return [.titalCell, .switchCell]
        }
    }
}

final class DeteilEditorViewController: BaseViewController {
    
    lazy var mainView: DeteilEditorView = {
       var view = DeteilEditorView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.selectorColletion.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openСategoryPicker))
        view.selectorColletion.addGestureRecognizer(gesture)
        return view
    }()
    
    var viewModel: DeteilEditorViewModel
    private var currentItem: EditorViewType = .first
    
    init(objct: RealmEditorDeteilModel) {
        viewModel = DeteilEditorViewModel(object: objct)
        super.init(controllerType: .mods)
        viewModel.delegate = self
        setupImage()
    }
    
    convenience init(imageData: Data, title: String) {
        self.init(objct: RealmEditorDeteilModel(name: title, imageData: imageData, type: "type", category: "category", xValue: "0.0", yValue: "0.0", heightValue: "0.0", widthValue: "0.0", pixelValue: "0", canBeTaken: false, canGlow: false, canBurn: false, canFloat: false))
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
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeCategoryPicker))
        self.view.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
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
        let alert = UIAlertController(title: "Are you sure?", message: "Are your sure u want to leave with no saving?", preferredStyle: .alert)
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
        let alert = UIAlertController(title: "Nothing to save", message: "Are your sure u want to leave?", preferredStyle: .alert)
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
}

// MARK: - Selector CollectionView
extension DeteilEditorViewController: DropDownMenuDelegate {
    func cellDidTap(index: Int) {
        self.currentItem = EditorViewType.allCases[index]
        self.reloadData()
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
        return isPad ? currentItem.cells[indexPath.row].heightForRow * 1.6 : currentItem.cells[indexPath.row].heightForRow
    }
}

// MARK: - UISetup
private extension DeteilEditorViewController {
    
    func nameFieldEmty() {
        self.cellDidTap(index: 0)
        guard let cell = self.mainView.tableView.visibleCells.first as? NameTextFieldCell<EditorCellType> else { return
        }
        cell.textField.becomeFirstResponder()
    }
    
    func reloadData() {
        setupImage()
        self.mainView.selectorColletion.closeCategoryPicker(currentItem: currentItem.rawValue)
        self.mainView.tableView.reloadData()
    }
    
    func setupImage() {
        mainView.imageView.image = UIImage(data: viewModel.object.imageData)
    }
    
    func setupNavBar() {
        makeBackButton()
        self.title = "Editor"
        self.navigationItem.rightBarButtonItem = createButton(image: AppConfig.Icons.saveicon, action: #selector(saveMod))
        let backButton = createButton(image: AppConfig.Icons.backButton, action: #selector(self.backButton))
        
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    @objc func openСategoryPicker() {
        self.mainView.selectorColletion.openСategoryPicker(items: EditorViewType.allCases.map { $0.rawValue })
    }
    
    @objc func closeCategoryPicker() {
        self.mainView.endEditing(true)
        self.mainView.selectorColletion.closeCategoryPicker(currentItem: currentItem.rawValue)
    }
}
