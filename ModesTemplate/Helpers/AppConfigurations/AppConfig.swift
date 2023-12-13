//
//  AppConfig.swift
//  ModesTemplate
//
//  Created by evhn on 28.11.2023.
//

import UIKit


enum AppConfig {
    
    //MARK: -  Colors
    struct Colors {
        
        // Menu
        static let backgound = UIColor.clear
        static let labelTextColor = UIColor.white
        static let isUnselectedCategory = #colorLiteral(red: 0.2714084983, green: 0.4273136854, blue: 0.3375319242, alpha: 1)
        
        // General
        static let titleViewControllerColor = UIColor.white
        static let gradientColors = [
            UIColor(red: 0.721, green: 0.721, blue: 0.721, alpha: 1),
            UIColor(red: 0.458, green: 0.458, blue: 0.458, alpha: 1),
            UIColor(red: 0.633, green: 0.633, blue: 0.633, alpha: 1),
            UIColor(red: 0.375, green: 0.375, blue: 0.375, alpha: 1)
        ]
        static let mainTextColor = UIColor.white
        static let tableViewSeparatorColor = UIColor.clear
        static let cellBackgroundColor = UIColor(hex: "#242528")
        static let cellBorderColor = UIColor.white
//        UIColor(hex: "#BCC5C9")
        static let titlesColor = UIColor.white
        static let descriptionsColor = UIColor.white.withAlphaComponent(0.7)
        static let imagesBackgoundColor = UIColor(red: 0.26, green: 0.33, blue: 0.35, alpha: 1)
        
        // Delete
        static let deleteBackground = UIColor(red: 0.241, green: 0.247, blue: 0.267, alpha: 1)
        static let destructiveColor = #colorLiteral(red: 0.6304040551, green: 0.2612381577, blue: 0.2590059042, alpha: 1)
        static let cancelColor = #colorLiteral(red: 0.5960784554, green: 0.5960784554, blue: 0.5960784554, alpha: 1)
        
        static let deteilModsbuttonBackground = UIColor(red: 0.241, green: 0.247, blue: 0.267, alpha: 1)
        static let startEditBackground = UIColor(red: 0.941, green: 0.816, blue: 0.271, alpha: 1)
        static let startEditForeground = UIColor(red: 0.241, green: 0.247, blue: 0.267, alpha: 1)
        
        // Editor
        static let editorSelectorBackground = UIColor(hex: "#242528")
        static let editorSelectorBorder = UIColor(hex: "#BCC5C9")
        static let editorCellBackground = UIColor(hex: "#242528")
        
        // Skins
        static let buttonsColors = UIColor(hex: "#F0D045")
    }
    //MARK: -  Icons
    
    struct Icons {
        // General
        static let background = UIImage(named: "background")
        static let backButton = UIImage(named: "back_image")
        
        // Favourite
        static let checkmark = UIImage(named: "checkmark")
        static let favoritesFill = UIImage(named: "favorites_fill")
        static let favoritesEmpty = UIImage(named: "favorites_empty")
        static let favoriteFilterIcon = UIImage(named: "favorite_filter_icon")
        
        static let saveicon = UIImage(named: "save_icon")
        
        static let privacyPolicyicon = UIImage(named: "privacy")
        static let termsOfUse = UIImage(named: "terms")
        
        static let dropArrowRight = UIImage(named: "drop_arrow")
        
        static let startEditIcon = UIImage(named: "start_edit_icon")
        static let shareIcon = UIImage(named: "share_icon")
        // Baner
        static let bannerFirstImage = UIImage(named: "first_banner")
        static let bannerSecondImage = UIImage(named: "second_banner")
        static let thirdBannerImage = UIImage(named: "third_banner")
        
        // Editor
        static let editorMisc = UIImage(named: "editor_misc")
        static let editorLiving = UIImage(named: "editor_living")
        
        // Menu
        static let menuGradient = UIImage(named: "menu_gradien")
        
        // MyWorks
        static let editIcon = UIImage(named: "edit")
        static let binIcon = UIImage(named: "bin")
        static let myWorks = UIImage(named: "myWorks")
        
        // Mods
        static let categoryChevron = UIImage(named: "chevron_left")
        static let searchImage = UIImage(named: "search")
        static let crossButton = UIImage(named: "cross")
        static let lockIcon = UIImage(named: "lock")
    }
}
