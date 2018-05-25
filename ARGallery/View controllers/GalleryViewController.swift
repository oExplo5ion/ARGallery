import UIKit
import ARKit
import Photos
import RxSwift
import RxCocoa

class GalleryViewController: BaseViewController {
    
    private let sceneView = ARSCNView()
    private var cameraFrame: ARFrame?
    private var cards: Variable<[SCNNode]> = Variable([])
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        DispatchQueue.main.async {
            self.getImages()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        let options = ARSession.RunOptions()
        sceneView.session.delegate = self
        sceneView.session.run(configuration, options: options)
    }
    
    override func bindUI() {
        _ = cards.asObservable().subscribe(onNext: { (node) in
            print("next")
        }, onError: { (error) in
            print("error")
        }, onCompleted: {
            print("complited")
        }) {
            
        }
        
    }
    
    private func getImages(){
        // fetch assets
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = 100
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        guard fetchResult.count >= 1 else {
            return
        }
        
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        let phmanager = PHImageManager.default()
        for i in 0..<fetchResult.count{
            phmanager.requestImage(for: fetchResult.object(at: i),
                                   targetSize: CGSize(width: 500, height: 500),
                                   contentMode: .aspectFill,
                                   options: options) { (image, _) in
                                    guard image != nil else { return }
                                    self.createPhotoCard(image: image!)
            }
        }
    }
    
    private func createPhotoCard(image:UIImage){
        guard cameraFrame != nil else { return }
        
        let material = SCNMaterial()
        material.isDoubleSided = false
        material.diffuse.contents = image
        let box = SCNBox(width: 0.1, height: 0.1, length: 0, chamferRadius: 0)
        box.materials = [material]
        
        // random position
        let lowerValue = -2
        let upperValue = 2
        let lowerY = 0
        let upperY = 1
        let ranX = Int(arc4random_uniform(UInt32(upperValue - lowerValue + 1))) + lowerValue
        let ranZ = Int(arc4random_uniform(UInt32(upperValue - lowerValue + 1))) + lowerValue
        let ranY = Int(arc4random_uniform(UInt32(upperY - lowerY + 1))) + lowerY
        
        let card = SCNNode(geometry: box)
        card.position = SCNVector3(0, 0, -0.1)
//        card.orientation
        sceneView.scene.rootNode.addChildNode(card)
        
        card.runAction(SCNAction.moveBy(x: CGFloat(ranX),
                                        y: CGFloat(ranY),
                                        z: CGFloat(ranZ),
                                        duration: 0.5))
        cards.value.append(card)
    }
    
    private func displayNoImagesAlert(){
        let alert = UIAlertController(title: R.String.happy_emoji,
                                      message: R.String.no_images_found_text,
                                      preferredStyle: .alert)
        let okOption = UIAlertAction(title: R.String.ok_option,
                                     style: .default) { (action) in
                                        self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okOption)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

}

// MARK: Extensions
extension GalleryViewController{
    func setupUI(){
        self.view.backgroundColor = R.Color.dark_blue_color
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        sceneView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        sceneView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        blurView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        blurView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    }
}

extension GalleryViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        cameraFrame = frame
    }
}

























