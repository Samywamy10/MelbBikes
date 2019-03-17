//
//  MapViewController.swift
//  MelbBikes
//
//  Created by Sam Wright on 21/2/19.
//  Copyright © 2019 Sam Wright. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class CustomAnnotation : MKPointAnnotation {
    var id: NSNumber?
}

class MapViewController: UIViewController, MKMapViewDelegate {
    var fetchedResultsController: NSFetchedResultsController<BikeLocation>?
    let detailView = BikeLocationDetailViewController()
    let mapView: MKMapView = {
        let map = MKMapView()
        return map
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        for bikeLocationInfo in (fetchedResultsController?.fetchedObjects)! {
            let coordinate = CLLocationCoordinate2DMake(Double(bikeLocationInfo.lat),Double(bikeLocationInfo.lon))
            let annotation = CustomAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(bikeLocationInfo.available) available bikes"
            annotation.id = bikeLocationInfo.id
            mapView.addAnnotation(annotation)
            
        }
        let melbourneCoordinate = CLLocationCoordinate2DMake(Double("-37.8136")!,Double("144.9631")!)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.08),longitudeDelta: CLLocationDegrees(0.08))
        let zoomedRegion = MKCoordinateRegion(center: melbourneCoordinate, span: coordinateSpan)
        mapView.setRegion(zoomedRegion, animated: true)
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation as! CustomAnnotation
        print(annotation.id!)
        let bikeLocationInfo = fetchedResultsController?.fetchedObjects?.first(where: {$0.id == annotation.id!})
        detailView.bikeLocationInfo = bikeLocationInfo
        navigationController?.pushViewController(detailView, animated: true)
    }
    
    func setupMap() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
