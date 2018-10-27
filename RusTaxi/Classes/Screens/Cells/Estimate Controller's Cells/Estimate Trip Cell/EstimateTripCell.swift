//
//  EstimateTripCell.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 12.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class EstimateTripCell: UITableViewCell {
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var firstStarButton: UIButton!
	@IBOutlet weak var secondStarButton: UIButton!
	@IBOutlet weak var threeButtonStar: UIButton!
	@IBOutlet weak var fourButtonStar: UIButton!
	@IBOutlet weak var fiveButtonStar: UIButton!
	
	func configure(by result: EstimateResult) {
		clearStars()
		switch result {
		case .negative(let stars):
			switch stars {
			case 1:
				firstStarButton.setImage(Image.activeStar, for: .normal)
			case 2:
				firstStarButton.setImage(Image.activeStar, for: .normal)
				secondStarButton.setImage(Image.activeStar, for: .normal)
			case 3:
				firstStarButton.setImage(Image.activeStar, for: .normal)
				secondStarButton.setImage(Image.activeStar, for: .normal)
				threeButtonStar.setImage(Image.activeStar, for: .normal)
				default: break
			}
		case .positive(let stars):
			switch stars {
			case 4:
				firstStarButton.setImage(Image.activeStar, for: .normal)
				secondStarButton.setImage(Image.activeStar, for: .normal)
				threeButtonStar.setImage(Image.activeStar, for: .normal)
				fourButtonStar.setImage(Image.activeStar, for: .normal)
			case 5:
				firstStarButton.setImage(Image.activeStar, for: .normal)
				secondStarButton.setImage(Image.activeStar, for: .normal)
				threeButtonStar.setImage(Image.activeStar, for: .normal)
				fourButtonStar.setImage(Image.activeStar, for: .normal)
				fiveButtonStar.setImage(Image.activeStar, for: .normal)
			default: break
			}
		}
	}
	
	private func clearStars() {
		[firstStarButton, secondStarButton, threeButtonStar, fourButtonStar, fiveButtonStar].forEach{$0?.setImage(Image.grayStar, for: .normal)}
	}
}

extension EstimateTripCell {
	fileprivate class Image {
		static let activeStar = UIImage.init(named: "activStar")!
		static let grayStar = UIImage.init(named: "star")!
	}
}
