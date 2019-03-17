//
//  BikeLocationDetailViewController.swift
//  MelbBikes
//
//  Created by Sam Wright on 21/2/19.
//  Copyright © 2019 Sam Wright. All rights reserved.
//

import UIKit
import MapKit

class BikeLocationDetailViewController: UIViewController {
    var bikeLocationInfo: BikeLocation?
    
    let availableLabel = UILabel()
    let availableNumber = UILabel()
    let acceptsLabel = UILabel()
    let creditCard = UIImageView(image: UIImage(named: "creditcard"))
    let key = UIImageView(image: UIImage(named: "key"))
    let mapView: MKMapView = {
        let map = MKMapView()
        return map
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = bikeLocationInfo?.locationName ?? "Bike Location Info"
        availableLabel.text = "Available"
        availableNumber.text = "\(bikeLocationInfo?.available ?? 0)"
        acceptsLabel.text = "Accepts"
        let coordinate = CLLocationCoordinate2DMake(Double((bikeLocationInfo?.lat)!),Double((bikeLocationInfo?.lon)!))
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.01),longitudeDelta: CLLocationDegrees(0.01))
        let zoomedRegion = MKCoordinateRegion(center: coordinate, span: coordinateSpan)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(bikeLocationInfo!.available) available bikes"
        mapView.addAnnotation(annotation)
        mapView.setRegion(zoomedRegion, animated: true)
        setupLabelLocations()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func setupLabelLocations() {
        view.addSubview(availableLabel)
        availableLabel.translatesAutoresizingMaskIntoConstraints = false
        availableLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        availableLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        view.addSubview(availableNumber)
        availableNumber.translatesAutoresizingMaskIntoConstraints = false
        availableNumber.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        availableNumber.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(acceptsLabel)
        acceptsLabel.translatesAutoresizingMaskIntoConstraints = false
        acceptsLabel.topAnchor.constraint(equalTo: availableNumber.bottomAnchor, constant: 20).isActive = true
        acceptsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        if(bikeLocationInfo?.canPayByCard ?? false) {
            view.addSubview(creditCard)
            creditCard.translatesAutoresizingMaskIntoConstraints = false
            creditCard.topAnchor.constraint(equalTo: availableNumber.bottomAnchor, constant: 20).isActive = true
            creditCard.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
            creditCard.heightAnchor.constraint(equalToConstant: 30).isActive = true
            creditCard.widthAnchor.constraint(equalToConstant: 30).isActive = true
        }
        
        if((bikeLocationInfo?.canPayByKey ?? false)) {
            view.addSubview(key)
            key.translatesAutoresizingMaskIntoConstraints = false
            key.topAnchor.constraint(equalTo: availableNumber.bottomAnchor, constant: 20).isActive = true
            if(bikeLocationInfo?.canPayByCard ?? false) {
                key.trailingAnchor.constraint(equalTo: creditCard.leadingAnchor, constant: -5).isActive = true
            } else {
                key.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
            }
            
            key.heightAnchor.constraint(equalToConstant: 30).isActive = true
            key.widthAnchor.constraint(equalToConstant: 30).isActive = true
        }
        
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: acceptsLabel.bottomAnchor, constant: 20).isActive = true
    
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
