//
//  LocationSearchTable.swift
//  GoTripIOS
//
//  Created by Gleb Sobolevsky on 03.01.2022.
//

import UIKit
import MapKit

class LocationSearchTable : UITableViewController {
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate: HandleMapSearch? = nil
}

extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in guard let response = response else { return }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        
        //let address = "\(selectedItem.thoroughfare ?? "") \(selectedItem.locality ?? "") \(selectedItem.subLocality ?? "") \(selectedItem.administrativeArea ?? "") \(selectedItem.country ?? "")"
        let address = "\(selectedItem.locality ?? "[Undefined]")"
        cell.detailTextLabel?.text = address
        
        return cell
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        
        let currentCell = tableView.cellForRow(at: indexPath)
        handleMapSearchDelegate?.setAddressText(address: (currentCell?.detailTextLabel?.text) ?? "Undefined")
        
        handleMapSearchDelegate = nil
        self.dismiss(animated: true)
    }
}
