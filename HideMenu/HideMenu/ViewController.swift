//
//  ViewController.swift
//  HideMenu
//
//  Created by Paul Jarysta on 05/06/2016.
//  Copyright © 2016 Paul Jarysta. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	let screenWidth: CGFloat = UIScreen.main.bounds.width
	let screenHeight: CGFloat = UIScreen.main.bounds.height
	
	var menu: MenuView?
	var menuHidden = false
	var lastContentOffset: CGFloat = 0.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 500.0
	}
	
	override func viewDidAppear(_ animated: Bool) {
		addMenu()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		removeMenu()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func addMenu() {
		if menu == nil {
			let appDelegate = UIApplication.shared.delegate as? AppDelegate
			let menuView = Bundle.main.loadNibNamed("MenuView", owner: self, options: nil)?[0] as! MenuView
			menuView.frame = CGRect(x: 0, y: screenHeight - 70, width: screenWidth, height: 70)
			menuView.blurView.layer.cornerRadius = 3
			menuView.blurView.layer.masksToBounds = true
			
			if (Device.IS_IPHONE_X) {
				self.updateNavBar(y: 44)
			} else {
				self.updateNavBar(y: 20)
			}
			
			appDelegate?.window?.addSubview(menuView)
			menuView.slideInFromBottom()
			menu = menuView
		}
	}

	func hideMenu(menu: UIView) {
		if !menuHidden {
			UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
				menu.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth, height: 70)
				if (Device.IS_IPHONE_X) {
					self.updateNavBar(y: 0)
				} else {
					self.updateNavBar(y: 20 - (20 + 44))
				}
				
			}, completion: { finished in
				self.menuHidden = true
			})
		}
	}
	
	func unhideMenu(menu: UIView) {
		if menuHidden {
			UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
				menu.frame =  CGRect(x: 0, y: self.screenHeight - 70, width: self.screenWidth, height: 70)
				if (Device.IS_IPHONE_X) {
					self.updateNavBar(y: 44)
				} else {
					self.updateNavBar(y: 20)
				}
			}, completion: { finished in
				self.menuHidden = false
			})
		}
	}

	func removeMenu() {
		if let menu = menu {
			menu.removeFromSuperview()
			self.menu = nil
		}
	}

	func updateNavBar(y: CGFloat) {
		self.navigationController?.navigationBar.frame = CGRect(
			x: (self.navigationController?.navigationBar.frame.origin.x)!,
			y: y,
			width: (self.navigationController?.navigationBar.frame.size.width)!,
			height: (self.navigationController?.navigationBar.frame.size.height)!)
	}

	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if let menu = menu {
			if lastContentOffset < 0.0 {
				
			} else if lastContentOffset > scrollView.contentOffset.y  {
				unhideMenu(menu: menu)
			} else if lastContentOffset < scrollView.contentOffset.y {
				hideMenu(menu: menu)
			}
			lastContentOffset = scrollView.contentOffset.y
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 42
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell

		cell.textLabel?.text = "Cell n°\(indexPath.row)"
		cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
		
		return cell
	}
	
}

