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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addAddressView()
		// Do any additional setup after loading the view.
	}
	
	private func addAddressView() {
		addressView = AddressView.loadFromNib()
		addressView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(addressView)
		
		let constraints: [NSLayoutConstraint] = {
			return NSLayoutConstraint.contraints(withNewVisualFormat: "H:|-16-[addressView]-16-|,V:|-32-[addressView(72)]", dict: ["addressView": addressView])
		}()
		
		view.addConstraints(constraints)
	}
	
}
