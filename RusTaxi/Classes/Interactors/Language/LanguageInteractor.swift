//
//  LanguageHelper.swift
//  Eduson
//
//  Created by Danil Detkin on 09/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation
import ObjectiveC

private var associatedLanguageBundle:Character = "0"

class PrivateBundle: Bundle {
	override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
		let bundle: Bundle? = objc_getAssociatedObject(self, &associatedLanguageBundle) as? Bundle
		return (bundle != nil) ? (bundle!.localizedString(forKey: key, value: value, table: tableName)) : (super.localizedString(forKey: key, value: value, table: tableName))
		
	}
}

extension Bundle {
	class func setLanguage(_ language: String) {
		var onceToken: Int = 0
		
		if (onceToken == 0) {
			/* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
			object_setClass(Bundle.main, PrivateBundle.self)
		}
		onceToken = 1
		objc_setAssociatedObject(Bundle.main, &associatedLanguageBundle, (language != nil) ? Bundle(path: Bundle.main.path(forResource: language, ofType: "lproj") ?? "") : nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}
}

final class LanguageHelper {
	static var preferedLanguage: String {
		let lang: String? = {
			guard let l = UserDefaultsManager.shared.language else {
				return nil
			}
			
			switch l {
			case SettingsItemCell.Language.russian.rawValue:
				return "ru"
			case SettingsItemCell.Language.english.rawValue:
				return "en"
			default:
				return nil
			}
		}()
		return lang ?? Locale.current.languageCode ?? "ru"
	}
}
