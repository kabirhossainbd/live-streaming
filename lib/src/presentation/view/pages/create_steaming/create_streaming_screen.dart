import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:live_streaming/controller/auth_controller.dart';
import 'package:live_streaming/controller/home_controller.dart';
import 'package:live_streaming/controller/meeting_controller.dart';
import 'package:live_streaming/controller/streaming_controller.dart';
import 'package:live_streaming/model/response/body/join_info.dart';
import 'package:live_streaming/model/response/body/room_body.dart';
import 'package:live_streaming/src/utils/constants/m_colors.dart';
import 'package:live_streaming/src/utils/constants/m_dimensions.dart';
import 'package:live_streaming/src/utils/constants/m_helper.dart';
import 'package:live_streaming/src/utils/constants/m_images.dart';
import 'package:live_streaming/src/utils/constants/m_styles.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

late List<CameraDescription> cameras;
class AddVideoScreen extends StatefulWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

  @override
  State<AddVideoScreen> createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> with WidgetsBindingObserver, TickerProviderStateMixin {

  bool backPressed = false;
  late AnimationController controllerToIncreasingCurve;
  late AnimationController controllerToDecreasingCurve;
  late Animation<double> animationToIncreasingCurve;
  late Animation<double> animationToDecreasingCurve;

  late ScrollController controller;
  CameraController? _cameraController;
  Future<void>?  cameraValue;

  webrtc.MediaStream? _localStream;
  webrtc.RTCVideoRenderer? _localRenderer;

  final TextEditingController _chatTitle = TextEditingController();
  final FocusNode _chatFocus = FocusNode();


  // final List<String> _tabList = ['Multi-guest LIVE', 'LIVE', 'Audio LIVE', 'Auction Live House'];
  final List<String> _itemList = ['Post', 'Story', 'LIVE'];
  final List<String> _titleList = [
    '4',
    '6',
    '9',
    '12',
  ];


  /// User Age
  double _years = 0;

  @override
  void initState() {
    super.initState();

    _localRenderer = webrtc.RTCVideoRenderer();
    WidgetsBinding.instance.addObserver(this);
    controllerToIncreasingCurve = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    controllerToDecreasingCurve = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animationToIncreasingCurve = Tween<double>(begin: 500, end: 0).animate(
      CurvedAnimation(
        parent: controllerToIncreasingCurve,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    )..addListener(() {
      setState(() {});
    });

    animationToDecreasingCurve = Tween<double>(begin: 0, end: 200).animate(
      CurvedAnimation(
        parent: controllerToDecreasingCurve,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    )..addListener(() {
      setState(() {});
    });

    controllerToIncreasingCurve.forward();


    KeepScreenOn.turnOn(true).then((value) => debugPrint('Keep Screen On'));
    Get.find<StreamingController>().changeButton( Get.find<StreamingController>().pageIndex, false);
    Get.find<StreamingController>().initPageCon();
    Get.find<StreamingController>().changeButton(1, false);
    controller = ScrollController();


    if(Platform.isAndroid){
      checkCameraPermission().then((value) {
        if(value.isDenied){
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Get.dialog( AlertDialog(
              alignment: Alignment.center,
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                Padding(
                    padding: const EdgeInsets.only(right: 24, bottom: 16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: (){
                            checkPer().then((value) {
                              if(value == 'denied'){
                                debugPrint('--------->>>>denied');
                              }else if(value == 'permanentlyDenied'){
                                Get.back();
                                openSettingsDialog(Get.context);
                              }else{
                                _initRenderer();
                                Get.back(result: 'done');
                              }
                            });
                          },
                          child: Text('confirm',
                            style: robotoMedium.copyWith(
                                color: MyColor.getPrimaryColor(),
                                fontSize:
                                Dimensions.fontSizeDefault),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )
                      ),
                    )
                )
              ],
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
              title: RichText(
                text: TextSpan(
                    text: 'to_broadcast_live_vide',
                    style: robotoRegular.copyWith(
                        color: MyColor.colorBlack,
                        fontSize: Dimensions.fontSizeDefault),
                    children: [
                      TextSpan(text: 'KUAA', style: robotoBold.copyWith(
                          color: MyColor.colorBlack,
                          fontSize: Dimensions.fontSizeDefault)),

                      TextSpan(text: 'to_broadcast_live2',
                          style: robotoRegular.copyWith(
                              color: MyColor.colorBlack,
                              fontSize: Dimensions.fontSizeDefault)),
                    ]
                ),
              ),
            ));
          });
        }else if(value.isGranted){
          _initRenderer();
        }
      });
    }
  }
  initCamera() async{
    cameras = await availableCameras().then((cameras) {
      _cameraController = CameraController(cameras[1], ResolutionPreset.max);
      _cameraController?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
      return cameras;
    });
  }

  Future<PermissionStatus> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status;
  }

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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    KeepScreenOn.turnOn(false).then((value) => debugPrint('Keep Screen Off'));
    _cameraController?.dispose();
    //_localRenderer.dispose();
    controllerToIncreasingCurve.dispose();
    controllerToDecreasingCurve.dispose();
    Get.find<StreamingController>().pageController?.dispose();
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    switch (state) {
      case AppLifecycleState.resumed:
      // if (_cameraController != null) {
      //   onNewCameraSelected(_cameraController!.description);
      // }
        debugPrint('Resumed');
        break;
      case AppLifecycleState.inactive:
      // _cameraController?.dispose();
        debugPrint('Inactive');
        break;
      case AppLifecycleState.paused:
        debugPrint('Paused');
        break;
      case AppLifecycleState.detached:
        debugPrint('Detached');
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
  }



  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_cameraController != null) {
      await _cameraController?.dispose();
    }
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );
    _cameraController?.addListener(() {
      if (mounted) setState(() {});
      if (_cameraController!.value.hasError) {}
    });

    try {
      await _cameraController?.initialize();
    } on CameraException catch (e) {
      debugPrint(e.toString());
    }
    if (mounted) {
      setState(() {});
    }
  }



  // Widget _cameraPreview(){
  //   if (_cameraController == null) {
  //     return  Container(color: Colors.black,);
  //   }else if(!_cameraController!.value.isInitialized){
  //     return Container(color: Colors.black);
  //   }
  //   return  Container(
  //     color: Colors.black,
  //     height: double.infinity,
  //     width: double.infinity,
  //     child: CameraPreview(_cameraController!),
  //   );
  // }


  Widget _cameraPreview(){
    if (_localRenderer == null) {
      return Container(color: Colors.black,);
    }
    return  Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
      child: webrtc.RTCVideoView(_localRenderer!, mirror: true,  objectFit: webrtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,),
    );
  }


  @override
  Widget build(BuildContext context) {

    return GetBuilder<HomeController>(
      builder: (profile) => GetBuilder<StreamingController>(
          builder: (streamCon) {

            return NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowIndicator();
                return true;
              },
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: WillPopScope(
                  onWillPop: ()async{
                    backPressed = true;
                    controllerToDecreasingCurve.forward();
                    return true;
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      backPressed == false ? animationToIncreasingCurve.value : animationToDecreasingCurve.value,
                    ),
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      backgroundColor: MyColor.getBottomSheetColor(),
                      body: Stack( alignment: Alignment.center,
                        children: [
                          streamCon.isLiveTab == 1 ? _cameraPreview() :  Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xff4646AF),
                                    Color(0xFF4646BD),
                                    Color(0xFF000077)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                  stops: [0.1, 0.5, 1.0],
                                  tileMode: TileMode.mirror),
                            ),
                          ),


                          /// single room
                          GetBuilder<HomeController>(
                            builder: (user) => GetBuilder<MeetingController>(
                              builder: (meeting) => GetBuilder<StreamingController>(
                                builder: (stream) {
                                  return InkWell(
                                    onTap: (){
                                      setState(() {
                                        _chatFocus.unfocus();
                                        _chatFocus.canRequestFocus = false;
                                      });
                                    },
                                    child: Container(
                                      decoration:  const BoxDecoration(
                                        //color: Color(0xFF0A072E),
                                        color: Colors.transparent,
                                      ),
                                      child: Column( crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.only(left: 24.0, top: 35, right: 25),
                                            child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(),
                                                InkWell(
                                                    splashColor: Colors.transparent,
                                                    highlightColor: Colors.transparent,
                                                    hoverColor: Colors.transparent,
                                                    focusColor: Colors.transparent,
                                                    onTap: () {
                                                      backPressed = true;
                                                      controllerToDecreasingCurve.forward();
                                                      Get.back();
                                                    },
                                                    child: const Icon(Icons.close, color: Colors.white,)),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 5),

                                          Container(
                                            padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                                            margin: const EdgeInsets.symmetric(horizontal: 20),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF070707).withOpacity(0.35),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Column( mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
                                                  child: Row( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      InkWell(
                                                        splashColor: Colors.transparent,
                                                        highlightColor: Colors.transparent,
                                                        hoverColor: Colors.transparent,
                                                        focusColor: Colors.transparent,
                                                        onTap: streamCon.pickImage,
                                                        child: Stack(
                                                          children: [
                                                            stream.file != null ? ClipRRect(
                                                              borderRadius: BorderRadius.circular(5),
                                                              child: Image.file(
                                                                File(stream.file!.path), width: 60, height: 60, fit: BoxFit.cover,
                                                              ),
                                                            ) : ClipRRect(
                                                              borderRadius: BorderRadius.circular(5),
                                                              child: Image.asset(MyImage.image1)),
                                                            Positioned(
                                                              bottom: 0,
                                                              left: 0,
                                                              right: 0,
                                                              child: Container(
                                                                  height: 15,
                                                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                                                  alignment: Alignment.center,
                                                                  decoration:  BoxDecoration(
                                                                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),
                                                                    color: const Color(0xFF7C7C7C).withOpacity(0.7),
                                                                  ),
                                                                  child: Text('update',  style: robotoMedium.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontSizeOverExtraSmall), overflow: TextOverflow.ellipsis, maxLines: 1,)
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Column( mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: 35,
                                                            width: Get.size.width/1.8,
                                                            child: TextFormField(
                                                              controller: _chatTitle,
                                                              focusNode: _chatFocus,
                                                              style: robotoMedium.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontSizeDefault, height: 1.1),
                                                              cursorColor: MyColor.getPrimaryColor(),
                                                              keyboardType: TextInputType.text,
                                                              textInputAction: TextInputAction.done,
                                                              maxLines: 1,
                                                              minLines: 1,
                                                              cursorHeight: 18,
                                                              autofocus: false,
                                                              decoration: InputDecoration(
                                                                  border: InputBorder.none,
                                                                  focusedBorder: InputBorder.none,
                                                                  enabledBorder: InputBorder.none,
                                                                  errorBorder: InputBorder.none,
                                                                  disabledBorder: InputBorder.none,
                                                                  contentPadding: const EdgeInsets.only(bottom: 15),
                                                                  hintStyle: robotoRegular.copyWith(color:  Colors.grey, fontSize: Dimensions.fontSizeDefault, height: 1.4),
                                                                  labelStyle: robotoRegular.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontSizeDefault),
                                                                  hintText: 'add_a_title',
                                                              ),
                                                            ),
                                                          ),


                                                          //const SizedBox(height: 5,),
                                                          InkWell(
                                                           // onTap: () =>  Get.bottomSheet(const PrivacyBottomSheet()),
                                                            child: Container(
                                                              padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                                                              decoration: BoxDecoration(
                                                                  color: MyColor.colorWhite.withOpacity(0.3),
                                                                  borderRadius: BorderRadius.circular(50)
                                                              ),
                                                              child: Row( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  SvgPicture.asset(stream.privacyIndex == 0 ? MyImage.start : stream.privacyIndex == 1 ? MyImage.start : MyImage.start, width: 12, height: 12),
                                                                  const SizedBox(width: 4),
                                                                  Text(stream.privacyName, style: robotoMedium.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontSizeExtraSmall), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                                                  const SizedBox(width: 2),
                                                                  SvgPicture.asset( MyImage.about, width: 12, height: 12),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(height: 5),
                                                Container(margin: const EdgeInsets.symmetric(horizontal: 8),color: MyColor.colorSecondary,height: 0.5, width: double.infinity,),
                                               
                                              ],
                                            ),
                                          ),

                                          /// for live time

                                          const Spacer(),

                                          /// for TabList

                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 0, top: 18, left: 20, right: 20),
                                            child: Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                const SizedBox(width: 5),

                                                /// for GO LIVE Button
                                                Expanded(child: InkWell(
                                                    splashColor: Colors.transparent,
                                                    highlightColor: Colors.transparent,
                                                    hoverColor: Colors.transparent,
                                                    focusColor: Colors.transparent,
                                                    onTap: () async{
                                                      if(Platform.isAndroid){
                                                        checkCameraPermission().then((value) {
                                                          if(value.isDenied){
                                                            WidgetsBinding.instance.addPostFrameCallback((_) async {
                                                              permissionDialog();
                                                            });
                                                          }else if(value.isGranted){
                                                            stream.createRoomBody(LiveRoomBody(title: _chatTitle.text, seatType: '1', status: stream.privacyName, tags: stream.tagId), Get.find<AuthController>().getUserToken()).then((value){
                                                              if(value.isSuccess!){
                                                                //stream.setSid(stream.hostinfo!.id.toString());
                                                                bool isHost = true;
                                                                bool isViewer = false;
                                                                bool isSingle = true;
                                                                stream.handleSoloJoin(isHost, isViewer, isSingle, 0, 0, '1');
                                                                // stream.handleJoin(true, false, true, false,false, false, false, false);
                                                                //meeting.setHost(true);
                                                                meeting.setVideo(true);
                                                              }
                                                            });
                                                          }
                                                        });
                                                      }else{
                                                        stream.createRoomBody(LiveRoomBody(title: _chatTitle.text, seatType: '1', status: stream.privacyName,
                                                          tags: stream.tagId,
                                                        ), Get.find<AuthController>().getUserToken()).then((value){
                                                          if(value.isSuccess!){
                                                            //stream.setSid(stream.hostinfo!.id.toString());
                                                            bool isHost = true;
                                                            bool isViewer = false;
                                                            bool isSingle = true;
                                                            stream.handleSoloJoin(isHost, isViewer, isSingle,0,0, '1');
                                                            // stream.handleJoin(true, false, true, false,false, false, false, false);
                                                            //meeting.setHost(true);
                                                            meeting.setVideo(true);
                                                          }
                                                        });
                                                      }

                                                      // showCustomToast('Serverwartung läuft !!! Versuchen Sie es später noch einmal');
                                                    },
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      height: 46,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(12),
                                                        gradient:  const LinearGradient(
                                                            colors: [
                                                              Color(0xFF0077DD),
                                                              Color(0xFF00A8DD),
                                                            ],
                                                            begin: Alignment.centerRight,
                                                            end: Alignment.centerLeft,
                                                            stops: [0.0, 1],
                                                            tileMode: TileMode.repeated
                                                          //  stops: [ 0.9, 0.6, 0.4, 0.2,],
                                                        ),
                                                      ),
                                                      child: Text('go_live', style: robotoMedium.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontSizeDefault), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                                    )
                                                )),

                                                /// for magic emoji
                                                const SizedBox(width: 5),
                                                // SvgPicture.asset(AllImages.magicEmoji, width: 40, height: 40),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 40,),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }




  /// for permanentely deny

  openSettingsDialog(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const SizedBox(height: 15,),
                    const Text('Your Permission is Permanently Denied, so you can to go settings and open permission manually', textAlign: TextAlign.center,),
                    const SizedBox(height: 25,),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: MyColor.getPrimaryColor()),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                'Cancel',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              await openAppSettings();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: MyColor.getPrimaryColor(),
                                border: Border.all(color: MyColor.getPrimaryColor()),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Open Settings',
                                style: robotoRegular.copyWith(color: MyColor.colorWhite, ),
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

  void _initHandleJoin(HandleJoin handleJoin, StreamingController stream) {
    stream.handleJoin(handleJoin, 'receiverId');
  }

  Future<void> _initRenderer() async{
    await _localRenderer!.initialize().then((value) async {
      try{
        var stream = await webrtc.navigator.getUserMedia(<String, dynamic>{
          'video': true
        });

        _localStream = stream;
        _localRenderer!.srcObject = _localStream;

        setState(() {

        });
      }catch(e){
        debugPrint(e.toString());
      }
    });
  }
}