//
//  GameScreen.swift
//  ProbablyNotAGame
//
//  Created by Miguel Sicart on 20/12/2022.
//

import UIKit
import AVKit
import Lumina
import CoreML


class GameScreen: UIViewController
{
    
    //MARK: - Variables
    let camera = LuminaViewController()

   
    override func viewDidAppear(_ animated: Bool) {
        print("Game Screen")

        camera.delegate = self
        
        //presenting the camera view
        camera.modalPresentationStyle = .fullScreen
        camera.position = .back
        camera.textPrompt = "Find something that is not but could be"
        camera.resolution = .highest
        camera.setSwitchButton(visible: false)
        camera.streamingModels = [LuminaModel(model: MobileNetV2().model, type: "MobileNet")]
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        present(camera, animated: true, completion: nil)


        // Do any additional setup after loading the view.
    }
    

}
//MARK: COMPLYING TO LUMINA
extension GameScreen: LuminaDelegate
{
    /*func captured(stillImage: UIImage, livePhotoAt: URL?, depthData: Any?, from controller: LuminaViewController) {
        controller.dismiss(animated: true) {
            self.performSegue(withIdentifier: "presentCameraSegue", sender: ["stillImage": stillImage, "livePhotoURL": livePhotoAt as Any, "depthData": depthData as Any, "isPhotoSelfie": controller.position == .front ? true : false])
        }
    }*/

    func detected(metadata: [Any], from controller: LuminaViewController) {
        print(metadata)
    }
    
    func dismissed(controller: LuminaViewController) {
        print("dismissed")
        controller.dismiss(animated: true, completion: {
            let vc = TitleScreen()
            self.present(vc, animated: true,completion: nil)
        })
        
        
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
            resultString.append("\(String(describing: prediction.type)): \(values[1].name)" + "\r\n") // here we write which model does the prediction, adn return the second element of the array.

          }
          controller.textPrompt = resultString

    }
}
