//
//  FetchedResultsControllerProviderDelegate+CollectionView.swift
//  Altos-app
//
//  Created by Eugeniy Zaychenko on 12/16/18.
//


import UIKit

//MARK: - FetchedResultsProviderDelegate + CollectionView

public protocol CollectionViewFetchedResultsProviderDelegate: FetchedResultsProviderDelegate {
    
    var collectionView: UICollectionView! { get }
    var sectionsOperations: [BlockOperation] { get set }
    var itemsOserations: [BlockOperation] { get set }
    var shouldAlwaysReloadData: Bool { get }
    func didFinishAnimation()
}

public extension CollectionViewFetchedResultsProviderDelegate {
    
    var shouldAlwaysReloadData: Bool { return false }
    
    func didFinishAnimation() {
        collectionView.reloadData()
    }
    
    func didReloadContent() {
        collectionView.reloadData()
    }
    
    func willUpdateList() {
        collectionView.setContentOffset(collectionView.contentOffset, animated: false)
    }
    
    func didUpdateList() {
        
        if shouldAlwaysReloadData || collectionView.window == nil || UIApplication.shared.applicationState != .active {
            collectionView.reloadData()
            sectionsOperations.removeAll()
            itemsOserations.removeAll()
            return
        }
        
        performBatchesForSections()
        performBatchesForItems()
    }
    
    func moveObject(from indexPath: IndexPath?, to newIndexPath: IndexPath?) {
        
        guard let from = indexPath, let to = newIndexPath else { return }
        addToSectionsOperations(operation: BlockOperation { [weak self] in
            self?.collectionView.deleteItems(at: [from])
            self?.collectionView.insertItems(at: [to])
        })
    }
    
    func insertObject(at indexPath: IndexPath?) {
        
        let indexPaths = [indexPath].compactMap{ $0 }
        addToSectionsOperations(operation: BlockOperation { [weak self] in
            self?.collectionView.insertItems(at: indexPaths)
        })
    }
    
    func deleteObject(at indexPath: IndexPath?) {
        
        let indexPaths = [indexPath].compactMap{ $0 }
        addToSectionsOperations(operation: BlockOperation { [weak self] in
            self?.collectionView.deleteItems(at: indexPaths)
        })
    }
    
    func updateObject(at indexPath: IndexPath?) {
        
        let indexPaths = [indexPath].compactMap{ $0 }
        if indexPaths.isEmpty { return }
        addToSectionsOperations(operation: BlockOperation { [weak self] in
            self?.collectionView.reloadItems(at: indexPaths)
        })
    }
    
    func insert(section: Int) {
        addToSectionsOperations(operation: BlockOperation { [weak self] in
            self?.collectionView.insertSections(IndexSet(integer: section))
        })
    }
    
    func delete(section: Int) {
        addToSectionsOperations(operation: BlockOperation { [weak self] in
            self?.collectionView.deleteSections(IndexSet(integer: section))
        })
    }
    
    func update(section: Int) {
        addToSectionsOperations(operation: BlockOperation { [weak self] in
            self?.collectionView.reloadSections(IndexSet(integer: section))
        })
    }
    
    private func addToItemsOperations(operation: BlockOperation) {
        itemsOserations.append(operation)
    }
    
    private func addToSectionsOperations(operation: BlockOperation) {
        sectionsOperations.append(operation)
    }
    
    private func performBatchesForItems() {
        
        if itemsOserations.isEmpty { return }

        self.collectionView.performBatchUpdates({[weak self] () -> Void in
            self?.itemsOserations.forEach { $0.start() }
        }, completion: {[weak self] (finished) -> Void in
            self?.itemsOserations.removeAll()
            DispatchQueue.main.async {
                self?.didFinishAnimation()
            }
        })
    }
    
    private func performBatchesForSections() {
        
        if sectionsOperations.isEmpty { return }

        self.collectionView.performBatchUpdates({[weak self] () -> Void in
            self?.sectionsOperations.forEach { $0.start() }
        }, completion: {[weak self] (finished) -> Void in
            self?.sectionsOperations.removeAll()
        })
    }
}
