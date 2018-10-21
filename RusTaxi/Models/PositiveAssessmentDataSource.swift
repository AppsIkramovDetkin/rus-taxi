//
//  PositiveAssessmentDataSource.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 12.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class PositiveAssessmentDataSource: NSObject, MainDataSource {
	var scrollViewScrolled: ScrollViewClosure?
	var assessmentClicked: ItemClosure<Int>?
	var viewController: UIViewController?
	private let result: EstimateResult
	private let response: CheckOrderModel
	func update(with models: [Any]) {}
	
	init(result: EstimateResult, response: CheckOrderModel) {
		self.result = result
		self.response = response
	}
	
	@objc private func firstStarClicked() {
		assessmentClicked?(1)
	}
	
	@objc private func secondStarClicked() {
		assessmentClicked?(2)
	}
	
	@objc private func thirdStarClicked() {
		assessmentClicked?(3)
	}
	
	@objc private func fourStarClicked() {
		assessmentClicked?(4)
	}
	
	@objc private func fiveStarClicked() {
		assessmentClicked?(5)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as! TripDetailsCell
			cell.configure(by: response)
			cell.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
			return cell
		} else if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "estimatedCell", for: indexPath) as! EstimateTripCell
			cell.configure(by: result)
			cell.label.text = "Оцените работу"
			cell.firstStarButton.addTarget(self, action: #selector(firstStarClicked), for: .touchUpInside)
			cell.secondStarButton.addTarget(self, action: #selector(secondStarClicked), for: .touchUpInside)
			cell.threeButtonStar.addTarget(self, action: #selector(thirdStarClicked), for: .touchUpInside)
			cell.fourButtonStar.addTarget(self, action: #selector(fourStarClicked), for: .touchUpInside)
			cell.fiveButtonStar.addTarget(self, action: #selector(fiveStarClicked), for: .touchUpInside)
			return cell
		} else if indexPath.row == 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
			cell.textChanged = {
				text in
				EstimateDataProvider.shared.comment = text
			}
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 192
		} else if indexPath.row == 1 {
			return 84
		} else if indexPath.row == 2 {
			return 32
		}
		return 0
	}
}
