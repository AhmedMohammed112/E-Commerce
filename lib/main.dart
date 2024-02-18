import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Layout/shop_layout/Shop_Layout.dart';
import 'package:shop_app/Modules/shop_app/Home_Cubit/HomeCubit.dart';
import 'package:shop_app/Modules/shop_app/Login/Login_Screen.dart';
import 'Modules/shop_app/on_boarding/On_Boarding.dart';
import 'Shared/Bloc_Observer.dart';
import 'Shared/Constants/constants.dart';
import 'Shared/Cubit/cubit.dart';
import 'Shared/Cubit/states.dart';
import 'Shared/Style/themes.dart';
import 'package:shop_app/Shared/Network/remote/Dio_Helper.dart';
import 'package:shop_app/Shared/Network/local/Cache_Helper.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'isDark') ?? false;
  bool onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;
  token = CacheHelper.getData(key: 'token') ?? '';
  Widget widget;
    if(onBoarding != '')
      {
        if(token != '') {
          widget = const ShopAppLayout();
        } else {
          widget = LoginScreen();
        }
      }
    else {
      widget = OnBoardingScreen();
    }


  runApp(MyApp(
    isDark: isDark,
    startWidget : widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  //final bool OnBoarding;
  final Widget startWidget;

  const MyApp({super.key, required this.isDark,required this.startWidget});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AppCubit()..changeMode(fromShared: isDark)),
        BlocProvider(create: (BuildContext context) => HomeCubit()..getHomeData()..getCategoriesData()..getFavouriteProducts()..getUserData())
      ],
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,state) {},
        builder: (context,state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: LighteMode,
            darkTheme: DarkMode,
            // themeMode: AppCubit.get(context).IsDark ? ThemeMode.dark :  ThemeMode.light,
            themeMode: ThemeMode.light,

            home: startWidget,
            //home: ShopAppLayout(),
          );
        },
      ),
    );
  }
}

