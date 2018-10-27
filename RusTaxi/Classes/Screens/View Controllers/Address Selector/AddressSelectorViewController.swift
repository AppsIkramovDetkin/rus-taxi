//
//  AddressSelectorViewController.swift
//  RusTaxi
//
//  Created by Danil Detkin on 20/09/2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import GoogleMaps

class AddressSelectorViewController: UIViewController {
	@IBOutlet weak var mapView: GMSMapView!
	@IBOutlet weak var doneButton: UIButton!
	
	private var addressView: AddressView!
	private var selectedModel: SearchAddressResponseModel?
	private var centerView: CenterView!
	var selected: OptionalItemClosure<SearchAddressResponseModel>?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Выбор на карте"
		mapView.delegate = self
		addAddressView()
		goToMyLocation()
		addCenterView()
		centerView.label.text = nil
		mapView.isMyLocationEnabled = true
		// Do any additional setup after loading the view.
	}
	
	private func addCenterView() {
		centerView = CenterView.loadFromNib()
		centerView?.translatesAutoresizingMaskIntoConstraints = false
		centerView.set(time: Time.zero.minutes(1))
		mapView.addSubview(centerView!)
		let constraints: [NSLayoutConstraint] = {
			return NSLayoutConstraint.contraints(withNewVisualFormat: "H:[x(40)],V:[x(60)]", dict: ["x": centerView!]) + [NSLayoutConstraint.centerX(for: centerView!, to: mapView)] + [NSLayoutConstraint.centerY(for: centerView!, offset: -30, to: mapView)]
		}()
		
		mapView.addConstraints(constraints)
	}
	
	private func goToMyLocation() {
		if let location = LocationInteractor.shared.myLocation {
			mapView.animate(toLocation: location)
			mapView.animate(toZoom: 16)
		}
	}
	
	@IBAction func applyButtonClicked() {
		selected?(selectedModel)
		smartBack()
	}
	
	private func addAddressView() {
		addressView = AddressView.loadFromNib()
		addressView.addressLabel.text = "..."
		addressView.countryLabel.text = ""
		addressView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(addressView)
		
		let constraints: [NSLayoutConstraint] = {
			return NSLayoutConstraint.contraints(withNewVisualFormat: "H:|-16-[addressView]-16-|,V:[addressView(44)]", dict: ["addressView": addressView]) + [NSLayoutConstraint.init(item: addressView, attribute: .topMargin, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 16)]
		}()
		
		view.addConstraints(constraints)
	}
	
	func updateAddressViewData() {
		if let model = selectedModel {
			addressView.configure(by: model)
		}
	}
}

extension AddressSelectorViewController: GMSMapViewDelegate {
	func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
		let center = mapView.center
		addressView.startLoading()
		let coordinate = mapView.projection.coordinate(for: center)
		LocationInteractor.shared.response(location: coordinate) { (response) in
			if let response = response {
				self.selectedModel = SearchAddressResponseModel.from(nearModel: response)
				self.updateAddressViewData()
				self.addressView.stopLoading()
			}
		}
	}
}
