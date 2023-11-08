//
//  UserViewController.swift
//  ScandTest
//
//  Created by Alex on 5.11.23.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var refresh = UIRefreshControl()
    
    private let imageFetcher: ImageFetcher? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        let fetcher = ImageFetcher()
        Task {
            await fetcher.setContext(context: context)
        }
        return fetcher
    }()
    private let productNetworkManager: ProductNetworkManager = FirestoreProductNetworkManager()
    private lazy var store = ProductStore { [weak self] in
        self?.updateProductsDisplayed()
    }
    
    private var productsDisplayed = [Product]()
    
    private func updateProductsDisplayed() {
        Task { [weak self] in
            self?.productsDisplayed = await (self?.store.items)!
            self?.collectionView.reloadData()
        }
    }
    
    private func fetchProductsfromNetwork() async {
        do {
            let receivedProducts = try await productNetworkManager.loadAllProducts()
            await store.removeAll()
            for product in receivedProducts {
                await store.add(product)
            }
            for product in await store.items {
                if let photo = product.photo {
                    switch photo {
                    case .url(let url):
                        Task.detached { [weak self] in
                            var editedProduct = product
                            editedProduct.photo = await .image(data: self?.imageFetcher?.imageData(forUrl:url))
                            await self?.store.update(editedProduct)
                            await self?.collectionView.reloadData()
                        }
                    case .image:
                        break
                    }
                }
            }
        } catch {
            print("error while loading products from firebase: \(error)")
        }
    }
    
    private weak var sheetPresented: ProductSheet?
    
    func openSheet(withProductIndex productIndex: Int) {
        let viewControllerToPresent = ProductSheet()
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = false
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
        }
        if sheetPresented != nil {
            sheetPresented?.setup(productsDisplayed[productIndex])
        } else {
            present(viewControllerToPresent, animated: true, completion: nil)
            sheetPresented = viewControllerToPresent
            viewControllerToPresent.setup(productsDisplayed[productIndex])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.refresh.addTarget(self, action: #selector(fetchProducts), for: .valueChanged)
        self.refresh.tintColor = .label
        self.collectionView.addSubview(self.refresh)
        self.refresh.beginRefreshing()
        self.fetchProducts()
    }
    
    @objc func fetchProducts() {
        Task.detached { [weak self] in
            await self?.fetchProductsfromNetwork()
            await self?.refresh.endRefreshing()
        }
    }
    
}
extension UserViewController: UICollectionViewDataSource ,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productsDisplayed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: "ProductCell",
                for: indexPath) as! ProductCell
        cell.setup(productsDisplayed[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let gridItemWidth = (screenWidth - 48) / 2.0
        return CGSize(width: gridItemWidth, height: gridItemWidth * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openSheet(withProductIndex: indexPath.item)
    }
    
}

