//
//  SearchViewController.swift
//  ChowTime
//
//  Created by Jason Zheng on 7/10/21.
//

import UIKit

class SearchViewController: UIViewController {
    private let spacing: CGFloat = 10.0
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var catCollectionView: UICollectionView!
    let categories = ["African",  "American",  "British",  "Cajun",  "Caribbean",  "Chinese",  "Eastern",  "European",  "European",  "French",  "German",  "Greek",  "Indian",  "Irish",  "Italian",  "Japanese",  "Jewish",  "Korean",  "Latin",  "American",  "Mediterranean",  "Mexican",  "Middle",  "Eastern",  "Nordic",  "Southern",  "Spanish",  "Thai",  "Vietnamese"]
    var catSelected: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        catCollectionView.delegate = self
        catCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue .identifier == "ResultsView" {
            let dest = segue.destination as! ResultsViewController
            if let category = catSelected {
                dest.category = category
            } else {
                dest.searchText = searchBar.text!
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            if searchBar.text != "" {
                catSelected = nil
                performSegue(withIdentifier: "ResultsView", sender: nil)
            }
        }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = ""
    }
}

extension SearchViewController: UICollectionViewDelegate{
    
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCollectionViewCell", for: indexPath) as! CatCollectionViewCell
        cell.catLabel.text = categories[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        catSelected = categories[indexPath.item]
        performSegue(withIdentifier: "ResultsView", sender: nil)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 10
            
            let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.catCollectionView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width, height: width * 0.75)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
}
