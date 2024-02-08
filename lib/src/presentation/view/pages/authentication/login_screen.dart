import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_streaming/controller/auth_controller.dart';
import 'package:live_streaming/src/presentation/view/component/m_button.dart';
import 'package:live_streaming/src/presentation/view/component/m_toast.dart';
import 'package:live_streaming/src/presentation/view/pages/dashboard/start_screen.dart';
import 'package:live_streaming/src/presentation/view/pages/home/home_screen.dart';
import 'package:live_streaming/src/utils/constants/m_colors.dart';
import 'package:live_streaming/src/utils/constants/m_dimensions.dart';
import 'package:live_streaming/src/utils/constants/m_images.dart';
import 'package:live_streaming/src/utils/constants/m_styles.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isUserNameEmailError = false;
  bool _isPasswordError = false;
  bool _isPasswordLengthError = false;
  bool _isEmailAndPassError = false;

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {

    super.initState();

  }



  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _isUserNameEmailError = false;
    _isPasswordError = false;
    _isPasswordLengthError = false;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: MyColor.getBackgroundColor(),
        resizeToAvoidBottomInset: false,
        body: GetBuilder<AuthController>(
            builder: (auth) {
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: ()=> FocusScope.of(context).unfocus(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 22.0, right: 22.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            // Load a Lottie file from your assets
                            Lottie.asset(MyImage.liveLottie),
                             const SizedBox(height: Dimensions.paddingSizeSmall,),
                            Row( crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Sign in to', style: robotoExtraBold.copyWith(color: MyColor.getHeaderTextColor(), fontWeight: FontWeight.w800,fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center,),
                                const SizedBox(width: 4),
                                Text('KUAA', style: robotoExtraBold.copyWith(color: MyColor.getPrimaryColor(), fontWeight: FontWeight.w800,fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center,),
                              ],
                            ),

                            const SizedBox(height: 85,),


                            /// email
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: _emailController,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r"\s\s")),
                                FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                              ],
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onChanged: (text){
                                setState(() {
                                  text = _emailController.text;
                                  _isUserNameEmailError = false;
                                  _isEmailAndPassError = false;
                                });
                              },
                              maxLines: 1,
                              focusNode: _emailFocus,
                              autofocus: false,
                              onTap: (){
                                setState(() {
                                  FocusScope.of(context).requestFocus(_emailFocus);
                                });
                              },
                              onFieldSubmitted: (v){
                                setState(() {
                                  FocusScope.of(context).requestFocus(_passwordFocus);
                                });
                              },
                              decoration:  InputDecoration(
                                errorText: _isUserNameEmailError ? '' : null,
                                contentPadding:  const EdgeInsets.fromLTRB(16.0, 12.0, 12.0, 12.0),
                                errorMaxLines: 3,
                                counterText: "",
                                filled: true,
                                isDense: true,
                                fillColor: Colors.white,
                                focusedBorder:  OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: MyColor.getPrimaryColor(),
                                  ),
                                ),
                                disabledBorder:  OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: MyColor.getDisableBgColor(),
                                  ),
                                ),
                                enabledBorder:  OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: MyColor.getDisableColor().withOpacity(0.5),
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
                                labelText: 'Name',
                                labelStyle: robotoRegular.copyWith(color:  _isUserNameEmailError ? MyColor.colorRed : _emailFocus.hasFocus ?  MyColor.getPrimaryColor() : MyColor.getGreyColor(), fontSize: Dimensions.fontSizeSmall),
                                hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: MyColor.getGreyColor()),
                                hintText: "Name",
                              ),
                            ),

                            const SizedBox(height: 6,),
                            if(_isUserNameEmailError)...[
                              Align(alignment: Alignment.centerLeft,child: Text('Enter name'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: MyColor.colorRed),overflow: TextOverflow.ellipsis, maxLines: 2,)),
                            ],

                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            Stack(
                              alignment: Alignment.centerRight,
                              clipBehavior: Clip.none,
                              children: [
                                TextFormField(
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: _passwordController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(r"\s\s")),
                                    FilteringTextInputFormatter.deny(RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                                  ],
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (text){
                                    setState(() {
                                      text = _passwordController.text;
                                      _isPasswordError = false;
                                      _isPasswordLengthError = false;
                                      _isEmailAndPassError = false;
                                    });
                                  },
                                  maxLines: 1,
                                  focusNode: _passwordFocus,
                                  autofocus: false,
                                  obscureText: _obscureText,
                                  onTap: (){
                                    setState(() {
                                      FocusScope.of(context).requestFocus(_passwordFocus);
                                    });
                                  },
                                  decoration:  InputDecoration(
                                      errorText: (_isPasswordError || _isPasswordLengthError) ? '' : null,
                                      contentPadding:  const EdgeInsets.fromLTRB(16.0, 14.0, 12.0, 10.0),
                                      errorMaxLines: 3,
                                      counterText: "",
                                      filled: true,
                                      isDense: true,
                                      fillColor: Colors.white,
                                    focusedBorder:  OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: MyColor.getPrimaryColor(),
                                      ),
                                    ),
                                    disabledBorder:  OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: MyColor.getDisableBgColor(),
                                      ),
                                    ),
                                    enabledBorder:  OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: MyColor.getDisableColor().withOpacity(0.5),
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
                                      labelText: 'Student ID',
                                      labelStyle: robotoRegular.copyWith(color:  (_isPasswordError || _isPasswordLengthError) ? MyColor.colorRed : _passwordFocus.hasFocus ? MyColor.getPrimaryColor() : MyColor.getGreyColor(), fontSize: Dimensions.fontSizeSmall),
                                      hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: MyColor.getGreyColor()),
                                      hintText: "Student IDd",
                                  ),
                                ),
                                InkWell(
                                  onTap:_toggle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SvgPicture.asset(
                                      _obscureText ? MyImage.eyeOff : MyImage.eye,
                                      width: 12,
                                      height: 12,
                                    ),
                                  ),
                                )

                              ],
                            ),

                            const SizedBox(height: 6,),
                           if(_isPasswordError)...[ 
                             Align(alignment: Alignment.centerLeft,child: Text('Enter Student ID'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: MyColor.colorRed),overflow: TextOverflow.ellipsis, maxLines: 2,)),
                           ],

                            SizedBox(
                              height: 26,
                              child: Column(
                                children: [
                                  if(_isEmailAndPassError)...[
                                    Align(alignment: Alignment.centerLeft,child: Text('Wrong email address or password', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: MyColor.colorRed), overflow: TextOverflow.ellipsis, maxLines: 2,)),
                                  ]
                                ],
                              ),
                            ),


                           // const SizedBox(height: Dimensions.paddingSizeDefault),



                            const SizedBox(height: 16),

                            CustomButton(
                                onTap:  (_emailController.text.isEmpty && _passwordController.text.isEmpty) ? null : () async {
                                  auth.login(_passwordController.text, _emailController.text).then((value){
                                    if(value.isSuccess!){
                                      Navigator.pushAndRemoveUntil(context, PageTransition(child: const DashboardScreen(), type: PageTransitionType.bottomToTop), (route) => false);
                                    }else{
                                      showCustomToast(value.message ?? '');
                                    }
                                  });
                                },
                                buttonText: 'Sign in',isColor: (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty)),

                            SizedBox(height: Dimensions.fontSizeOverLarge),

                          ],
                        ),
                      ),

                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        onTap: () {
                          _emailController.clear();
                          _passwordController.clear();
                          setState(() {
                            _isPasswordLengthError = false;
                            _isPasswordError = false;
                            _isUserNameEmailError = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text("Create Account",
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: MyColor.getHeaderTextColor()),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 16,),
                    ],
                  ),

                ),
              );
            }),
      ),
    );
  }
}

