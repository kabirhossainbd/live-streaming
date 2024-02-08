
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_streaming/controller/home_controller.dart';
import 'package:live_streaming/src/presentation/view/pages/create_steaming/create_streaming_screen.dart';
import 'package:live_streaming/src/presentation/view/pages/home/room_view.dart';
import 'package:live_streaming/src/utils/constants/m_colors.dart';
import 'package:live_streaming/src/utils/constants/m_dimensions.dart';
import 'package:live_streaming/src/utils/constants/m_images.dart';
import 'package:live_streaming/src/utils/constants/m_styles.dart';
import 'package:lottie/lottie.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    Get.find<HomeController>().getStoryList();
    Get.find<HomeController>().getRoomList('1', true, false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    /// for you api pagination
    Get.find<HomeController>().setOffset(1);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==  _scrollController.position.maxScrollExtent) {
        int pageSize = (Get.find<HomeController>().roomTotalSize / 10).ceil();
        if (Get.find<HomeController>().offset < pageSize) {
          Get.find<HomeController>().setOffset(Get.find<HomeController>().offset+1);
          debugPrint('end of the page');
          Get.find<HomeController>().showBottomLoader();
          Get.find<HomeController>().getRoomList(Get.find<HomeController>().offset.toString(), false, false);
        }
      }
    });
    return GetBuilder<HomeController>(
        builder: (home) {
          return Scaffold(
            backgroundColor: MyColor.getBackgroundColor(),
            appBar: AppBar(
              backgroundColor: MyColor.getBackgroundColor(),
              elevation: 1,
              leadingWidth: 0,
              leading: const SizedBox(),
              title: Image.asset(MyImage.livePng, height: 120,)
            ),
            body: ListView(
              controller: _scrollController,
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
                const SizedBox(height: Dimensions.paddingSizeMiniLarge),


                if(home.emptyRoomList)...[
                  const Center(child: CircularProgressIndicator(),)
                ]else if(home.roomList.isEmpty)...[
                  Center(
                    child: Column( mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 32,),
                        SvgPicture.asset(MyImage.start, height: 64, width: 64,),
                        const SizedBox(height: 8,),
                        Text('No one is live at this moment', style: robotoRegular.copyWith(color: const Color(0xFF475467), fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,),
                        const SizedBox(height: 16,),
                        InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            onTap: ()=> Navigator.push(context, CupertinoPageRoute(builder: (_) => const AddVideoScreen())),
                            child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                decoration:  BoxDecoration(
                                    color: const Color(0xFF006EFF),
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Text('Go Live',style: robotoSemiBold.copyWith(color: MyColor.colorWhite, fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,))),
                      ],
                    ),
                  ),
                ]else...[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: StaggeredGridView.countBuilder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        itemCount: home.roomList.length,
                        itemBuilder: (context, idx) =>  UserDataView(dataModel: home.roomList[idx], isForYou: true,),
                        staggeredTileBuilder: (index) => const StaggeredTile.fit(1)),
                    // staggeredTileBuilder: (index) => StaggeredTile.count(index == 2 ? 6 : 3 , index == 2 ? 1.5 : 3)),
                  ),
                ],
                const SizedBox(height: 60,),

              ],
            )
          );
        }
    );
  }
}





