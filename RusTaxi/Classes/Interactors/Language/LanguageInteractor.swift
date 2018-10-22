//
//  LanguageHelper.swift
//  Eduson
//
//  Created by Danil Detkin on 09/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation


final class LanguageHelper {
	static var preferedLanguage: String {
		return Locale.current.languageCode ?? "ru"
	}
}
