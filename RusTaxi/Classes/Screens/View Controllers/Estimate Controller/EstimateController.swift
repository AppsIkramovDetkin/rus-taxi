//
//  EstimateController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 11.10.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit

enum DataSourcesType {
	case positive
	case negative
}

class EstimateController: UIViewController, UITableViewDelegate {
	@IBOutlet weak var tableView: UITableView!
	fileprivate var selectedDataSource: MainDataSource?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		registerNibs()
		set(dataSource: .positive)
		initializeTableView()
		tableView.reloadData()
	}
	
	func set(dataSource type: DataSourcesType) {
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
	
	private func setPositiveAssessmentDataSource() {
		let positiveAssessmentDataSource = PositiveAssessmentDataSource()
		positiveAssessmentDataSource.assessmentClicked = {
			self.set(dataSource: .negative)
		}
		positiveAssessmentDataSource.viewController = self
		selectedDataSource = positiveAssessmentDataSource
		update()
	}
	
	private func setNegativeAssessmentDataSource() {
		let negativeAssessmentDataSource = NegativeAssessmentDataSource()
		negativeAssessmentDataSource.assessmentClicked = {
			self.set(dataSource: .positive)
		}
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
