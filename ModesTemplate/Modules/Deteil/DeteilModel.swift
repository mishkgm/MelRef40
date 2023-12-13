//
//  DeteilModel.swift
//  ModesTemplate
//
//  Created by Данил Веланський on 29.11.2023.
//

import Foundation
import UIKit

struct DeteilModel {
    var title: String
    var description: String
    var image: UIImage?
    var downloadPath: String
    var isFavourite: Bool = false
    var realmKey: String = ""
    var imagePath: String = ""
}
