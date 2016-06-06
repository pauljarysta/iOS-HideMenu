//
//  ViewController.swift
//  ScrollMenu
//
//  Created by Paul Jarysta on 05/06/2016.
//  Copyright © 2016 Paul Jarysta. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
	let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height
	
	var menu: MenuView?
	var menuHidden = false
	var lastContentOffset: CGFloat = 0.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 500.0
	}
	
	override func viewDidAppear(animated: Bool) {
		addMenu()
	}
	
	override func viewWillAppear(animated: Bool) {
		removeMenu()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func addMenu() {
		if menu == nil {
			let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
			let menuView = NSBundle.mainBundle().loadNibNamed("MenuView", owner: self, options: nil)[0] as! MenuView
			menuView.frame = CGRectMake(0, screenHeight - 70, screenWidth, 70)
			menuView.blurView.layer.cornerRadius = 3
			menuView.blurView.layer.masksToBounds = true
			
			appDelegate?.window?.addSubview(menuView)
			menuView.slideInFromBottom()
			menu = menuView
		}
	}
	
	func hideMenu(menu: UIView) {
		if !menuHidden {
			UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
				menu.frame =  CGRectMake(0, self.screenHeight, self.screenWidth, 70)
				}, completion: { finished in
					self.menuHidden = true
			})
		}
	}
	
	func unhideMenu(menu: UIView) {
		if menuHidden {
			UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
				menu.frame =  CGRectMake(0, self.screenHeight - 70, self.screenWidth, 70)
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

	override func scrollViewDidScroll(scrollView: UIScrollView) {
		if let menu = menu {
			if lastContentOffset < 0.0 {
				
			} else if lastContentOffset > scrollView.contentOffset.y  {
				unhideMenu(menu)
			} else if lastContentOffset < scrollView.contentOffset.y {
				hideMenu(menu)
			}
			lastContentOffset = scrollView.contentOffset.y
		}
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 42
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 70
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell

		cell.textLabel?.text = "Cell n°\(indexPath.row)"
		cell.textLabel?.font = UIFont.systemFontOfSize(18)
		
		return cell
	}
	
}

