//
//  UserViewController.swift
//  ScandTest
//
//  Created by Alex on 5.11.23.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let nm: ProductNetworkManager = FirebaseProductNetworkManager()
    private lazy var store = ProductStore { [weak self] in
        print("store updated!!!")
        self?.updateProductsDisplayed()
    }
    
    private var productsDisplayed = [Product(name: "Name", price: 9.99)]
    private func updateProductsDisplayed() {
        Task { [weak self] in
            self?.productsDisplayed = await (self?.store.items)!
            self?.collectionView.reloadData()
        }
    }
    
    private func fetchProductsfromNetwork() async {
        do {
            let receivedProducts = try await nm.loadAllProducts()
            for product in receivedProducts {
                await store.add(product)
            }
            await withTaskGroup(of: Void.self) { group in
                for product in await store.items {
                    if let photo = product.photo {
                        switch photo {
                        case .url(let url):
                            group.addTask {
                                //TODO: add photo fetch & cache
                            }
                        case .image:
                            break
                        }
                    }
                }
            }
            
//                    .addProduct(
//                    Product(
//                        name: "pr1",
//                        price: 0.0,
//                        photo: .url(URL(string: "https://i.pinimg.com/736x/f4/d2/96/f4d2961b652880be432fb9580891ed62.jpg")!),
//                        description: "wdjskdf fkklfl qkrjfeljqkf"))
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
    }
    
    @IBAction func saddas(_ sender: UIButton) {
        Task.detached {
            await self.fetchProductsfromNetwork()
        }
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
        let gridItemWidth = (screenWidth - 42) / 2.0
        return CGSize(width: gridItemWidth, height: gridItemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: open a modal
        openSheet(withProductIndex: indexPath.item)
    }
    
}

