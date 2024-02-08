import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_streaming/src/utils/constants/m_colors.dart';
import 'package:live_streaming/src/utils/constants/m_styles.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

Future<String> downloadAndSaveFile(String url, String fileName) async {
 final Directory directory = await getApplicationDocumentsDirectory();
 final String filePath = '${directory.path}/$fileName';
 final http.Response response = await http.get(Uri.parse(url));
 final File file = File(filePath);
 await file.writeAsBytes(response.bodyBytes);

 return filePath;
}

/// for camera
Future<String> checkOnlyCameraPer() async{
 Map<Permission, PermissionStatus> permissions = await [Permission.camera].request();
 if(permissions[Permission.camera] == PermissionStatus.granted){
  return 'granted';
 }else if(permissions[Permission.camera] == PermissionStatus.denied){
  return 'denied';
 }else if(permissions[Permission.camera] == PermissionStatus.permanentlyDenied){
  return 'permanentlyDenied';
 }
 return 'permanentlyDenied';
}

/// for permanentely deny
openSettingsDialog(context) {
 showDialog(
  barrierDismissible: false,
  context: context,
  builder: (context) {
   return Dialog(
    backgroundColor: MyColor.getBackgroundColor(),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    child: Wrap(
     children: [
      Padding(
       padding: const EdgeInsets.all(15),
       child: Column(
        children: [
         const SizedBox(height: 15,),
         Text('Your Permission is Permanently Denied, so you can to go settings and open permission manually', style: robotoRegular.copyWith(color: MyColor.getHeaderTextColor()), textAlign: TextAlign.center,),
         const SizedBox(height: 25,),
         Row(
          children: [
           Expanded(
            child: InkWell(
             onTap: () => {
              Navigator.pop(context)},
             child: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
               border: Border.all(color: MyColor.getPrimaryColor()),
               borderRadius: BorderRadius.circular(5),
              ),
              child:  Text('Cancel', style: robotoRegular.copyWith(color: MyColor.getHeaderTextColor()),),
             ),
            ),
           ),
           const SizedBox(width: 10,),
           Expanded(
            child: InkWell(
             onTap: () async {
              //Get.find<SetLocationController>().toggleDiaglue(true ) ;
              Navigator.pop(context);
              await openAppSettings();
             },
             child: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
               color: MyColor.getPrimaryColor(),
               borderRadius: BorderRadius.circular(5),
              ),
              child: Text('Open Settings',
               style: robotoRegular.copyWith(color: MyColor.getBackgroundColor()), overflow: TextOverflow.ellipsis,
              ),
             ),
            ),
           ),
          ],
         ),
        ],
       ),
      )
     ],
    ),
   );
  },
 );
}


bool validateEmail(String email) {
 final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
 return emailRegex.hasMatch(email);
}

bool validateFullName(String fullName) {
 RegExp regExp = RegExp(r"^(?=.{3,30})(?![_.])(?!.*[_.]{2})(?=.*[a-zA-Z])[a-zA-Z ]*(?<![_. ])$");
 if (fullName.isEmpty) {
  return false;
 } else if (!regExp.hasMatch(fullName)) {
  return false;
 }
 return true;
}


bool validateUserName(String username, {bool socialMedia = false}) {
 final pattern = socialMedia
     ? RegExp(r'^[a-z0-9._]{2,24}$')
     : RegExp(r"^[a-z0-9_\.]{2,24}$");

 return pattern.hasMatch(username);
}

/// for camera, video,microphone
Future<String> checkPer() async{
 Map<Permission, PermissionStatus> permissions = await [Permission.camera,  Permission.microphone].request();
 if(permissions[Permission.camera] == PermissionStatus.granted && permissions[Permission.microphone] == PermissionStatus.granted ){
  return 'granted';
 }else if(permissions[Permission.camera] == PermissionStatus.denied || permissions[Permission.microphone] == PermissionStatus.denied){
  return 'denied';
 }else if(permissions[Permission.camera] == PermissionStatus.permanentlyDenied || permissions[Permission.microphone] == PermissionStatus.permanentlyDenied){
  return 'permanentlyDenied';
 }
 return 'permanentlyDenied';
}

Future<bool> promptPermissionSetting() async {
 if (Platform.isIOS && await Permission.storage.request().isGranted && await Permission.photos.request().isGranted ||
     Platform.isAndroid && await Permission.storage.request().isGranted && await Permission.photos.request().isGranted) {
  return true;
 }
 return false;
}
