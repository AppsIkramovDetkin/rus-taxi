//
//  MainController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 31.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class MainController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate {
	@IBOutlet weak var mapView: GMSMapView!
	@IBOutlet weak var centerView: UIView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewHeight: NSLayoutConstraint!
	private var locationManager = CLLocationManager()
	var acceptView: AcceptView?
	private let tableViewBottomLimit: CGFloat = 0
	private var addressModels: [Address] = [] {
		didSet {
			selectedDataSource?.update(with: addressModels)
		}
	}
	var prevY: CGFloat = 0
	private var selectedDataSource: MainDataSource?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		initializeMapView()
		initializeLocationManager()
		registerNibs()
		initializeFirstAddressCells()
		animatingView()
		acceptView = Bundle.main.loadNibNamed("AcceptView", owner: self, options: nil)?.first as? AcceptView
		self.view.addSubview(acceptView!)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if let unboxAcceptView = acceptView {
			unboxAcceptView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
		}
		initializeActionButtons()
		initializeTableView()
		tableView.reloadData()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		prevY = tableView.frame.origin.y
	}
	
	override func viewWillLayoutSubviews() {
		super.updateViewConstraints()
		
		self.tableViewHeight?.constant = self.tableView.contentSize.height
	}
	
	private func animatingView() {
		UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
			self.acceptView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
			self.acceptView?.dropShadow()
		}) { (finish) in
				UIView.animate(withDuration: 1, delay: 0.25, options: .curveEaseOut, animations: {
					self.acceptView?.frame = CGRect(x: 10, y: 150, width: self.view.frame.width - 20, height: 100)
					self.acceptView?.refuseButton.addTarget(self, action: #selector(self.refuseButtonClicked), for: .touchUpInside)
					self.acceptView?.dropShadow()
				}, completion: nil)
			}
		}
	
	@objc private func refuseButtonClicked() {
		let alertController = UIAlertController(title: "Причина", message: nil , preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
		
		let lateDriver = UIAlertAction(title: "Водитель опоздал", style: .default) {
			(result : UIAlertAction) -> Void in
			
		}
		
		let driverCancel = UIAlertAction(title: "Водитель хочет отменить заказ", style: .default) {
			(result : UIAlertAction) -> Void in
		}
		
		let changePlan = UIAlertAction(title: "Изменились планы", style: .default) {
			(result : UIAlertAction) -> Void in
		}
		
		let okAction = UIAlertAction(title: "Отмена", style: .cancel) {
			(result : UIAlertAction) -> Void in
		}
		
		alertController.addAction(lateDriver)
		alertController.addAction(driverCancel)
		alertController.addAction(changePlan)
		alertController.addAction(okAction)
		self.present(alertController, animated: true, completion: nil)
	}
		
	private func initializeActionButtons() {
		let startDataSource = MainControllerDataSource(models: addressModels)
		let onDriveDataSource = OnDriveDataSource(models: addressModels)
		let searchCarDataSource = SearchCarDataSource(models: addressModels)
		let driverOnWayDataSource = DriverOnWayDataSource(models: addressModels)
		startDataSource.actionAddClicked = {
			self.insertNewCells()
		}
		startDataSource.pushClicked = {
			let vc = SearchAddressController()
			self.navigationController?.pushViewController(vc, animated: true)
		}
		startDataSource.payTypeClicked = {
			PayAlertController.shared.showPayAlert(in: self) { (money, card) in }
		}
		startDataSource.deleteCellClicked = { view in
			guard let indexPath = self.tableView.indexPathForView(view: view) else {
				return
			}
			self.deleteCell(at: indexPath.row)
		}
		startDataSource.wishesClicked = {
			let vc = WishesController()
			self.navigationController?.pushViewController(vc, animated: true)
		}
		startDataSource.currentLocationClicked = {
			self.locationManager.startUpdatingLocation()
		}
		startDataSource.subviewsLayouted = {
			self.viewWillLayoutSubviews()
		}
		onDriveDataSource.chatClicked = {
			let vc = ChatController()
			self.navigationController?.pushViewController(vc, animated: true)
		}
		driverOnWayDataSource.chatClicked = {
			let vc = ChatController()
			self.navigationController?.pushViewController(vc, animated: true)
		}
		selectedDataSource = driverOnWayDataSource
		startDataSource.scrollViewScrolled = { [unowned self] scrollView in
			let condition = (self.tableView.frame.origin.y - scrollView.contentOffset.y) > self.prevY
			
			if condition {
				self.tableView.frame.origin.y -= scrollView.contentOffset.y
			} else if self.tableView.frame.origin.y <= self.prevY + 1 {
				self.tableView.contentOffset = CGPoint.zero
			}
		}
		
		startDataSource.scrollViewDragged = { [unowned self] scrollView in
			let isOnFirstHalf: Bool = {
				return abs(self.prevY - scrollView.frame.origin.y) < scrollView.frame.height * 0.55
			}()
			
			UIView.animate(withDuration: 0.2, animations: {
				if isOnFirstHalf {
					scrollView.frame.origin.y = self.prevY
				} else {
					scrollView.frame.origin.y = self.view.frame.maxY - scrollView.frame.height * 0.3
				}
			})
		}
		
		selectedDataSource = startDataSource
	}
	
	private func initializeFirstAddressCells() {
		let address = Address(pointName: points[0])
		addPoint(by: address)
		let address1 = Address(pointName: points[1])
		addPoint(by: address1)
	}
	
	private func initializeLocationManager() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
	}
	
	private func initializeMapView() {
		mapView.isMyLocationEnabled = true
		mapView.delegate = self
	}
	
	private func initializeTableView() {
		tableView.delegate = selectedDataSource
		tableView.dataSource = selectedDataSource
		tableView.isScrollEnabled = true
	}
	
	private func registerNibs() {
		tableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "headCell")
		tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
		tableView.register(AddressCell.nib, forCellReuseIdentifier: "addressCell")
		tableView.register(UINib(nibName: "ChooseTaxiCell", bundle: nil), forCellReuseIdentifier: "chooseTaxiCell")
		tableView.register(UINib(nibName: "CallTaxiCell", bundle: nil), forCellReuseIdentifier: "callTaxiCell")
		tableView.register(UINib(nibName: "DriveDetailsCell", bundle: nil), forCellReuseIdentifier: "driveCell")
		tableView.register(UINib(nibName: "DriverDetailsCell", bundle: nil), forCellReuseIdentifier: "driverCell")
		tableView.register(UINib(nibName: "PropertiesCell", bundle: nil), forCellReuseIdentifier: "propertiesCell")
		tableView.register(UINib(nibName: "PricesCell", bundle: nil), forCellReuseIdentifier: "pricesCell")
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.first else {
			return
		}
		
		let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
		mapView.animate(toLocation: myLocation)
		mapView.animate(toZoom: 16)
	}
	
	private func insertNewCells() {
		guard addressModels.count < points.count else {
			return
		}
		addPoint(by: Address.init(pointName: points[addressModels.count]))
	}
	
	private func deleteCell(at index: Int) {
		removePoint(by: index)
	}
	
	fileprivate func addPoint(by model: Address) {
		guard addressModels.count < points.count else {
			return
		}
		let previousIndexPath = IndexPath.init(row: addressModels.count, section: 0)
		let indexPath = IndexPath.init(row: addressModels.count + 1, section: 0)
		addressModels.append(model)
		tableView.insertRows(at: [indexPath], with: .bottom)
		tableView.reloadRows(at: [previousIndexPath], with: .automatic)
		prevY = tableView.frame.origin.y
	}
	
	fileprivate func removePoint(by index: Int) {
		let previousIndexPath = IndexPath.init(row: addressModels.count - 1, section: 0)
		let indexPath = IndexPath.init(row: addressModels.count, section: 0)
		addressModels.removeLast()
		tableView.deleteRows(at: [indexPath], with: .automatic)
		tableView.reloadRows(at: [previousIndexPath], with: .automatic)
		prevY = tableView.frame.origin.y
	}
	
}

extension MainController: GMSMapViewDelegate {
	func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
		let center = mapView.center
		let coordinate = mapView.projection.coordinate(for: center)
		LocationInteractor(coordinate).response { (model) in
			print("Model street: \(model?.Street)")
		}
		annotationView?.annotation = annotation
		annotationView?.image = #imageLiteral(resourceName: "pin")
		return annotationView
		}
	}
}

extension UIView {
	var visibleRect: CGRect? {
		guard let superview = superview else { return nil }
		return frame.intersection(superview.bounds)
	}
}

