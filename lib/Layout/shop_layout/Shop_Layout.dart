
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Modules/nav_drawer.dart';
import 'package:shop_app/Modules/shop_app/Home_Cubit/HomeCubit.dart';
import 'package:shop_app/Modules/shop_app/Home_Cubit/HomeStates.dart';
import 'package:shop_app/Modules/shop_app/Search/SearchScreen.dart';
import 'package:shop_app/Shared/Components/components.dart';

class ShopAppLayout extends StatelessWidget {
  const ShopAppLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          return Scaffold(
            drawer: const NavDrawer(),
            appBar: AppBar(
              title: const Text("Salla", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),),
              actions: [
                IconButton(
                    onPressed: () {
                      navigateTo(context, SearchScreen());
                    },
                    icon: const Icon(Icons.search),
                )
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
                onTap: (int index)
                {
                  cubit.changeNavBar(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home'
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.apps),
                      label: 'Categories'
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      label: 'favorite'
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'settings'
                  ),
                ]
            ),
            body: cubit.screens[cubit.currentIndex],

          );
        }
    );
  }

}
