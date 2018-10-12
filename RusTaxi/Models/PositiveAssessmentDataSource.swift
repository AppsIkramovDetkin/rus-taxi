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
	var assessmentClicked: VoidClosure?
	var viewController: UIViewController?
	func update(with models: [Any]) {}
	
	@objc private func assessmentAction() {
		assessmentClicked?()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as! TripDetailsCell
			cell.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
			return cell
		} else if indexPath.row == 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "estimatedCell", for: indexPath) as! EstimateTripCell
			cell.label.text = "Оцените работу"
			cell.firstStarButton.addTarget(self, action: #selector(assessmentAction), for: .touchUpInside)
			cell.secondStarButton.addTarget(self, action: #selector(assessmentAction), for: .touchUpInside)
			cell.threeButtonStar.addTarget(self, action: #selector(assessmentAction), for: .touchUpInside)
			return cell
		} else if indexPath.row == 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
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
