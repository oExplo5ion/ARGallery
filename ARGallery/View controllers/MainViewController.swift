import UIKit
import RxSwift
import RxCocoa
import Darwin
import AVFoundation
import Photos

class MainViewController: BaseViewController {
    
    private let cameraSwitch = UISwitch()
    private let photoSwitch = UISwitch()
    private let startBtn = UIButton()
    
    private var hasAccess:Bool{
        return cameraSwitch.isOn && photoSwitch.isOn
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            showNoCameraAlert()
        }
    }
    
    override func bindUI() {
        _ = cameraSwitch.rx.isOn.bind { (isOn) in
            if !isOn{
                self.requestCameraAccess()
            }
        }
        
        _ = photoSwitch.rx.isOn.bind(onNext: { (isOn) in
            if !isOn{
                self.requestLibraryAccess()
            }
        })
        
        _ = startBtn.rx.tap
            .bind { () in
                self.openArgallery()
        }
    }
    
    private func openArgallery(){
        guard hasAccess == true else {
            self.showNeedAccessAlert()
            return
        }
        self.navigationController?.pushViewController(GalleryViewController(), animated: true)
    }
    
    private func openSettings(){
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    private func showNoCameraAlert(){
        let alert = UIAlertController(title: R.String.sad_emoji,
                                      message: R.String.no_camera_text,
                                      preferredStyle: .alert)
        let okOption = UIAlertAction(title: R.String.ok_option,
                                     style: .default) { (action) in
                                        exit(0)
        }
        alert.addAction(okOption)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func requestCameraAccess(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (result) in
            DispatchQueue.main.async {
                self.cameraSwitch.isOn = result
            }
        }
    }
    
    private func requestLibraryAccess(){
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status{
            case .authorized:
                DispatchQueue.main.async {
                    self.photoSwitch.isOn = true
                }
                    break
            case .denied:
                DispatchQueue.main.async {
                    self.photoSwitch.isOn = false
                }
                    break
            case .notDetermined:
                DispatchQueue.main.async {
                    self.photoSwitch.isOn = false
                }
                break
            case .restricted:
                DispatchQueue.main.async {
                    self.photoSwitch.isOn = false
                }
                break
            }
        }
    }
    
    private func showNeedAccessAlert(){
        let alert = UIAlertController(title: R.String.thinking_emoji,
                                      message: R.String.no_access_message,
                                      preferredStyle: .alert)
        let okOption = UIAlertAction(title: R.String.ok_option,
                                     style: .default) { (action) in
                                        self.openSettingsApp()
        }
        alert.addAction(okOption)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func openSettingsApp(){
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
        }
    }
}

extension MainViewController{
    func setupUI(){
        self.view.backgroundColor = R.Color.dark_blue_color
        self.setupNavBar()
        
        let cameraLabel = UILabel()
        self.view.addSubview(cameraLabel)
        cameraLabel.translatesAutoresizingMaskIntoConstraints = false
        cameraLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -50).isActive = true
        cameraLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive = true
        cameraLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        cameraLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cameraLabel.text = R.String.camera_access
        cameraLabel.textColor = .white
        cameraLabel.textAlignment = .center
        
        self.view.addSubview(cameraSwitch)
        cameraSwitch.translatesAutoresizingMaskIntoConstraints = false
        cameraSwitch.centerYAnchor.constraint(equalTo: cameraLabel.centerYAnchor, constant: 0).isActive = true
        cameraSwitch.leftAnchor.constraint(equalTo: cameraLabel.rightAnchor, constant: 15).isActive = true
        cameraSwitch.isUserInteractionEnabled = false
        
        let photoLabel = UILabel()
        self.view.addSubview(photoLabel)
        photoLabel.translatesAutoresizingMaskIntoConstraints = false
        photoLabel.topAnchor.constraint(equalTo: cameraLabel.bottomAnchor, constant: 0).isActive = true
        photoLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -50).isActive = true
        photoLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        photoLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        photoLabel.text = R.String.photo_library_access
        photoLabel.textColor = .white
        photoLabel.textAlignment = .center
        
        self.view.addSubview(photoSwitch)
        photoSwitch.translatesAutoresizingMaskIntoConstraints = false
        photoSwitch.centerYAnchor.constraint(equalTo: photoLabel.centerYAnchor, constant: 0).isActive = true
        photoSwitch.leftAnchor.constraint(equalTo: photoLabel.rightAnchor, constant: 15).isActive = true
        photoSwitch.isUserInteractionEnabled = false
        
        // start button
        self.view.addSubview(startBtn)
        startBtn.translatesAutoresizingMaskIntoConstraints = false
        startBtn.layer.borderColor = UIColor.white.cgColor
        startBtn.layer.borderWidth = 2
        startBtn.layer.cornerRadius = 20.0
        startBtn.setTitle(R.String.open_ar_gallery, for: .normal)
        startBtn.setTitleColor(.white, for: .normal)
        startBtn.setImage(R.Image.ic_forward, for: .normal)
        startBtn.semanticContentAttribute = .forceRightToLeft
        startBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
        startBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        startBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        startBtn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        startBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    func setupNavBar(){
        let settingsBtn = UIBarButtonItem(image: R.Image.ic_settings,
                                          style: .plain,
                                          target: self,
                                          action: nil)
        settingsBtn.tintColor = .white
        _ = settingsBtn.rx.tap
            .bind { () in
                self.openSettings()
        }
        self.navigationItem.rightBarButtonItem = settingsBtn
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}




















