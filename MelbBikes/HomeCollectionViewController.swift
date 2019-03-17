//
//  HomeCollectionViewController.swift
//  MelbBikes
//
//  Created by Sam Wright on 21/2/19.
//  Copyright © 2019 Sam Wright. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class HomeCollectionViewController: UICollectionViewController {
    
    var dataProvider: DataProvider!
    lazy var fetchedResultsController: NSFetchedResultsController<BikeLocation> = {
        let fetchRequest = NSFetchRequest<BikeLocation>(entityName:"BikeLocation")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending:true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: dataProvider.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    private let refreshControl = UIRefreshControl()

    let detailView = BikeLocationDetailViewController()
    let mapView = MapViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: Selector("openMap"))
        self.navigationItem.rightBarButtonItem = camera

        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(triggerRefreshData(_:)), for: .valueChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            var itemsPerRow: CGFloat = 2
            if(traitCollection.horizontalSizeClass == .regular) {
                itemsPerRow = 4
            }
            
            let padding: CGFloat = 20
            let totalPadding = padding * (itemsPerRow - 1)
            let individualPadding = totalPadding / itemsPerRow
            let width = collectionView.frame.width / itemsPerRow - individualPadding
            let height = width
            
            layout.itemSize = CGSize(width: width, height: height)
            layout.minimumInteritemSpacing = padding
            layout.minimumLineSpacing = padding
        }
        
        
        refreshData()
        
        self.title = "MelbBikes"
        
        self.collectionView!.backgroundColor = .white
        
        self.collectionView!.register(BikeLocationCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    @objc private func openMap() {
        mapView.fetchedResultsController = fetchedResultsController
        navigationController?.pushViewController(mapView, animated: true)
    }
    
    @objc private func triggerRefreshData(_ sender: Any) {
        refreshData()
    }
    
    func refreshData() {
        var numberToGo = 2
        dataProvider.fetchBikeShareLocations() { (error) in
            print(error)
            numberToGo -= 1
            DispatchQueue.main.async {
                self.stopRefreshingUI(numberToGo: numberToGo)
            }
        }
        dataProvider.fetchBikeShareAvailabilities() { (error) in
            print(error)
            numberToGo -= 1
            DispatchQueue.main.async {
                self.stopRefreshingUI(numberToGo: numberToGo)
            }
            
        }
    }
    
    func stopRefreshingUI(numberToGo: Int) {
        if(numberToGo == 0) {
            self.refreshControl.endRefreshing()
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let bikeLocationCell = cell as? BikeLocationCollectionViewCell {
            let bikeLocation = fetchedResultsController.object(at: indexPath)
            bikeLocationCell.configure(location: bikeLocation.locationName, available: Int(bikeLocation.available), capacity: Int(bikeLocation.capacity))
            return bikeLocationCell
        }
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let bikeLocationInfo = fetchedResultsController.object(at: indexPath)
        detailView.bikeLocationInfo = bikeLocationInfo
        navigationController?.pushViewController(detailView, animated: true)
        return true
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension HomeCollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        collectionView.reloadData()
    }
}
