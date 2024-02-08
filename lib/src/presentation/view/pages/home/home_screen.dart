import 'package:flutter/material.dart';
import 'package:live_streaming/src/presentation/view/component/m_appbar.dart';
import 'package:live_streaming/src/utils/constants/m_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getBackgroundColor(),
      appBar: CustomAppBar(title: 'home',),
    );
  }
}
