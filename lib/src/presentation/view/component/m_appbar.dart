import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_streaming/src/utils/constants/m_colors.dart';
import 'package:live_streaming/src/utils/constants/m_dimensions.dart';
import 'package:live_streaming/src/utils/constants/m_images.dart';
import 'package:live_streaming/src/utils/constants/m_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? isBackButtonExist, isShowCoin;
  final VoidCallback? onBackPressed;
  final VoidCallback? onTab;
  final IconData? icon;
  final String? leadingIcon, actionText;

  const CustomAppBar({Key? key, required this.title, this.isBackButtonExist = true, this.isShowCoin = true, this.onBackPressed, this.onTab, this.icon,this.leadingIcon, this.actionText }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: MyColor.getHeaderTextColor(),),textDirection: TextDirection.ltr,),
      leading: isBackButtonExist! ? IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        icon: SvgPicture.asset(MyImage.leftArrow, width: 24, height: 24,),
        onPressed: () => onBackPressed != null ? onBackPressed!() : Get.back(canPop: true),
      ) : const SizedBox(),
      leadingWidth: isBackButtonExist! ? 50 : 10,
      elevation: 1,
      centerTitle: true,
      backgroundColor: MyColor.getBackgroundColor(),
      shadowColor: MyColor.colorBlack.withOpacity(0.12),
      bottomOpacity: 0.3,
      automaticallyImplyLeading: false,
      titleSpacing: 10,
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}
