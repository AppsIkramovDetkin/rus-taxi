//
//  EstimateController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 11.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

class EstimateController: UIViewController, UITableViewDelegate, NibLoadable {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var button: UIButton!
	
	fileprivate var selectedDataSource: MainDataSource?
	private let dataProvider = EstimateDataProvider.shared
	
	var response: CheckOrderModel!
	private var savedDataProvider = NewOrderDataProvider.shared
	override func viewDidLoad() {
		super.viewDidLoad()
		NavigationBarDecorator.decorate(self)
		title = "Поездка окончена"
		registerNibs()
		set(dataSource: dataProvider.result)
		initializeTableView()
		tableView.reloadData()
		button.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	@objc private func doneButtonClicked() {
		let id = savedDataProvider.request.local_id ?? ""
		OrderManager.shared.feedback(local_id: id, stars: dataProvider.rating, comment: dataProvider.comment, causeIds: [], completion: {
			self.navigationController?.popViewController(animated: true)
		})
	}
	
	
	func set(dataSource type: EstimateResult) {
		switch type {
		case .positive:
			setPositiveAssessmentDataSource()
		case .negative:
			setNegativeAssessmentDataSource()
		}
		tableView.reloadData()
	}
	
	private func initializeTableView() {
		refreshDelegates()
		tableView.isScrollEnabled = false
	}
	
	func update() {
		refreshDelegates()
		tableView.reloadData()
	}
	
	private lazy var assessmentClicked: ItemClosure<Int> = { stars in
		self.dataProvider.set(stars: stars)
		if stars <= 3 {
			self.set(dataSource: .negative(stars))
		} else {
			self.set(dataSource: .positive(stars))
		}
	}
	
	private func setPositiveAssessmentDataSource() {
		let positiveAssessmentDataSource = PositiveAssessmentDataSource(result: dataProvider.result, response: response)
		positiveAssessmentDataSource.assessmentClicked = assessmentClicked
		positiveAssessmentDataSource.viewController = self
		selectedDataSource = positiveAssessmentDataSource
		update()
	}
	
	private func setNegativeAssessmentDataSource() {
		let negativeAssessmentDataSource = NegativeAssessmentDataSource(result: dataProvider.result, response: response)
		negativeAssessmentDataSource.assessmentClicked = assessmentClicked
		negativeAssessmentDataSource.viewController = self
		selectedDataSource = negativeAssessmentDataSource
		update()
	}
		
	private func refreshDelegates() {
		tableView.delegate = selectedDataSource
		tableView.dataSource = selectedDataSource
	}
	
	private func registerNibs() {
		tableView.register(UINib(nibName: "TripDetailsCell", bundle: nil), forCellReuseIdentifier: "tripCell")
		tableView.register(UINib(nibName: "EstimateTripCell", bundle: nil), forCellReuseIdentifier: "estimatedCell")
		tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "commentCell")
		tableView.register(UINib(nibName: "NegativeReasonCell", bundle: nil), forCellReuseIdentifier: "negativeCell")
	}
}
