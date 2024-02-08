import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_streaming/model/response/room_list.dart';
import 'package:live_streaming/src/utils/constants/m_colors.dart';
import 'package:live_streaming/src/utils/constants/m_dimensions.dart';
import 'package:live_streaming/src/utils/constants/m_images.dart';
import 'package:live_streaming/src/utils/constants/m_key.dart';
import 'package:live_streaming/src/utils/constants/m_styles.dart';


class UserDataView extends StatelessWidget {
  final Data dataModel;
  final bool isForTopPicks, isForYou, isLikes;
  const UserDataView({super.key, required this.dataModel, this.isForTopPicks = false, this.isForYou = false, this.isLikes = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

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
    );
  }
}
