import 'package:camera/camera.dart';
import 'package:face_detection/utils_scanner.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isWorking=false;

  CameraController? cameraController;

  FaceDetector? faceDetector;
  Size? size;

  List<Face>? faceList;

  CameraDescription? description;

  CameraLensDirection cameraDirection = CameraLensDirection.front;


  initCamera ()async{
    description= await UtilsScanner.getCamera(cameraDirection);
    cameraController = CameraController(description, ResolutionPreset.medium);

    faceDetector = FirebaseVision.instance.faceDetector(const FaceDetectorOptions(
      enableClassification: true,
      minFaceSize: 0.1,
      mode: FaceDetectorMode.fast
    ));

    await cameraController!.initialize().then((value)
    {
        if(!mounted){
          return;
        }
        cameraController!.startImageStream((imageFromStream) => null)
    })

  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
