//
//  MainController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 31.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import MapKit

class MainController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewHeight: NSLayoutConstraint!
	private var locationManager = CLLocationManager()
	private var addressModels: [Address] = []
	var acceptView: AcceptView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		initializeMapView()
		initializeLocationManager()
		initializeTableView()
		registerNibs()
		initializeFirstAddressCells()
		animatingView()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if acceptView == nil {
			acceptView = Bundle.main.loadNibNamed("AcceptView", owner: self, options: nil)?.first as? AcceptView
			acceptView?.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
			self.view.addSubview(acceptView!)
		}
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
		mapView.delegate = self
		mapView.showsUserLocation = true
	}
	
	private func initializeTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.isScrollEnabled = false
	}
	
	private func registerNibs() {
		tableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "headCell")
		tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
		tableView.register(AddressCell.nib, forCellReuseIdentifier: "addressCell")
		tableView.register(UINib(nibName: "ChooseTaxiCell", bundle: nil), forCellReuseIdentifier: "chooseTaxiCell")
		tableView.register(UINib(nibName: "CallTaxiCell", bundle: nil), forCellReuseIdentifier: "callTaxiCell")
	}
	
	@objc func actionButtonAddClicked() {
		insertNewCells()
	}
	
	@objc func deleteButtonClicked(sender: UIButton) {
		guard let indexPath = tableView.indexPathForView(view: sender) else {
			return
		}
		deleteCell(at: indexPath.row)
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
	
	@objc func currentLocationClicked() {
		locationManager.startUpdatingLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let location = locations[0]
		let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
		let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
		let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
		mapView.setRegion(region, animated: true)
	}
	
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		mapView.centerCoordinate = userLocation.location!.coordinate
	}
	
	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
		let mapLatitude = mapView.centerCoordinate.latitude
		let mapLongtitude = mapView.centerCoordinate.longitude
		let ceo: CLGeocoder = CLGeocoder()
		center.latitude = mapLatitude
		center.longitude = mapLongtitude
		let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
		ceo.reverseGeocodeLocation(loc, completionHandler:
			{(placemarks, error) in
				if (error != nil) {
					self.showAlert(title: "Ошибка", message: "\(error!.localizedDescription)")
				}
				let placemarks = placemarks! as [CLPlacemark]
				if !placemarks.isEmpty {
					let placemarks = placemarks[0]
					var addressString : String = ""
					var countryString : String = ""
					
					if placemarks.thoroughfare != nil {
						addressString = addressString + placemarks.thoroughfare! + ", "
					}
					
					if placemarks.subThoroughfare != nil {
						addressString = addressString + placemarks.subThoroughfare!
					}
					
					if placemarks.locality != nil {
						countryString = countryString + placemarks.locality! + ", "
					}

					if placemarks.country != nil {
						countryString = countryString + placemarks.country! + " "
					}
					
					self.addressModels[0].address = addressString
					self.addressModels[0].country = countryString
					self.tableView.reloadData()
				}
		})
	}
	
	fileprivate func addPoint(by model: Address) {
		guard addressModels.count < points.count else {
			return
		}
		let previousIndexPath = IndexPath.init(row: addressModels.count, section: 0)
		let indexPath = IndexPath.init(row: addressModels.count + 1, section: 0)
		addressModels.append(model)
		tableView.insertRows(at: [indexPath], with: .automatic)
		tableView.reloadRows(at: [previousIndexPath], with: .automatic)
	}
	
	fileprivate func removePoint(by index: Int) {
		let previousIndexPath = IndexPath.init(row: addressModels.count - 1, section: 0)
		let indexPath = IndexPath.init(row: addressModels.count, section: 0)
		addressModels.removeLast()
		tableView.deleteRows(at: [indexPath], with: .automatic)
		tableView.reloadRows(at: [previousIndexPath], with: .automatic)
	}
	
	@objc private func payTypeClicked() {
		PayAlertController.shared.showPayAlert(in: self) { (money, card) in
			
		}
	}
	
	@objc private func wishesButtonClicked() {
		let vc = WishesController()
		navigationController?.pushViewController(vc, animated: true)
	}
}

extension MainController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "headCell", for: indexPath) as! HeaderCell
			cell.myPositionButton.addTarget(self, action: #selector(currentLocationClicked), for: .touchUpInside)
			return cell
		} else if indexPath.row > 0 && indexPath.row <= addressModels.count {
			let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressCell
			let model = addressModels[indexPath.row - 1]
			cell.configure(by: model)
			cell.topLineView.isHidden = model.position == .top
			cell.botLineView.isHidden = model.pointName == addressModels.last!.pointName
			switch model.state {
			case .default:
				cell.actionButton.isHidden = true
			case .add:
				cell.actionButton.isHidden = false
				cell.actionButton.setImage(icons[0], for: .normal)
				cell.actionButton.removeTarget(self, action: nil, for: .allEvents)
				cell.actionButton.addTarget(self, action: #selector(actionButtonAddClicked), for: .touchUpInside)
			default:
				cell.actionButton.isHidden = false
				cell.actionButton.removeTarget(self, action: nil, for: .allEvents)
				cell.actionButton.setImage(icons[1], for: .normal)
				cell.actionButton.addTarget(self, action: #selector(deleteButtonClicked(sender:)), for: .touchUpInside)
			}
			return cell
		} else if indexPath.row == addressModels.count + 1 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
			cell.payTypeButton.addTarget(self, action: #selector(payTypeClicked), for: .touchUpInside)
			cell.wishesButton.addTarget(self, action: #selector(wishesButtonClicked), for: .touchUpInside)
			return cell
		} else if indexPath.row == addressModels.count + 2 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "chooseTaxiCell", for: indexPath) as! ChooseTaxiCell
			return cell
		} else if indexPath.row == addressModels.count + 3 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "callTaxiCell", for: indexPath) as! CallTaxiCell
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		self.viewWillLayoutSubviews()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 0 {
			return 33
		} else if indexPath.row > 0 && indexPath.row <= addressModels.count {
			return 63
		} else if indexPath.row == addressModels.count + 1 {
			return 41
		} else if indexPath.row == addressModels.count + 2 {
			return 66
		} else {
			return 45
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return addressModels.count + 4
	}
}

