//
//  SlideshowController.swift
//  RusTaxi
//
//  Created by Ruslan Prozhivin on 23.08.2018.
//  Copyright © 2018 App's ID. All rights reserved.
//

import UIKit
import Material

class SlideshowController: UIViewController, UIScrollViewDelegate {
	@IBOutlet weak var slideShow: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var button: Button!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "О программе", style: .plain, target: self, action: nil)

		button.image = #imageLiteral(resourceName: "cancel-music")
		button.setTitle("", for: .normal)
		button.shadow = true
		button.shadowColor = .black
		button.layer.borderColor = UIColor.lightGray.cgColor
		button.layer.borderWidth = 0.75
		slideSettings()
	}
	
	private func slideSettings() {
		slideShow.delegate = self
		let slides: [Slide] = createSlide()
		setupSlideScrollView(slides: slides)
		pageControl.numberOfPages = slides.count
		pageControl.currentPage = 0
	}
	
	private func createSlide() -> [Slide] {
		let slide1: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
		slide1.slideTextView.text = Localize("slide1")
		slide1.slideImage.image = #imageLiteral(resourceName: "help1")
		let slide2: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
		slide2.slideTextView.text = Localize("slide2")
		slide2.slideImage.image = #imageLiteral(resourceName: "help2")
		let slide3: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
		slide3.slideTextView.text = Localize("slide3")
		slide3.slideImage.image = #imageLiteral(resourceName: "help3")
		let slide4: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
		slide4.slideTextView.text = Localize("slide4")
		slide4.slideImage.image = #imageLiteral(resourceName: "help4")
		return [slide1, slide2, slide3, slide4]
	}
	
	private func setupSlideScrollView(slides: [Slide]) {
		slideShow.showsHorizontalScrollIndicator = false
		slideShow.isPagingEnabled = true
		
		for i in 0..<slides.count {
			let slide = slides[i]
			slide.translatesAutoresizingMaskIntoConstraints = false
			slideShow.addSubview(slide)
			slideShow.addConstraints(NSLayoutConstraint.contraints(withNewVisualFormat: "V:|[slide]|", dict: ["slide": slide]) + [NSLayoutConstraint.init(item: slide, attribute: .width, relatedBy: .equal, toItem: slide.superview, attribute: .width, multiplier: 1, constant: 0)])
			if slides.contains(index: i - 1) {
				let prevSlide = slides[i - 1]
				if i == slides.count - 1 {
					slideShow.addConstraints(NSLayoutConstraint.contraints(withNewVisualFormat: "H:[prevSlide][slide]|", dict: ["prevSlide": prevSlide,"slide": slide]))
					slide.heightAnchor.constraint(equalTo: slideShow.heightAnchor, multiplier: 1).isActive = true
				} else {
					slideShow.addConstraints(NSLayoutConstraint.contraints(withNewVisualFormat: "H:[prevSlide][slide]", dict: ["prevSlide": prevSlide,"slide": slide]))
					slide.heightAnchor.constraint(equalTo: slideShow.heightAnchor, multiplier: 1).isActive = true
				}
			} else {
				slideShow.addConstraints(NSLayoutConstraint.contraints(withNewVisualFormat: "H:|[slide]", dict: ["slide": slide]))
				slide.heightAnchor.constraint(equalTo: slideShow.heightAnchor, multiplier: 1).isActive = true
			}
		}
		
		self.slideShow.contentSize = CGSize(width: view.frame.size.width * CGFloat(slides.count), height: 0)
	}
	
	internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let pageIndex = round(scrollView.contentOffset.x/slideShow.frame.size.width)
		pageControl.currentPage = Int(pageIndex)
	}
}
