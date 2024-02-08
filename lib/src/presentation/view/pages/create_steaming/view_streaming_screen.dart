import 'dart:async';
import 'dart:ui';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:live_streaming/controller/auth_controller.dart';
import 'package:live_streaming/controller/home_controller.dart';
import 'package:live_streaming/controller/pk_controller.dart';
import 'package:live_streaming/controller/streaming_controller.dart';
import 'package:live_streaming/helper/date_converter.dart';
import 'package:live_streaming/model/response/chat_model.dart';
import 'package:live_streaming/src/utils/constants/m_dimensions.dart';
import 'package:live_streaming/src/utils/constants/m_helper.dart';
import 'package:live_streaming/src/utils/constants/m_images.dart';
import 'package:live_streaming/src/utils/constants/m_styles.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../utils/constants/m_colors.dart';


class SoloLiveStreamingScreen extends GetView<PKController> {
  final bool isSingle, isViewer, isVIP;
  final int roomId, parentId, hostId;
  // final Floating floating;
  const SoloLiveStreamingScreen({Key? key, this.roomId = 0, this.parentId = 0, this.hostId = 0, this.isSingle = false, this.isViewer = false, this.isVIP = false,
    //required this.floating
  }) : super (key: key);

  List<VideoRendererAdapter> get remoteVideos => controller.remoteVideos;
  VideoRendererAdapter? get localVideo => controller.localVideo;

  final double localWidth = 114.0;
  final double localHeight = 72.0;


  BoxSize localVideoBoxSize(Orientation orientation) {
    return BoxSize(
      width: (orientation == Orientation.portrait) ? localHeight : localWidth,
      height: (orientation == Orientation.portrait) ? localWidth : localHeight,
    );
  }

  Widget _buildSingleScreen(Orientation orientation,BuildContext context) {
    return Obx(() {
      if (localVideo == null) {
        return Container(color: const Color(0xFF18253D),);
      }
      return GestureDetector(
          onTap: () {
            //controller.switchCamera();
          },
          onDoubleTap: () {
            //localVideo?.switchObjFit();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              RTCVideoView(localVideo!.renderer!,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover, mirror: Get.find<PKController>().isMirror),
              if(localVideo!.isCameraOff )...[
                const Center(child: ProfileAvatar(weight: 140, height: 140,imageUrl: '')),
              ]
            ],
          ));
    });
  }

  Widget _buildRemoteVideo() {
    return Obx(() {
      if (remoteVideos.isEmpty) {
        return Container(color: const Color(0xFF18253D));
      }

      return GetBuilder<StreamingController>(
        builder: (streamCon){
          var adapter = remoteVideos[0];
          var firstHost = streamCon.hostInfo;
          return GestureDetector(
              onDoubleTap: () {
                // adapter.switchObjFit();
              },
              child: Stack( alignment: Alignment.center,
                children: [
                  RTCVideoView(adapter.renderer!,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover, mirror: (adapter.isMirror),),
                    Center(child: ProfileAvatar(weight: 140, height: 140,imageUrl: '')),
                ],
              ));
        },
      );
    });
  }


  Widget viewerWidget(){
    return Obx(() => Text(DateConverter.convertViews(controller.viewerCount.value.toString()) ?? '', style: robotoMedium.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontSizeSmall)));
  }

  @override
  Widget build(BuildContext context) {
    var pixelRatio = window.devicePixelRatio;
    var logicalScreenSize = window.physicalSize / pixelRatio;
    var logicalHeight = logicalScreenSize.height;
    var paddingTop = window.padding.top / window.devicePixelRatio;
    var paddingBottom = window.padding.bottom / window.devicePixelRatio;
    var safeHeight = logicalHeight - (paddingTop + paddingBottom);

    return WillStartForegroundTask(
      onWillStart: () async {
        // Return whether to start the foreground service.
        return true;
      },
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
        'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        autoRunOnBoot: false,
        allowWifiLock: false,
      ),
      notificationTitle: 'Gypsy World LIVE',
      notificationText: 'Streaming, Tap to return',
      child: GetBuilder<HomeController>(
        builder: (user) => GetBuilder<StreamingController>(
          builder: (streamCon) {

            return OrientationBuilder(builder: (context, orientation) {
              return  streamCon.hostinfo != null ? WillPopScope(
                onWillPop: () {
                  /* Navigator.of(context).push(CustomRoute(isBottomSheet: true,child: Container(
                        color: Colors.transparent,
                        alignment: Alignment.bottomCenter,
                        child: StreamingQuitBottomSheet(onTab: (){
                          Get.back();

                          KeepScreenOn.turnOn(false).then((value) => debugPrint('Keep Screen off'));
                          if(streamCon.hostinfo!.userId == Get.find<AuthController>().getUserId()){
                            streamCon.leaveHost(roomId).then((value) {
                              if(value.isSuccess!){
                                streamCon.setLastViewer(controller.viewerCount.value);
                                Navigator.pushAndRemoveUntil(Get.context!, PageTransition(child:  EndLiveStreamingScreen(pageIndex: 1,hostinfo: streamCon.hostinfo, viewerCount: controller.viewerCount.value,), type: PageTransitionType.theme), (route) => false);
                                Get.find<StreamingController>().removeAudio();
                                // showCustomToast(value.message!, isError: false);
                              }else{
                                Navigator.pushAndRemoveUntil(Get.context!, PageTransition(child:  EndLiveStreamingScreen(pageIndex: 1,hostinfo: streamCon.hostinfo, viewerCount: controller.viewerCount.value,), type: PageTransitionType.bottomToTop), (route) => false);
                                showCustomToast(value.message!);
                              }
                              controller.cleanUp();
                              Get.find<PKController>().clearChat();
                              streamCon.setStreaming(false, true);
                            });
                          }else if(streamCon.isOthersHost){
                            streamCon.leaveOthersHost(roomId).then((value) {
                              if(value.isSuccess!){
                                Navigator.pushAndRemoveUntil(Get.context!, PageTransition(child:  EndLiveStreamingScreen(hostinfo: streamCon.hostinfo, viewerCount: controller.viewerCount.value,), type: PageTransitionType.theme), (route) => false);
                                Get.find<StreamingController>().removeAudio();
                                // showCustomToast(value.message!, isError: false);
                                // Get.find<ChatController>().clearChat();
                              }else{
                                Navigator.pushAndRemoveUntil(Get.context!, PageTransition(child:  EndLiveStreamingScreen(hostinfo: streamCon.hostinfo, viewerCount: controller.viewerCount.value,), type: PageTransitionType.theme), (route) => false);
                                showCustomToast(value.message!);
                              }
                              controller.cleanUp();
                              Get.find<PKController>().clearChat();
                              streamCon.setStreaming(false, true);
                            });
                          }else{
                            streamCon.leaveSingleMember(roomId).then((value) {
                              if(value.isSuccess!){
                                Get.back();
                                // showCustomToast(value.message!, isError: false);
                              }else{
                                Get.back();
                                showCustomToast(value.message!);
                              }
                              controller.cleanUp();
                              Get.find<PKController>().clearChat();
                              streamCon.setStreaming(false, true);
                              Get.find<StreamingController>().disposeTimer();
                            });
                          }
                        },),
                      )));*/
                  return Future.value(false);
                },
                child: GetBuilder<PKController>(
                  builder: (pk) {
                    return AnnotatedRegion<SystemUiOverlayStyle>(
                      value: SystemUiOverlayStyle.light,
                      child: Scaffold(
                        resizeToAvoidBottomInset: true,
                        extendBodyBehindAppBar: true,
                        backgroundColor: Colors.transparent,
                        body: Container(
                          height: double.infinity,
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                            gradient: streamCon.hostinfo!.seatType == '16' ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFF101828),
                                Colors.grey.shade500,
                                const Color(0xFF101828),
                              ],
                            ) : null,
                            color: streamCon.hostinfo!.seatType == '1' ? const Color(0xFF101828) : null,
                          ),
                          child: Stack( alignment: Alignment.center,
                            children: [


                              ///Main Screen
                              Container(
                                decoration:  BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          const Color(0xFF101828),
                                          Colors.grey.shade500,
                                          const Color(0xFF101828),
                                        ])
                                ),
                                height: safeHeight,
                              ),

                              Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 56,
                                  child: SizedBox(
                                      height: (streamCon.hostinfo!.userId == Get.find<AuthController>().getUserId() || streamCon.isOthersHost) ? safeHeight-190 : safeHeight - 140,
                                      child: localVideo != null ? _buildSingleScreen(orientation, context) : _buildRemoteVideo())),

                              /// for viewer picture and count


                              ///App Bar
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // Get.bottomSheet(HostInfoBottomSheet(hostinfo: streamCon.hostinfo!, isFollow: streamCon.isFollowStream, roomId: roomId, isHost: streamCon.hostinfo!.userId == Get.find<AuthController>().getUserId(), isSingle: true,));
                                        },
                                        child: Container(
                                          height: 35,
                                          margin: const EdgeInsets.all(2),
                                          padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                                          decoration:  BoxDecoration(
                                            color: MyColor.colorBlack.withOpacity(0.4),
                                            // borderRadius: BorderRadius.circular(50)
                                            borderRadius:  const BorderRadius.horizontal(left: Radius.circular(12), right: Radius.circular(50)),
                                            //border: Border.all(color: MyColor.COLOR_WHITE, width: 2)
                                          ),
                                          child: Row( mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(width: 2,),
                                              streamCon.hostinfo != null ? Stack( alignment: Alignment.center,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius: BorderRadius.circular(6),
                                                      child:ProfileAvatar(imageUrl: '', height: 28,weight: 28,)
                                                  ),
                                                  if(streamCon.hostinfo!.userId == Get.find<AuthController>().getUserId())...[
                                                    if(!streamCon.microphoneOn)...[
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.rectangle,
                                                            borderRadius: BorderRadius.circular(6),
                                                            color: Colors.black.withOpacity(0.5)
                                                        ),
                                                        child: const Icon(Icons.mic_off, size: 14, color: Colors.white,),
                                                      )
                                                    ]
                                                  ]else...[
                                                    Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.rectangle,
                                                          borderRadius: BorderRadius.circular(6),
                                                          color: Colors.black.withOpacity(0.5)
                                                      ),
                                                      child: const Icon(Icons.mic_off, size: 14, color: Colors.white,),
                                                    ),
                                                  ]
                                                  // isVIP ?  Image.asset(MyImage.pendant, fit: BoxFit.cover,) : const SizedBox()
                                                ],
                                              ) : Image.asset(MyImage.defaultLogo, height: 28, width: 28,),


                                              const SizedBox(width: 4,),
                                              Column( mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text((streamCon.hostinfo!.title != null && streamCon.hostinfo!.title!.isNotEmpty) ? streamCon.hostinfo!.title! : "${controller.roomTitle}'s Room", style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeOverExtraSmall, color: MyColor.colorWhite), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                                  const SizedBox(height: 3,),
                                                  Text('ID: ${streamCon.hostinfo!.userId}', style: robotoLight.copyWith(fontSize: 8, color: Colors.white.withOpacity(0.7)),),
                                                ],
                                              ),
                                              const SizedBox(width: 3,),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),

                                      /*  InkWell(
                                          highlightColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          onTap: () async{
                                            // showCustomToast('Coming soon...');
                                          },
                                          child: Container(
                                              height: 40,
                                              width: 40,
                                              padding: const EdgeInsets.all(8),
                                              decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(16, 24, 40, 0.6),
                                                  shape: BoxShape.circle
                                              ),

                                              child: SvgPicture.asset(MyImage.minimizeStreaming, width: 24, height: 24)),
                                        ),*/

                                      InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        // onTap: () async {
                                        //   await showModalBottomSheet(
                                        //     context: context,
                                        //     enableDrag: false,
                                        //     shape: const RoundedRectangleBorder(
                                        //       borderRadius: BorderRadius.vertical(
                                        //         top: Radius.circular(20),
                                        //       ),
                                        //     ),
                                        //     clipBehavior: Clip.antiAliasWithSaveLayer,
                                        //     builder: (context) => DraggableScrollableSheet(
                                        //       expand: false,
                                        //       initialChildSize: 0.7,
                                        //       minChildSize: 0.5,
                                        //       maxChildSize: 0.7,
                                        //       builder: (context, scrollController) {
                                        //         return  ManageBottomSheet(roomId: roomId, isHost: streamCon.hostinfo!.userId == Get.find<AuthController>().getUserId(), userinfo: user.userProfile, isSingle: true,);
                                        //       },
                                        //     ),
                                        //     isDismissible: true,
                                        //     isScrollControlled: true,
                                        //   );
                                        // },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Row(
                                            children: [
                                              // Container(
                                              //   margin: const EdgeInsets.all(2),
                                              //   padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                                              //   alignment: Alignment.center,
                                              //   decoration:  BoxDecoration(
                                              //     borderRadius: BorderRadius.circular(50),
                                              //     color: MyColor.colorBlack.withOpacity(0.6),
                                              //   ),
                                              //   child: Row( mainAxisSize: MainAxisSize.min,
                                              //     children: [
                                              //       SvgPicture.asset(MyImage.fire, width: 12, height: 12,),
                                              //       const SizedBox(width: 2),
                                              //       Text('Fire', style: interLight.copyWith(fontSize: 8, color: Colors.white.withOpacity(0.7)),),
                                              //     ],
                                              //   ),
                                              // ),
                                              // const Expanded(child: SizedBox()),

                                              Row(
                                                children: [
                                                  (streamCon.peerList.isNotEmpty ) ? ProfileAvatar(height: 24, weight: 24, imageUrl: '') : const SizedBox(),
                                                  const SizedBox(width: 2),
                                                  (streamCon.peerList.isNotEmpty && streamCon.peerList.length > 1) ? ProfileAvatar(height: 24, weight: 24, imageUrl: '') : const SizedBox(),
                                                  const SizedBox(width: 2),
                                                  (streamCon.peerList.isNotEmpty &&  streamCon.peerList.length > 2 ) ? ProfileAvatar(height: 24, weight: 24, imageUrl: '') : const SizedBox(),
                                                ],
                                              ),

                                              const SizedBox(width: 2),
                                              Container(
                                                // alignment: Alignment.center,
                                                // margin: const EdgeInsets.fromLTRB(2, 8, 2, 8),
                                                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                                  decoration:  BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    color: MyColor.colorBlack.withOpacity(0.6),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.person, color: Colors.white, size: 20,),
                                                      const SizedBox(width: 2),
                                                      viewerWidget(),
                                                    ],
                                                  )),
                                              // const SizedBox(width: Dimensions.paddingSizeMediumSmall,),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                                      InkWell(
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        child: Container(
                                            height: 40,
                                            width: 40,
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(16, 24, 40, 0.6),
                                                shape: BoxShape.circle
                                            ),
                                            child: SvgPicture.asset(MyImage.share, width: 24, height: 24, color: MyColor.colorWhite,)),
                                      ),
                                      const SizedBox(width: Dimensions.paddingSizeMediumSmall,),
                                      InkWell(
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        onTap: (){

                                          // Navigator.of(context).push(CustomRoute(isBottomSheet: true, child: Container(
                                          //   color: Colors.transparent,
                                          //   alignment: Alignment.bottomCenter,
                                          //   child: StreamingQuitBottomSheet(
                                          //     onTab: () {
                                          //       Get.back();
                                          //       if (streamCon.hostinfo!.seatType == '16') {
                                          //         streamCon.setFinishCounter();
                                          //         Get.find<PKController>().clearGiftValue();
                                          //       }
                                          //
                                          //       streamCon.disposeTimer();
                                          //
                                          //       if (streamCon.hostList.isNotEmpty &&
                                          //           streamCon.hostList[0].followingcheckCount !=
                                          //               null) {
                                          //         streamCon.setToggle(
                                          //             streamCon.hostList[0]
                                          //                 .followingcheckCount! >
                                          //                 0 ? true : false,
                                          //             true);
                                          //       }
                                          //       //_channel.sink.close();
                                          //       KeepScreenOn.turnOn(false)
                                          //           .then((value) =>
                                          //           debugPrint(
                                          //               'Keep Screen off'));
                                          //       if (streamCon.hostinfo!.userId == Get.find<AuthController>().getUserId()) {
                                          //         streamCon.leaveHost(roomId).then((value) {
                                          //           if (value.isSuccess!) {
                                          //             streamCon.setLastViewer(
                                          //                 controller.viewerCount.value);
                                          //             Navigator.pushAndRemoveUntil(
                                          //                 Get.context!,
                                          //                 PageTransition(child:  EndLiveStreamingScreen(
                                          //                   pageIndex: 1,hostinfo: streamCon.hostinfo, viewerCount: controller.viewerCount.value,), type: PageTransitionType.theme), (
                                          //                 route) => false);
                                          //             Get.find<StreamingController>().removeAudio();
                                          //             // showCustomToast(value.message!, isError: false);
                                          //           } else {
                                          //             Navigator.pushAndRemoveUntil(
                                          //                 Get.context!,
                                          //                 PageTransition(
                                          //                     child:  EndLiveStreamingScreen(
                                          //                       pageIndex: 1,hostinfo: streamCon.hostinfo, viewerCount: controller.viewerCount.value,),
                                          //                     type: PageTransitionType
                                          //                         .bottomToTop), (
                                          //                 route) => false);
                                          //             showCustomToast(value.message!);
                                          //           }
                                          //           controller.cleanUp();
                                          //           Get.find<PKController>().clearChat();
                                          //           streamCon.setStreaming(false, true);
                                          //         });
                                          //       } else
                                          //       if (streamCon.isOthersHost) {
                                          //         streamCon.leaveOthersHost(roomId).then((value) {
                                          //           if (value.isSuccess!) {
                                          //             Navigator
                                          //                 .pushAndRemoveUntil(
                                          //                 Get.context!,
                                          //                 PageTransition(
                                          //                     child:  EndLiveStreamingScreen(hostinfo: streamCon.hostinfo, viewerCount: controller.viewerCount.value,),
                                          //                     type: PageTransitionType
                                          //                         .theme), (
                                          //                 route) => false);
                                          //             Get.find<StreamingController>().removeAudio();
                                          //             streamCon.setStreaming(false, true);
                                          //             Get.find<ChatController>().clearChat();
                                          //           } else {
                                          //             Navigator
                                          //                 .pushAndRemoveUntil(
                                          //                 Get.context!,
                                          //                 PageTransition(
                                          //                     child:  EndLiveStreamingScreen(hostinfo: streamCon.hostinfo, viewerCount: controller.viewerCount.value,),
                                          //                     type: PageTransitionType
                                          //                         .theme), (
                                          //                 route) => false);
                                          //             showCustomToast(
                                          //                 value.message!);
                                          //           }
                                          //           controller.cleanUp();
                                          //           Get.find<PKController>().clearChat();
                                          //           streamCon.setStreaming(false, true);
                                          //         });
                                          //       } else {
                                          //         streamCon.leaveSingleMember(
                                          //             roomId).then((value) {
                                          //           if (value.isSuccess!) {
                                          //             Get.back();
                                          //             // showCustomToast(value.message!, isError: false);
                                          //           } else {
                                          //             Get.back();
                                          //             showCustomToast(value.message!);
                                          //           }
                                          //           controller.cleanUp();
                                          //           Get.find<PKController>().clearChat();
                                          //           streamCon.setStreaming(false, true);
                                          //         });
                                          //       }
                                          //     },),
                                          // )));
                                          //
                                        },
                                        child: Container( height: 40,
                                            width: 40,
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(16, 24, 40, 0.6),
                                                shape: BoxShape.circle
                                            ),child: SvgPicture.asset(MyImage.x, width: 28, height: 28)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),



                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GetBuilder<PKController>(builder: (pkCon) => ChatModule(chatGroupList: pkCon.chatGroupList, isHost: streamCon.hostinfo!.userId == Get.find<AuthController>().getUserId(),isCoHost: streamCon.isOthersHost, isSingle: isSingle, isLiveMatch: streamCon.hostinfo!.seatType == '16',
                                    //floating: floating
                                  )),

                                  if(streamCon.hostinfo!.seatType == '1')...[
                                    const SizedBox(height: 10,),
                                  ],
                                  Column(
                                    children: [

                                      if(!streamCon.isFocus)...[
                                        if(streamCon.hostinfo!.userId == Get.find<AuthController>().getUserId() || streamCon.isOthersHost)...[
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    streamCon.micToggle();
                                                    controller.turnMicrophone();
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        color: const Color(0xFF101828).withOpacity(0.6),
                                                        borderRadius: BorderRadius.circular(24)
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SvgPicture.asset(
                                                        streamCon.microphoneOn ? MyImage.micOff : MyImage.micOn,
                                                        color: Colors.white,
                                                        height: 24,
                                                        width: 24,
                                                        fit: BoxFit.cover,),
                                                    ),

                                                  ),
                                                ),
                                                const SizedBox(width: 16,),
                                                InkWell(
                                                  onTap: (){
                                                    pk.turnCamera();
                                                    streamCon.cameraToggle();
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        color: const Color(0xFF101828).withOpacity(0.6),
                                                        borderRadius: BorderRadius.circular(24)
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SvgPicture.asset(
                                                        streamCon.cameraOn ? MyImage.cameraOn : MyImage.cameraOff,
                                                        color: Colors.white,
                                                        height: 24,
                                                        width: 24,
                                                        fit: BoxFit.cover,),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16,),
                                                InkWell(
                                                  onTap: (){
                                                    streamCon.setFlipToggle();
                                                    pk.switchCamera();
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        color: const Color(0xFF101828).withOpacity(0.6),
                                                        borderRadius: BorderRadius.circular(24)
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SvgPicture.asset(
                                                        MyImage.cameraOn,
                                                        color: Colors.white,
                                                        height: 24,
                                                        width: 24,
                                                        fit: BoxFit.cover,),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16,),
                                                InkWell(
                                                  onTap: (){
                                                    pk.mirrorToggle();
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        color: const Color(0xFF101828).withOpacity(0.6),
                                                        borderRadius: BorderRadius.circular(24)
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SvgPicture.asset(
                                                        MyImage.miFilter,
                                                        color: Colors.white,
                                                        height: 24,
                                                        width: 24,
                                                        fit: BoxFit.cover,),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16,),
                                                if(!streamCon.isFlip)...[
                                                  InkWell(
                                                    onTap: (){
                                                      pk.flashOn();
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          color: const Color(0xFF101828).withOpacity(0.6),
                                                          borderRadius: BorderRadius.circular(24)
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: SvgPicture.asset(MyImage.cameraOn,
                                                          color: Colors.white,
                                                          height: 24,
                                                          width: 24,
                                                          fit: BoxFit.cover,),
                                                      ),
                                                    ),
                                                  ),
                                                ],

                                              ],
                                            ),
                                          ),
                                        ],
                                      ],

                                      Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Row(
                                          children: [
                                            ///for messaging
                                            Expanded(
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                onTap: (){
                                                  // showModalBottomSheet(
                                                  //     context: context,
                                                  //     isDismissible: true,
                                                  //     isScrollControlled: false,
                                                  //     backgroundColor: Colors.transparent,
                                                  //     builder: (context) => Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                  //       child: LiveGroupChat(roomId: roomId, isSingle: true, onTap: (isFocus){
                                                  //         streamCon.setFocus(isFocus);
                                                  //       },),
                                                  //     )
                                                  // );
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.all(2),
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                                  decoration:  BoxDecoration(
                                                    color:  const Color(0xFF101828),
                                                    border: Border.all(color: const Color(0xFFFFFFFF).withOpacity(0.1)),
                                                    borderRadius:  BorderRadius.circular(30),
                                                  ),
                                                  child: Row( mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const SizedBox(width: 6),
                                                      Expanded(child: Text('Say Hi',  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: MyColor.colorWhite),)),
                                                      const SizedBox(width: 20),
                                                      SvgPicture.asset(MyImage.emoji, width: 20, height: 20,),
                                                      const SizedBox(width: 6),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                            /// for gift
                                            // isSingle ? const SizedBox() : const SizedBox(width: Dimensions.paddingSizeDefault,),
                                            // isSingle ? const SizedBox() : _iconMenu(onTab: () => showCustomToast('Depend on API'),  icon: MyImage.giftSvg),



                                            const SizedBox(width: 16,),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              onTap: () {
                                                //Get.bottomSheet( GiftBottomSheet(roomId: roomId, hostId: hostId, hostInfo: streamCon.hostinfo!, isHost: streamCon.hostinfo!.userId == Get.find<AuthController>().getUserId(), isPK: streamCon.hostinfo!.seatType == '16', hostList: streamCon.hostList,), isScrollControlled: true);

                                              },
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                margin: const EdgeInsets.all(2),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                        colors: [Colors.pink, Colors.purpleAccent]
                                                    )
                                                ),
                                                child: SvgPicture.asset(MyImage.start, height: 55, width: 55, alignment: Alignment.center),
                                                // Lottie.asset(MyImage.gift, height: 55, width: 55, animate: true, repeat: true, alignment: Alignment.center),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),


                              // Positioned(
                              //     right: -20,
                              //     bottom: 100,
                              //     child:  streamCon.showGift ? SizedBox(
                              //       width: 300, height: 300,
                              //       child: streamCon.giftPath.isNotEmpty ? LottieBuilder.network(
                              //         '${ApiConfig.giftImageUri}${streamCon.giftPath}',
                              //         delegates: LottieDelegates(
                              //           values: [
                              //             ValueDelegate.color(
                              //                 ['3d_box', '**'],
                              //                 value: Colors.red
                              //             ),
                              //           ],
                              //         ),
                              //       ) :  Positioned(
                              //           right: -20,
                              //           bottom: 100,
                              //           child: SizedBox(
                              //
                              //               width: 300, height: 300,
                              //               child: Lottie.asset(
                              //                 MyImage.loveAnimate,
                              //                 animate: true,
                              //                 repeat: true,
                              //                 alignment: Alignment.center,
                              //                 options: LottieOptions(enableMergePaths: true),
                              //                 delegates: LottieDelegates(
                              //                   values: [
                              //                     ValueDelegate.color(
                              //                       // keyPath order: ['layer name', 'group name', 'shape name']
                              //                       const ['**', '3d_box', '**'],
                              //                       value: Colors.red,
                              //                     ),
                              //                   ],
                              //                 ),
                              //
                              //               ))),
                              //     ) : const SizedBox()
                              // ),


                              (streamCon.isFirst && streamCon.hostinfo!.userId == Get.find<AuthController>().getUserId()) ? const CustomCountDown() : const SizedBox(),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ) : const Center(child: CircularProgressIndicator(),);
            });
          },
        ),
      )
    );
  }

  double getterThenTotal(double val){
    return val > 1000 ? 1000 : val;
  }

}


class ChatModule extends StatefulWidget{
  final List<ChatModel> chatGroupList;
  final bool isHost,isCoHost, isSingle, isLiveMatch;
  // final Floating floating;
  const ChatModule({Key? key, required this.chatGroupList, this.isHost = false, this.isCoHost = false, this.isSingle = false, this.isLiveMatch = false
    //required this.floating
  }) : super(key: key);

  @override
  State<ChatModule> createState() => _ChatModuleState();
}

class _ChatModuleState extends State<ChatModule> with WidgetsBindingObserver{


  final ScrollController _scrollController = ScrollController();

  final List<int> _list = [];
  bool backToTop = false;
  bool test = false;

  int followCount = 0;
  @override
  void initState() {
    _scrollController.addListener(() {
      setState(() {
        if(_scrollController.offset > 0 && !_list.contains(widget.chatGroupList.length)){
          backToTop = true;
          _list.add(widget.chatGroupList.length);
        }else{
          backToTop = false;
        }
      });
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // widget.floating.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
  //   if (lifecycleState == AppLifecycleState.inactive) {
  //     widget.floating.enable(const Rational.square());
  //   }
  // }
  @override
  Widget build(BuildContext context) {

    var pixelRatio = window.devicePixelRatio;
    var logicalScreenSize = window.physicalSize / pixelRatio;
    var logicalHeight = logicalScreenSize.height;
    var totalHeight = logicalHeight / 4;

    var fontSize = 0.0;
    var padding = 0.0;
    var bottomHeight = 0.0;



    if(widget.isLiveMatch){
      if(totalHeight > 200){
        fontSize = 16;
        padding = 10;

        if(widget.isHost || widget.isCoHost){
          bottomHeight = totalHeight - 20;
        }else{
          bottomHeight = totalHeight + 20;
        }
      }else{
        fontSize = 14;
        padding = 8;
        if(widget.isHost || widget.isCoHost){
          bottomHeight = totalHeight - 90;
        }else{
          bottomHeight = totalHeight - 30;
        }
      }
    }else{
      if(totalHeight > 200){
        fontSize = 16;
        padding = 10;
        bottomHeight = totalHeight+75;
      }else{
        fontSize = 14;
        padding = 8;
        if(widget.isHost || widget.isCoHost){
          bottomHeight = totalHeight;
        }else{
          bottomHeight = totalHeight + 40;
        }
      }
    }




    if(_scrollController.hasClients){
      if(_scrollController.offset > 0 && !_list.contains(widget.chatGroupList.length)){
        _list.add(widget.chatGroupList.length);
        backToTop  = true;
      }else{
        backToTop  = false;
      }
    }



    return  GetBuilder<HomeController>(
      builder: (chat) => KeyboardVisibilityBuilder(
        builder: (_, isKeyboardVisible){
          return Stack( clipBehavior: Clip.none,
              children:[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: SizedBox(
                          height: isKeyboardVisible ? bottomHeight : bottomHeight + 100,
                          child: widget.chatGroupList.isNotEmpty ? NotificationListener<OverscrollIndicatorNotification>(
                            onNotification: (overScroll) {
                              overScroll.disallowIndicator();
                              return true;
                            },
                            child: FadingEdgeScrollView.fromScrollView(
                              gradientFractionOnStart: 0.1,
                              gradientFractionOnEnd: 0.05,

                              child: ListView.builder(
                                clipBehavior: Clip.hardEdge,
                                controller: _scrollController,
                                physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                itemCount: widget.chatGroupList.length,
                                shrinkWrap: true,
                                reverse: true,
                                itemBuilder: (context, index) {
                                  List<ChatModel> roomChat = widget.chatGroupList.reversed.toList();

                                  bool _isFirst = roomChat[index].message!.contains("welcome_to_gypsy_world_please_do_not_spread") || roomChat[index].message!.contains("welcome_to_my_room");
                                  bool _second = roomChat[index].message!.contains(" joined");
                                  bool _follow = (roomChat[index].type != null && roomChat[index].type!.contains('follow')) ? true : false;
                                  bool _gift = (roomChat[index].type != null && roomChat[index].type!.contains('gift')) ? true : false;
                                  bool _isHostLevel = (roomChat[index].messageId != null && (roomChat[index].messageId!.contains('Host') || roomChat[index].messageId!.contains('CO-Host'))) ? true : false;
                                  // int senderId = roomChat[index].id != null ? roomChat[index].id! : 0;
                                  String? from = roomChat[index].from!.split("#")[0];

                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          margin: const EdgeInsets.fromLTRB(5, 2, 40, 2),
                                          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 2),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color:  (_follow && widget.isHost) ? Colors.transparent : const Color(0xFF101828).withOpacity(0.4),
                                              boxShadow: (_follow && widget.isHost) ? null : [
                                                const BoxShadow(
                                                  offset: Offset(2, 2),
                                                  blurRadius: 12,
                                                  color: Color.fromRGBO(0, 0, 0, 0.16),
                                                )
                                              ]
                                          ),

                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              (_isFirst || _follow || !_isHostLevel) ? const SizedBox() : Padding(
                                                padding: const EdgeInsets.only(top: 5, bottom: 5,),
                                                child: Container(
                                                  height: 20,
                                                  width: 45,
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.all(1),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      gradient: const LinearGradient(
                                                          colors: [
                                                            Colors.amber,
                                                            Colors.orange,
                                                            Colors.amber,
                                                          ],
                                                          begin: FractionalOffset(0.3, 0.0),
                                                          end: FractionalOffset(1.0, 0.2),
                                                          stops: [0.0, 1.0, 0.5],
                                                          tileMode: TileMode.clamp)
                                                  ),
                                                  child:  Text(roomChat[index].messageId ?? 'N/A', style: robotoMedium.copyWith(color: MyColor.getBackgroundColor(), fontSize: Dimensions.fontSizeSmall,), textAlign: TextAlign.center,),
                                                ),
                                              ),
                                              Flexible(
                                                child: Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: !roomChat[index].message!.contains("emoji/") ? RichText(
                                                      maxLines: 10,
                                                      text: TextSpan(
                                                        text: (_isFirst || _follow) ? '' : _second ? Get.find<AuthController>().getName() : from+': ',
                                                        style: DefaultTextStyle.of(context).style.copyWith(color: const Color(0xFFB4B4B4)),
                                                        children: [
                                                          if(_second)...[
                                                            TextSpan(text: roomChat[index].message!.replaceAll('joined', ' '), style: robotoRegular.copyWith(color: MyColor.getBackgroundColor(), fontSize: Dimensions.fontSizeDefault,)),
                                                          ]else if(_follow)...[
                                                            TextSpan(text: roomChat[index].message ?? '', style: robotoRegular.copyWith(color: Colors.amber, fontSize: Dimensions.fontSizeDefault,))
                                                          ]else if(_gift)...[
                                                            TextSpan(text: roomChat[index].message ?? '', style: robotoRegular.copyWith(color: const Color(0xFF3BA6A3), fontSize: Dimensions.fontSizeDefault,))
                                                          ]else...[
                                                            TextSpan(text: _isFirst ? roomChat[index].message ?? '' : roomChat[index].message ?? "", style: robotoRegular.copyWith(color: MyColor.getBackgroundColor(), fontSize: Dimensions.fontSizeDefault,)),
                                                          ],
                                                          if(_second)...[
                                                            TextSpan(text: 'joined', style: robotoRegular.copyWith(color: Colors.amber, fontSize: Dimensions.fontSizeDefault,))
                                                          ]
                                                        ],
                                                      ),
                                                    ) : Row( mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text((_isFirst || _follow) ? '' : _second ? '' : '$from: ',
                                                          style: robotoRegular.copyWith(color: const Color(0xFFB4B4B4), overflow: TextOverflow.ellipsis), maxLines: 1,),
                                                        const SizedBox(width: 4),
                                                        ClipRRect(
                                                            borderRadius: BorderRadius.circular(6),
                                                            child: const ProfileAvatar(imageUrl: '', height: 50, weight: 50,)
                                                        )
                                                      ],
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                          ) : const SizedBox(),
                        )
                    ),
                    const SizedBox(width: 10,),
                  ],),

                Positioned(
                  bottom:-2,
                  left: 15,
                  child: backToTop ? InkWell(
                    onTap: () => _scrollController.animateTo(0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white
                      ),
                      height: 25,
                      // width: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('new', style: robotoRegular.copyWith(color: Colors.lightBlue, fontSize: Dimensions.fontSizeSmall),),
                          const Icon(Icons.arrow_drop_down, size: 15, color: Colors.lightBlue,)

                        ],
                      )
                      ,),
                  ) : const SizedBox(),)
              ]
          );
        },
      ),
    );
  }
}



class ProgressBar extends StatelessWidget {
  final double max;
  final double current;
  final Color color;

  const ProgressBar(
      {Key? key,
        required this.max,
        required this.current,
        this.color = Colors.grey})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, boxConstraints) {
        var x = boxConstraints.maxWidth;
        var percent = (current / max) * x;
        return Stack(
          children: [
            Container(
              width: x,
              height: 7,
              decoration: BoxDecoration(
                color: const Color(0xffd3d3d3),
                borderRadius: BorderRadius.circular(35),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: percent,
              height: 7,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(35),
              ),
            ),
          ],
        );
      },
    );
  }
}


class CustomTimer extends AnimatedWidget {
  final Animation<int> ? animation;
  final Color? color;
  final double? size;
  CustomTimer({ Key? key, this.animation, this.color, this.size}) : super(key: key, listenable: animation!);


  @override
  build(BuildContext context){
    if(animation!.value == 0){
      Get.find<StreamingController>().setFist(false);
    }
    return animation!.value != 0 ? Text(animation!.value.toString(),
      style: robotoRegular.copyWith(fontSize: size, color: color),
    ) : const SizedBox();
  }
}


class CustomCountDown extends StatefulWidget {
  final Color? color;
  final double? size;
  const CustomCountDown({Key? key, this.color, this.size}) : super(key: key);

  @override
  State createState() =>  _CustomCountDownState();
}

class _CustomCountDownState extends State<CustomCountDown> with TickerProviderStateMixin {
  late AnimationController _controller;

  int startVal = 4;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:  Duration(seconds: startVal),
    );
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomTimer(
        size: widget.size ?? 150,
        color: widget.color ?? Colors.white,
        animation: StepTween(
          begin: startVal,
          end: 0,
        ).animate(_controller),
      ),
    );
  }
}