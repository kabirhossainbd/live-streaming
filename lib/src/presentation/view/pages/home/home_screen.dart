
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_streaming/controller/home_controller.dart';
import 'package:live_streaming/src/utils/constants/m_colors.dart';
import 'package:live_streaming/src/utils/constants/m_dimensions.dart';
import 'package:live_streaming/src/utils/constants/m_images.dart';
import 'package:live_streaming/src/utils/constants/m_styles.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    Get.find<HomeController>().getStoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        builder: (home) {
          return Scaffold(
            backgroundColor: MyColor.getBackgroundColor(),
            appBar: AppBar(
              backgroundColor: MyColor.getBackgroundColor(),
              elevation: 1,
              leadingWidth: 20,
              leading: const SizedBox(),
              title: Image.asset(MyImage.livePng, height: 120,)
            ),
            body: ListView(
              children: [
                const SizedBox(height: Dimensions.paddingSizeSmall),
                SizedBox(
                  height: Get.size.height/4.8,
                  child: ListView.builder(
                    itemCount: home.storyList.length + 1,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      if(index == 0){
                        return InkWell(
                          // onTap: () => Get.bottomSheet(const StoryBottomSheet()),
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.bottomCenter,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                width: 110,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: MyColor.getPrimaryColor().withOpacity(0.2),
                                    image:  const DecorationImage(image: AssetImage(MyImage.image1), fit: BoxFit.cover)
                                ),
                              ),

                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child:  Container(
                                  height: 50,
                                  width: double.infinity,
                                  alignment: Alignment.bottomCenter,
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: const BoxDecoration(
                                      color: MyColor.colorWhite,
                                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(12),)
                                  ),
                                  child: Text('Create Shorts', style: robotoRegular.copyWith(color:  MyColor.colorBlack,fontSize: 14, overflow: TextOverflow.ellipsis), maxLines: 2,),
                                ),
                              ),

                              Positioned(
                                bottom: 30,
                                left: 0,
                                right: 0,
                                child:  Container(
                                  height: 40,
                                  width: 40,
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: MyColor.getPrimaryColor(),
                                    border: Border.all(color: MyColor.colorWhite, width: 2),
                                  ),
                                  child: const Icon(Icons.add, color: MyColor.colorWhite, size: 30,),
                                ),),
                            ],
                          ),
                        );
                      }
                      return InkWell(
                        // onTap: () => Get.toNamed(RouteHelper.getStoryScreenRoute(home.storyList[index - 1].id!, home.storyList[index - 1].userName!), arguments: StoryScreen(storyUser: home.storyList[index - 1].storyUser, storyModel: home.storyList[index - 1],)),
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 110,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:MyColor.getPrimaryColor().withOpacity(0.2),
                                  image:  DecorationImage(image: AssetImage(home.storyList[index - 1].profile!), fit: BoxFit.cover)
                              ),
                              child: Text(home.storyList[index - 1].userName!, style: robotoRegular.copyWith(color:  MyColor.colorWhite, fontSize: 14, overflow: TextOverflow.ellipsis), maxLines: 2,),
                            ),

                            Positioned(
                              top: 10,
                              left: 15,
                              child:  Container(
                                height: 50,
                                width: 50,
                                decoration:  BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: MyColor.getPrimaryColor(), width: 2),
                                  image:  DecorationImage(image: AssetImage(home.storyList[index - 1].profile!), fit: BoxFit.cover),
                                ),
                              ),),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),


              ],
            )
          );
        }
    );
  }
}





