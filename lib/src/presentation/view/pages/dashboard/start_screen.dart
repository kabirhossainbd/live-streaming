import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_streaming/src/presentation/view/pages/create_steaming/create_streaming_screen.dart';
import 'package:live_streaming/src/presentation/view/pages/home/home_screen.dart';
import 'package:live_streaming/src/utils/constants/m_colors.dart';
import 'package:page_transition/page_transition.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  late PageController _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);


    _screens = [
      const HomeScreen(),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          if (_canExit) {
            return true;
          } else {
            // showCustomToast(translatedText('again_to_exit', context)!, isError: false);
            _canExit = true;
            Timer(const Duration(seconds: 2), () {
              _canExit = false;
            });
            return false;
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: MyColor.getBackgroundColor(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(onPressed: (){
            Navigator.push(context, PageTransition(child: const AddVideoScreen(), type: PageTransitionType.bottomToTop));
          }, backgroundColor: MyColor.getPrimaryColor(),child: const Icon(Icons.add, size: 30, color: Colors.white,),),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

  Widget addTaskCreate({VoidCallback? onTap}){
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration:  const BoxDecoration(
            color: Color(0xFFA39AFF),
            shape: BoxShape.circle
        ),
        child: const Text("Create Live"),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData? image;
  final String? title;
  final VoidCallback? onTap;
  final bool? isSelected;
  final Color? color;
  const BottomNavItem({Key? key,  this.image, this.title, this.onTap, this.isSelected = false, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 3.0, color: isSelected! ? MyColor.colorPrimary : Colors.transparent)),
        ),
        child: Icon(image!, size: 24, color: color,
          // child: SvgPicture.asset(image!, width: 24, height: 24, color: color,
        ),
      ),
    );
  }
}
