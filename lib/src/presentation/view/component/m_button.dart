import 'package:flutter/material.dart';
import 'package:live_streaming/src/utils/constants/m_dimensions.dart';
import 'package:live_streaming/src/utils/constants/m_styles.dart';

import '../../../utils/constants/m_colors.dart';


class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String buttonText;
  final bool isColor;
  final double? borderRadius, height;
  final TextStyle? textStyle;
  const CustomButton({ Key? key , this.onTap, required this.buttonText, this.isColor = true, this.borderRadius, this.height, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height ?? 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isColor ? MyColor.getPrimaryColor() : MyColor.getButtonBgColor(),
              borderRadius: BorderRadius.circular(borderRadius ?? 16)
          ),
          child: Text(buttonText,
            style: textStyle ?? robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: isColor ? MyColor.colorWhite : MyColor.getDisableColor()
            ), textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String buttonText;
  final bool isColor;
  final double? borderRadius, height;
  final TextStyle? textStyle;
  const SecondaryButton({ Key? key , this.onTap, required this.buttonText, this.isColor = true, this.borderRadius, this.height, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Bouncing(
        onPress: onTap,
        child: Container(
          height: height ?? 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: isColor ? MyColor.getPrimaryColor() : MyColor.getButtonBgColor(),
              borderRadius: BorderRadius.circular(borderRadius ?? 16)
          ),
          child: Text(buttonText,
            style: textStyle ?? robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall,
                color: isColor ? MyColor.colorWhite : MyColor.getDisableColor()
            ), textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}

class Bouncing extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onPress;
  const Bouncing({required this.child, Key? key, this.onPress}): assert(child != null), super(key: key);

  @override
  State<Bouncing> createState() => _BouncingState();
}

class _BouncingState extends State<Bouncing> with SingleTickerProviderStateMixin {
  double _scale = 0.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        if (widget.onPress != null) {
          _controller.forward();
        }
      },
      onPointerUp: (PointerUpEvent event) {
        if (widget.onPress != null) {
          _controller.reverse();
          widget.onPress!();
        }
      },
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}