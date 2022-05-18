import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UtilsScanner{
  UtilsScanner._();

  static Future<CameraDescription> getCamera(CameraLensDirection cameraLensDirection) async{

    return await availableCameras().then(
            (List<CameraDescription>camera) => camera.firstWhere((CameraDescription cameraDescription) => cameraDescription.lensDirection == cameraDescription)
    );
  }

  static ImageRotation rotationIntToImageRotation(int rotaion){

    switch(rotaion){
      case 0:
        return ImageRotation.rotation0;

      case 90:
        return ImageRotation.rotation90;
      case 180:
        return ImageRotation.rotation180;

        default:
          assert(rotaion==270);
          return ImageRotation.rotation270;

    }

  }

  static Uint8List concatenaePlanes(List<Plane> planes){
    final WriteBuffer allBytes =  WriteBuffer();

    for(Plane plane in planes){
      allBytes.putUint8List(plane.bytes);
    }

    return allBytes.done().buffer.asUint8List();
  }

  static FirebaseVisionImageMetadata buildMetadata(CameraImage image, ImageRotation rotation)
  {
            return FirebaseVisionImageMetadata(
                                        size: Size(image.width.toDouble(), image.height.toDouble()),
                                        rotation: rotation,
                                        rawFormat: image.format.raw,
                                         planeData: image.planes.map((Plane plane)
                                         {
                                           
                                           return FirebaseVisionImagePlaneMetadata(
                                               bytesPerRow: plane.bytesPerRow,
                                               height:plane.height,
                                               width:plane.width,
                                           );
                                          }).toList(),
            );
  }

  static Future<dynamic>detect({required CameraImage image, required Future<dynamic> Function(FirebaseVisionImage image) detectImage, required int imageRotation}) async{

    return detectImage(
      FirebaseVisionImage.fromBytes(concatenaePlanes(image.planes), 
          buildMetadata(image, rotationIntToImageRotation(imageRotation))
      ),
    );
  }

}