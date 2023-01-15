//
//  TitleScreen.swift
//  ProbablyNotAGame
//
//  Created by Miguel Sicart on 20/12/2022.
//

import UIKit
import Lumina
import CoreML
import AVKit
import Foundation


class TitleScreen: UIViewController {
    
        
    
    @IBOutlet weak var TitleLabel: UILabel!
    var seconds = 30
    var timer: Timer! = nil
    var winning = 0;
    
    override func viewDidAppear(_ animated: Bool) {
        print("I am here now")
        print(winning)
        switch winning {
        case 0:
            print("starting the game")
        case 1:
            print("Time's up")
        case 2:
            print("Quit the game")
        default:
            print("there is nothing to fault")
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("I am here")
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Oulets
    @IBAction func playButton(_ sender: Any)
    {
        print("Play button")
        //code for setting up the camera and presenting the view goes here.
        //creating the camera view controller
        let camera = LuminaViewController()
        camera.delegate = self


        //presenting the camera view
        camera.modalPresentationStyle = .fullScreen
        camera.position = .back
        camera.textPrompt = "Find something that is not but could be"
        camera.resolution = .highest
        camera.setSwitchButton(visible: false)
        camera.streamingModels = [LuminaModel(model: MobileNetV2().model, type: "MobileNet")]
        present(camera, animated: true, completion: nil)
        startCountdownTimer()
    }
    
    func startCountdownTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.seconds > 0 {
                //print("\(self.seconds) seconds remaining")
                self.seconds -= 1
            } else {
                timer.invalidate()
                //print("Time's up!")
            }
        }
    }

    
    //MARK: SEGUE FUNCTION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
      if segue.identifier == "title_to_game"{
        guard let controller = segue.destination as? GameScreen else { return }
        /*if let map = sender as? [String: Any] {
          controller.image = map["stillImage"] as? UIImage
          controller.livePhotoURL = map["livePhotoURL"] as? URL
          guard let positionBool = map["isPhotoSelfie"] as? Bool else { return }
          controller.position = positionBool ? .front : .back
        } else { return }*/
      }
    }
}

//MARK: COMPLYING TO LUMINA
extension TitleScreen: LuminaDelegate
{
//    func captured(stillImage: UIImage, livePhotoAt: URL?, depthData: Any?, from controller: LuminaViewController) {
//        controller.dismiss(animated: true) {
//            self.performSegue(withIdentifier: "title_to_game", sender: ["stillImage": stillImage, "livePhotoURL": livePhotoAt as Any, "depthData": depthData as Any, "isPhotoSelfie": controller.position == .front ? true : false])
//        }
//    }

    func detected(metadata: [Any], from controller: LuminaViewController) {
        print(metadata)
    }

    func dismissed(controller: LuminaViewController) {
        controller.dismiss(animated: true, completion: nil)
        self.timer.invalidate()
        self.seconds = 30
        self.winning = 2
    }
    
    func dismissedW(controller: LuminaViewController, result: Int)
    {
        controller.dismiss(animated: true, completion: nil)
        self.timer.invalidate()
        self.seconds = 30
        self.winning = result
    }

    func streamed(videoFrame: UIImage, with predictions: [LuminaRecognitionResult]?, from controller: LuminaViewController) {
        guard let predicted = predictions else {
            return
          }
          var resultString = String()
          for prediction in predicted {
            guard let values = prediction.predictions else {
              continue
            }
            guard let bestPrediction = values.first else {
              continue
            }
              //print(values[1].name) //. This is the way to get the second element of the array.
            //resultString.append("\(String(describing: prediction.type)): \(bestPrediction.name)" + "\r\n")
            //resultString.append("\(String(describing: prediction.type)): \(values[1].name)" + "\r\n") // here we write which model does the prediction, adn return the second element of the array.
              resultString.append("This is not but could be: \(values[1].name)" + "\r\n" + String(self.seconds)) // here we write which model does the prediction, adn return the second element of the array.
              if(self.seconds == 0)
              {
                  self.timer.invalidate()
                  self.seconds = 30
                  dismissedW(controller: controller, result: 1)
              }

          }
          controller.textPrompt = resultString

    }
}

//MARK: PIXELBUFFER EXTENSION
extension CVPixelBuffer
{
  func normalizedImage(with position: CameraPosition) -> UIImage? {
    let ciImage = CIImage(cvPixelBuffer: self)
    let context = CIContext(options: nil)
    if let cgImage = context.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(self), height: CVPixelBufferGetHeight(self))) {
      return UIImage(cgImage: cgImage, scale: 1.0, orientation: getImageOrientation(with: position))
    } else {
      return nil
    }
  }

  private func getImageOrientation(with position: CameraPosition) -> UIImage.Orientation {
    let orientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation ?? .portrait
    switch orientation {
      case .landscapeLeft:
        return position == .back ? .down : .upMirrored
      case .landscapeRight:
        return position == .back ? .up : .downMirrored
      case .portraitUpsideDown:
        return position == .back ? .left : .rightMirrored
      case .portrait:
        return position == .back ? .right : .leftMirrored
      case .unknown:
        return position == .back ? .right : .leftMirrored
      @unknown default:
        return position == .back ? .right : .leftMirrored
    }
  }
}
