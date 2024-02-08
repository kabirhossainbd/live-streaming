import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_streaming/controller/meeting_controller.dart';
import 'package:live_streaming/controller/streaming_controller.dart';
import 'package:live_streaming/model/response/room_list.dart';
import 'package:live_streaming/src/utils/constants/m_colors.dart';
import 'package:live_streaming/src/utils/constants/m_dimensions.dart';
import 'package:live_streaming/src/utils/constants/m_helper.dart';
import 'package:live_streaming/src/utils/constants/m_images.dart';
import 'package:live_streaming/src/utils/constants/m_key.dart';
import 'package:live_streaming/src/utils/constants/m_styles.dart';
import 'package:permission_handler/permission_handler.dart';


class UserDataView extends StatelessWidget {
  final Data dataModel;
  final bool isForTopPicks, isForYou, isLikes;
  const UserDataView({super.key, required this.dataModel, this.isForTopPicks = false, this.isForYou = false, this.isLikes = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StreamingController>(
      builder: (streamCon) => GestureDetector(
        onTap: (){
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
                                      openSettingsDialog(context);
                                    }else{
                                      Get.back();
                                      _joinLiveRoom(streamCon);
                                    }
                                  });
                                },
                                child: Text(
                                  'Confirm',
                                  style: robotoMedium.copyWith(
                                      color: MyColor.getPrimaryColor(),
                                      fontSize:
                                      Dimensions.fontSizeLarge),
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

                _joinLiveRoom(streamCon);

              }
            });
          }else{
            streamCon.joinLiveRoom(dataModel.id!).then((value) {
              if(value.isSuccess!){
                if( dataModel.seatType == '1'){
                  bool isHost = false;
                  bool isViewer = true;
                  bool isSingle = true;
                  bool isPK = false;
                  streamCon.setSid(dataModel.id.toString());
                  // streamCon.handleJoin(false, true, true, false, false,false, false, false);
                  streamCon.handleSoloJoin(isHost, isViewer, isSingle, dataModel.prentId ?? 0, dataModel.userId ?? 0, dataModel.seatType ?? '1');
                  streamCon.setSeatType(int.parse(dataModel.seatType ?? '1'));
                }
              }
            });
          }
        },
        child: Container(
          decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(isForTopPicks ? 20 : 10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200]!,
                blurRadius: 0.2,
                spreadRadius: 0.4,
                offset: const Offset(0,0)
              )
            ],
            image: const DecorationImage(image: AssetImage(MyImage.defaultLogo), fit: BoxFit.scaleDown)
          ),
          height: isForTopPicks ? 170 : 190,
          width: 160,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Container(
                  height: isForTopPicks ? 170 : 190,
                  width: 170,
                  foregroundDecoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(isForTopPicks ? 20 : 10),
                    gradient:  LinearGradient(
                      colors: [Colors.transparent, Colors.transparent, Colors.transparent, Colors.black.withOpacity(0.4)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0, 0.2,0.8, 1],
                    ),
                  ),
                  child:  ClipRRect(
                      borderRadius: BorderRadius.circular(isForTopPicks ? 20 : 10),
                      child: (dataModel.picture != null) ? CachedNetworkImage(
                          imageUrl: '${MyKey.getProfileImage}${dataModel.picture}',
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (a,b) => Image.asset(MyImage.defaultLogo),
                          errorWidget: (a,b,c)=> Image.asset(MyImage.defaultLogo),
                      ) : const SizedBox()
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column( mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column( crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeExtraSmall, vertical: 2),
                            decoration: BoxDecoration(
                                color: const Color(0xFFDCF8C6),
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: Text('Active', style: robotoRegular.copyWith(color: MyColor.colorBlack, fontSize: 8), textAlign: TextAlign.center,),
                          ),

                          Row(
                            children: [
                              Flexible(child: Text(dataModel.name  ?? '',  style: robotoSemiBold.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontSizeDefault), overflow: TextOverflow.ellipsis, maxLines: 1,)),
                              const SizedBox(width: 3,),
                              const Text(','),
                              const SizedBox(width: 3,),
                            ],
                          ),

                          Row(
                            children: [
                              SvgPicture.asset(MyImage.mapPin, width: 14, height: 14, color: MyColor.colorWhite,),
                              const SizedBox(width: 4),
                              Text(dataModel.title ?? '', style: robotoLight.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontSizeOverExtraSmall),),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _joinLiveRoom(StreamingController streamCon) {
    streamCon.joinLiveRoom(dataModel.id!).then((value) {
      if(value.isSuccess!){
        if( dataModel.seatType == '1'){
          bool isHost = false;
          bool isViewer = true;
          bool isSingle = true;
          bool isPK = false;
          streamCon.setSid(dataModel.id.toString());
          // streamCon.handleJoin(false, true, true, false, false,false, false, false);
          streamCon.handleSoloJoin(isHost, isViewer, isSingle, dataModel.prentId ?? 0, dataModel.userId ?? 0, dataModel.seatType ?? '1');
          streamCon.setSeatType(int.parse(dataModel.seatType ?? '1'));
        }
      }
    });
  }
}
