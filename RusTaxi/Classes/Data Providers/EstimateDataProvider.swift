//
//  EstimateDataProvider.swift
//  RusTaxi
//
//  Created by Danil Detkin on 21/10/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import Foundation

class EstimateDataProvider {
	static let shared = EstimateDataProvider()
	private(set) var result: EstimateResult = .positive(0)
	
	var rating: Int {
		switch result {
		case .positive(let stars):
			return stars
		case .negative(let stars):
			return stars
		}
	}
	var comment: String = ""
	func set(stars: Int) {
		if stars <= 3 {
			// negative
			result = EstimateResult.negative(stars)
		} else {
			// positive
			result = EstimateResult.positive(stars)
		}
	}
}

enum EstimateResult {
	case positive(_ stars: Int)
	case negative(_ stars: Int)
}
