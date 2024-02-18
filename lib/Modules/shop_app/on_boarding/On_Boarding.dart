
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Modules/shop_app/Login/Login_Screen.dart';
import 'package:shop_app/Shared/Components/components.dart';
import 'package:shop_app/Shared/Network/local/Cache_Helper.dart';
import 'package:shop_app/Shared/Style/color/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnBoardingModel
{
  final String image;
  final String title;
  final String body;

  OnBoardingModel({required this.image, required this.title, required this.body});
}

class OnBoardingScreen extends StatelessWidget {
  var pageController = PageController();
   bool isLast = false;


  List<OnBoardingModel> modelOn =
  [
    OnBoardingModel(image : 'assets/Images/Shopping.png',title: 'Shopping 1',body: 'body 1'),
    OnBoardingModel(image : 'assets/Images/Shopping.png',title: 'Shopping 2',body: 'body 2'),
    OnBoardingModel(image : 'assets/Images/Shopping.png',title: 'Shopping 3',body: 'body 3'),
  ];

  OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: ()
            {
              CacheHelper.saveData(key: 'OnBoarding', value: true).then((value) {
                if(value)
                {
                  CacheHelper.saveData(key: 'OnBoarding', value: true).then((value) {
                    if(value)
                    {
                      navigateAndFinish(context, LoginScreen());
                    }
                  });
                  navigateAndFinish(context, LoginScreen());
                }
              });
            },
              child: const Text("Skip"),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.00),
        child: Column(
          children: [
            Expanded(
                child: PageView.builder(
                  controller: pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index)
                  {
                    if(index == modelOn.length-1) { isLast = true;}
                    else {isLast = false;}
                  },
                  itemBuilder: (context,index) => buildItem(modelOn[index]) ,
                  itemCount: modelOn.length,
                )),
            const SizedBox(height: 40.00,),
            Row(
              children : [
                SmoothPageIndicator(
                    controller: pageController,
                    count: modelOn.length,
                    effect: const ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: defaultColor,
                      dotHeight: 10,
                      expansionFactor: 4,
                      dotWidth: 10,
                      spacing: 5.00,
                    )
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if(isLast)
                      {
                        CacheHelper.saveData(key: 'OnBoarding', value: true).then((value) {
                          if(value)
                          {
                            navigateAndFinish(context, LoginScreen());
                          }
                        });
                      }
                    else {
                      pageController.nextPage(duration: const Duration(milliseconds: 750), curve: Curves.fastLinearToSlowEaseIn,);
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios_outlined),
                )
            ]
            )
          ],
        ),
      ),
    );
  }
}
Widget buildItem(OnBoardingModel model) => Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(child: Image(image: AssetImage(model.image)),),
    const SizedBox(height: 20.00),
    Text(model.title,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 30.00),),
    const SizedBox(height: 20.00),
    Text(model.body,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 10.00),),


  ],
  
);

