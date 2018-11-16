//
//  LanguageHelper.swift
//  Eduson
//
//  Created by Danil Detkin on 09/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

private let appleLanguagesKey = "AppleLanguages"

enum Language: String {
	
	case defaultLang = "Default"
	case english = "English"
	case russian = "Russian"
	case chinese = "Chinese"
	case azer = "Azebaijani"
	//			alertController.addAction(englishLanguageAction)
	//			alertController.addAction(russianLanguageAction)
	//			alertController.addAction(chineseLanguageAction)
	//			alertController.addAction(azerbaijaniLanguageAction)
	static var language: Language {
		get {
			if let languageCode = UserDefaults.standard.string(forKey: appleLanguagesKey),
				let language = Language(rawValue: languageCode) {
				return language
			} else {
				let preferredLanguage = NSLocale.preferredLanguages[0] as String
				let index = preferredLanguage.index(
					preferredLanguage.startIndex,
					offsetBy: 2
				)
				guard let localization = Language(
					rawValue: preferredLanguage.substring(to: index)
					) else {
						return Language.english
				}
				
				return localization
			}
		}
		set {
			guard language != newValue else {
				return
			}
			
			//change language in the app
			//the language will be changed after restart
			UserDefaults.standard.set([newValue.rawValue], forKey: appleLanguagesKey)
			UserDefaults.standard.synchronize()
			
			//Changes semantic to all views
			//this hack needs in case of languages with different semantics: leftToRight(en/uk) & rightToLeft(ar)
			
			//initialize the app from scratch
			//show initial view controller
			//so it seems like the is restarted
			//NOTE: do not localize storboards
			//After the app restart all labels/images will be set
			//see extension String below
			
		}
	}
}


extension String {
	
	var localized: String {
		return Bundle.localizedBundle.localizedString(forKey: self, value: nil, table: nil)
	}
}

extension Bundle {
	//Here magic happens
	//when you localize resources: for instance Localizable.strings, images
	//it creates different bundles
	//we take appropriate bundle according to language
	static var localizedBundle: Bundle {
		let languageCode = Language.language.rawValue
		guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
			return Bundle.main
		}
		return Bundle(path: path)!
	}
}
