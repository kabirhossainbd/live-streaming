import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_streaming/src/utils/constants/m_colors.dart';
import 'package:live_streaming/src/utils/constants/m_images.dart';
import 'package:live_streaming/src/utils/constants/m_styles.dart';

import '../../../utils/constants/m_dimensions.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final bool isbBorderColor;
  final bool isError;
  final Function? onErrorTap;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;
  final int? maxLines;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final bool? isPassword;
  final bool? isCountryPicker;
  final bool? isShowBorder;
  final bool? isIcon;
  final bool? isShowSuffixIcon;
  final bool? isShowPrefixIcon;
  final Color? prefixIconColor;
  final Function? onTap;
  final Function(String text)? onChanged;
  final Function? onSuffixTap;
  final String? suffixActiveIconUrl;
  final String? suffixInactiveIconUrl;
  final String? prefixIconUrl;
  final Widget prefixWidget;
  final bool? isSearch;
  final Function? onSubmit;
  final bool? isEnabled;
  final TextCapitalization? capitalization;

  const CustomTextField(
      {Key? key,
        this.hintText = 'Write something...',
        this.controller,
        this.borderRadius,
        this.backgroundColor,
        this.isbBorderColor = false,
        this.isError = false,
        this.onErrorTap,
        this.focusNode,
        this.nextFocus,
        this.isEnabled = true,
        this.inputType = TextInputType.text,
        this.inputAction = TextInputAction.next,
        this.inputFormatters,
        this.maxLines = 1,
        this.maxLength,
        this.maxLengthEnforcement,
        this.onSuffixTap,
        this.fillColor,
        this.onSubmit,
        this.onChanged,
        this.capitalization = TextCapitalization.none,
        this.isCountryPicker = false,
        this.isShowBorder = false,
        this.isShowSuffixIcon = false,
        this.isShowPrefixIcon = false,
        this.prefixIconColor = Colors.grey,
        this.prefixWidget = const SizedBox(),
        this.onTap,
        this.isIcon = false,
        this.isPassword = false,
        this.suffixActiveIconUrl,
        this.suffixInactiveIconUrl,
        this.prefixIconUrl,
        this.isSearch = false,}) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        //color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        border: Border.all(color: widget.isError ? MyColor.colorRed : Colors.grey.shade300),
      ),
      child: TextField(
        maxLines: widget.maxLines,
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: MyColor.getHeaderTextColor()),
        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        cursorColor: Theme.of(context).primaryColor,
        textCapitalization: widget.capitalization!,
        enabled: widget.isEnabled,
        autofocus: false,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        maxLength: widget.maxLength,
        //onChanged: page.isSearch ? page.languageProvider.searchLanguage : null,
        obscureText: widget.isIcon! ? _obscureText : false,
        inputFormatters: widget.inputType == TextInputType.phone ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9+]'))] :  widget.inputFormatters,
        decoration: InputDecoration(
          //contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
          contentPadding: const EdgeInsets.only(left: 12,right: 12,top: 12),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(8),left: Radius.circular(8)),
            borderSide: BorderSide(style: BorderStyle.none, width: 0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(8),left: Radius.circular(8)),
            borderSide: BorderSide(style: BorderStyle.none, width: 0),
          ),
          isDense: true,
          hintText: widget.hintText,
          fillColor: widget.fillColor,
          hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: MyColor.getGreyColor()),
          //filled: true,
          prefix: widget.prefixWidget,
          prefixIcon: widget.isShowPrefixIcon! ? Padding(
            padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeDefault),
            child: SvgPicture.asset(widget.prefixIconUrl!, color: widget.prefixIconColor,),
          ) : const SizedBox.shrink(),
          prefixIconConstraints: const BoxConstraints(minWidth: 8, maxHeight: 20),
          suffixIcon: widget.isError ? IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            onPressed: ()=> widget.onErrorTap!,
            icon: SvgPicture.asset(
              MyImage.requestsMsgInfo,
              width: 18,
              height: 13,
              color: MyColor.colorRed,
            ),
          ) : widget.isShowSuffixIcon!
              ? widget.isPassword! ? IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: MyColor.getHintColor()),
              onPressed: _toggle)
              : widget.isIcon!
              ? IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            onPressed:_toggle,
            icon: SvgPicture.asset(
              _obscureText ? widget.suffixInactiveIconUrl! : widget.suffixActiveIconUrl!,
              width: 18,
              height: 13,
            ),
          ) : const SizedBox( width: 18, height: 13,)
              : const SizedBox( width: 18, height: 13,),
        ),
        onTap: () => widget.onTap,
        onSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus) : widget.onSubmit != null ? widget.onSubmit!(text) : null,
        onChanged: (text) {
          widget.onChanged != null ? widget.onChanged!(text) : {};
        },
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}




class CustomTextWithLevelField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final bool isbBorderColor;
  final bool isError;
  final Function? onErrorTap;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;
  final int? maxLines;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final bool? isPassword;
  final bool? isCountryPicker;
  final bool? isShowBorder;
  final bool? isIcon;
  final bool? isShowSuffixIcon;
  final bool? isShowPrefixIcon;
  final Color? prefixIconColor;
  final Function? onTap;
  final Function(String ? text)? validator;
  final Function(String text)? onChanged;
  final Function? onSuffixTap;
  final String? suffixActiveIconUrl;
  final String? suffixInactiveIconUrl;
  final String? prefixIconUrl;
  final Widget prefixWidget;
  final bool? isSearch;
  final Function? onSubmit;
  final bool? isEnabled;
  final TextCapitalization? capitalization;

  const CustomTextWithLevelField(
      {Key? key,
        this.hintText = 'Write something...',
        this.controller,
        this.borderRadius,
        this.backgroundColor,
        this.isbBorderColor = false,
        this.isError = false,
        this.onErrorTap,
        this.focusNode,
        this.nextFocus,
        this.isEnabled = true,
        this.inputType = TextInputType.text,
        this.inputAction = TextInputAction.next,
        this.inputFormatters,
        this.maxLines = 1,
        this.maxLength,
        this.maxLengthEnforcement,
        this.onSuffixTap,
        this.fillColor,
        this.onSubmit,
        this.validator,
        this.onChanged,
        this.capitalization = TextCapitalization.none,
        this.isCountryPicker = false,
        this.isShowBorder = false,
        this.isShowSuffixIcon = false,
        this.isShowPrefixIcon = false,
        this.prefixIconColor = Colors.grey,
        this.prefixWidget = const SizedBox(),
        this.onTap,
        this.isIcon = false,
        this.isPassword = false,
        this.suffixActiveIconUrl,
        this.suffixInactiveIconUrl,
        this.prefixIconUrl,
        this.isSearch = false,}) : super(key: key);

  @override
  State<CustomTextWithLevelField> createState() => _CustomTextWithLevelFieldState();
}

class _CustomTextWithLevelFieldState extends State<CustomTextWithLevelField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: MyColor.getHeaderTextColor()),
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: Theme.of(context).primaryColor,
      textCapitalization: widget.capitalization!,
      enabled: widget.isEnabled,
      autofocus: false,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      maxLength: widget.maxLength,
      obscureText: widget.isIcon! ? _obscureText : false,
      inputFormatters: widget.inputType == TextInputType.phone ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9+]'))] :  widget.inputFormatters,
      decoration: InputDecoration(
        errorText: widget.isError ? '' : null,
        contentPadding:  const EdgeInsets.fromLTRB(16.0, 8.0, 12.0, 8.0),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xffE5E5E5),
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xffE5E5E5),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xffE5E5E5),
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            width: 1,
          ),
        ),
        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            )),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),
        isDense: true,
        hintText: widget.hintText,
        fillColor: widget.fillColor,
        labelText: widget.hintText,
        labelStyle: robotoRegular.copyWith(color:  MyColor.getGreyColor(), fontSize: Dimensions.fontSizeExtraSmall),
        hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: MyColor.getGreyColor()),
        prefix: widget.prefixWidget,
        prefixIcon: widget.isShowPrefixIcon! ? Padding(
          padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeDefault),
          child: SvgPicture.asset(widget.prefixIconUrl!, color: widget.prefixIconColor,),
        ) : const SizedBox.shrink(),
        prefixIconConstraints: const BoxConstraints(minWidth: 8, maxHeight: 20),

        suffixIcon: widget.isShowSuffixIcon!
            ? widget.isPassword! ? IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: MyColor.getHintColor()),
            onPressed: _toggle)
            : widget.isIcon!
            ? IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          onPressed:_toggle,
          icon: SvgPicture.asset(
            _obscureText ? widget.suffixInactiveIconUrl! : widget.suffixActiveIconUrl!,
            width: 18,
            height: 13,
          ),
        ) : const SizedBox()
            : const SizedBox(),
        //suffixIconConstraints: const BoxConstraints(minWidth: 12, maxHeight: 20),
      ),

      validator: (text){
       return widget.validator != null ? widget.validator!(text) : {};
      },
      onTap: () => widget.onTap,
      onFieldSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus) : widget.onSubmit != null ? widget.onSubmit!(text) : null,
      onChanged: (text) {
        widget.onChanged != null ? widget.onChanged!(text) : {};
      },
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
