//
//  FetchedResultsControllerProviderDelegate+Collections.swift
//  CityRX
//
//  Created by Eugeniy Zaychenko on 12/15/18.
//  Copyright © 2018 Reinvently. All rights reserved.
//

import UIKit


//MARK: - FetchedResultsProviderDelegate + TableView

public protocol TableViewFetchedResultsProviderDelegate: FetchedResultsProviderDelegate {
    
    var shouldStopScroll: Bool { get }
    var animationType: UITableView.RowAnimation { get }
    var tableView: UITableView! { get set }
    
    func didFinishAnimation()
}

public extension TableViewFetchedResultsProviderDelegate {
    
    var shouldStopScroll: Bool {
        return true
    }
    
    var animationType: UITableView.RowAnimation {
        return UITableView.RowAnimation.fade
    }
    
    func didFinishAnimation() {
        tableView.reloadData()
    }
    
    func didReloadContent() {
        tableView.reloadData()
    }
    
    func willUpdateList() {
        
        if tableView.window == nil { return }
        
        if shouldStopScroll {
            tableView.setContentOffset(tableView.contentOffset, animated: false)
        }
        tableView.beginUpdates()
    }
    
    func didUpdateList() {
        
        if tableView.window == nil {
            tableView.reloadData()
            return
        }
        
        if shouldStopScroll {
            tableView.setContentOffset(tableView.contentOffset, animated: false)
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.didFinishAnimation()
        }
        tableView.endUpdates()
        CATransaction.commit()
    }
    
    func moveObject(from indexPath: IndexPath?, to newIndexPath: IndexPath?) {
        
        if tableView.window == nil { return }
        
        guard let from = indexPath, let to = newIndexPath else { return }
        tableView.moveRow(at: from, to: to)
    }
    
    func insertObject(at indexPath: IndexPath?) {
        
        if tableView.window == nil { return }
        
        let indexPaths = [indexPath].compactMap{ $0 }
        tableView.insertRows(at: indexPaths, with: animationType)
    }
    
    func deleteObject(at indexPath: IndexPath?) {
        
        if tableView.window == nil { return }
        
        let indexPaths = [indexPath].compactMap{ $0 }
        tableView.deleteRows(at: indexPaths, with: animationType)
    }
    
    func insert(section: Int) {
        
        if tableView.window == nil { return }
        tableView.insertSections(IndexSet(integer: section), with: animationType)
    }
    
    func delete(section: Int) {
        
        if tableView.window == nil { return }
        tableView.deleteSections(IndexSet(integer: section), with: animationType)
    }
    
    func update(section: Int) {
        
        if tableView.window == nil { return }
        tableView.reloadSections(IndexSet(integer: section), with: animationType)
    }
}

public extension UITableView {
    
    func addLoadingIndicator() {
        
        if isLoading {
            return
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = activityIndicatorRect
        
        activityIndicator.startAnimating()
        tableFooterView = activityIndicator
    }
    
    func removeLoadingIndicator() {
        
        if isLoading {
            UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
                self.tableFooterView = UIView()
            })
        }
    }
    
    var isLoading: Bool {
        return self.tableFooterView is UIActivityIndicatorView
    }
    
    private var activityIndicatorRect: CGRect {
        return CGRect(x: 0.0, y: 0.0, width: 20.0, height: 40.0)
    }
}
