//
//  RealTitleScreen.swift
//  ProbablyNotAGame
//
//  Created by Miguel Sicart on 28/09/2023.
//

//https://www.youtube.com/watch?v=xDJ8eIYih1k
//https://guides.codepath.com/ios/Creating-a-Custom-Camera-View

import UIKit
import AVFoundation

class RealTitleScreen: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
    @IBOutlet weak var previewView: UIView!
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        previewView.layer.cornerRadius = 5
        previewView.layer.masksToBounds = true
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .low
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        else {
            print("Unable to access back camera!")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            
            if captureSession.canAddInput(input)
            {
                captureSession.addInput(input)
                setupLivePreview()
            }
        }
        catch let error {
            print("Error unable to initialize back camera: \(error.localizedDescription)")
        }
    }
    
    func setupLivePreview()
    {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.previewView.bounds
        }
     
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Probably Not - A Game"
        view.backgroundColor = .systemGreen
        navigationController?.navigationBar.tintColor = .label
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: previewView.frame.width, height: 100))
        titleLabel.center.x = self.view.center.x
        titleLabel.center.y = self.view.center.y - 100
        titleLabel.numberOfLines = 0
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.text = "PROBABLY NOT - A GAME"
        titleLabel.textAlignment = .center
        titleLabel.shadowColor = .systemMint
        titleLabel.backgroundColor = .systemMint.withAlphaComponent(0.8)
        titleLabel.layer.cornerRadius = 5
        titleLabel.layer.masksToBounds = true
        
        view.addSubview(titleLabel)
       

        
        //Buttons
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        button.center.x = self.view.center.x
        button.center.y = self.view.center.y + 100
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = .systemMint.withAlphaComponent(0.6)
        button.setTitle("PLAY!", for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tappedPlay), for: .touchUpInside)

        view.addSubview(button)
        
        
        let tutorialButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        tutorialButton.center.x = self.view.center.x
        tutorialButton.center.y = view.frame.height - 75
        tutorialButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        tutorialButton.backgroundColor = .systemMint.withAlphaComponent(0.7)
        tutorialButton.setTitle("LEARN TO PLAY!", for: .normal)
        tutorialButton.layer.cornerRadius = 12
        tutorialButton.layer.masksToBounds = true
        tutorialButton.addTarget(self, action: #selector(tappedTutorial), for: .touchUpInside)
        
        view.addSubview(tutorialButton)
        
        let dailyButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        dailyButton.center.x = self.view.center.x - 95
        dailyButton.center.y = 125
        dailyButton.titleLabel?.font = .boldSystemFont(ofSize: 12)
        dailyButton.backgroundColor = .systemMint.withAlphaComponent(0.7)
        dailyButton.setTitle("Daily Challenge", for: .normal)
        dailyButton.layer.cornerRadius = 8
        dailyButton.layer.masksToBounds = true
        dailyButton.addTarget(self, action: #selector(tappedDaily), for: .touchUpInside)
        
        view.addSubview(dailyButton)
        
        let durationalButton = UIButton(frame: CGRect(x: 0, y: 0, width: 105, height: 40))
        durationalButton.center.x = self.view.center.x + 95
        durationalButton.center.y = 125
        durationalButton.titleLabel?.font = .boldSystemFont(ofSize: 12)
        durationalButton.backgroundColor = .systemMint.withAlphaComponent(0.7)
        durationalButton.setTitle("Daily Durational", for: .normal)
        durationalButton.layer.cornerRadius = 8
        durationalButton.layer.masksToBounds = true
        durationalButton.addTarget(self, action: #selector(tappedDurational), for: .touchUpInside)
        
        view.addSubview(durationalButton)
        
        //button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        configureNavigationItems()
    }
    
    private func configureNavigationItems()
    {
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.leftBarButtonItems =  [
            UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: nil)
            ]
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.circle"), style: .done, target: self, action: nil)
        ]
        
        //Custom view
        let customView = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        customView.text = "Label"
        customView.textAlignment = .center
        customView.backgroundColor = .orange
        customView.layer.cornerRadius = 8
        customView.layer.masksToBounds = true
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customView)
    }
    
    @objc func tappedPlay()
    {
//        let vc = UIViewController()
//        vc.title = "View 2"
//        vc.view.backgroundColor = .systemGreen.withAlphaComponent(0.3)
//        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .done, target: self, action: nil)
//        navigationController?.pushViewController(vc, animated: true)
        print("Play")
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    @objc func tappedTutorial()
    {
//        let vc = UIViewController()
//        vc.title = "View 2"
//        vc.view.backgroundColor = .systemGreen.withAlphaComponent(0.3)
//        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .done, target: self, action: nil)
//        navigationController?.pushViewController(vc, animated: true)
        print("Tutorial")
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    @objc func tappedDaily()
    {
//        let vc = UIViewController()
//        vc.title = "View 2"
//        vc.view.backgroundColor = .systemGreen.withAlphaComponent(0.3)
//        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .done, target: self, action: nil)
//        navigationController?.pushViewController(vc, animated: true)
        print("Daily")
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    @objc func tappedDurational()
    {
//        let vc = UIViewController()
//        vc.title = "View 2"
//        vc.view.backgroundColor = .systemGreen.withAlphaComponent(0.3)
//        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .done, target: self, action: nil)
//        navigationController?.pushViewController(vc, animated: true)
        print("Durational")
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}
