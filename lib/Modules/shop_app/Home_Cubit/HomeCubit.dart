import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Models/Categories_Model/Categories_Model.dart';
import 'package:shop_app/Models/Favourites/Favourites.dart';
import 'package:shop_app/Models/Favourites_Model/Favourites_Model.dart';
import 'package:shop_app/Models/Home_Model/HomeModel.dart';
import 'package:shop_app/Models/Shop_Model/shop_model.dart';
import 'package:shop_app/Models/category_producs.dart';
import 'package:shop_app/Modules/shop_app/Categories/CategoriesScreen.dart';
import 'package:shop_app/Modules/shop_app/Favourites/FavouritesScreen.dart';
import 'package:shop_app/Modules/shop_app/Home_Cubit/HomeStates.dart';
import 'package:shop_app/Modules/shop_app/Products/ProductsScreen.dart';
import 'package:shop_app/Modules/shop_app/Settings/SettingsScreen.dart';
import 'package:shop_app/Shared/Network/end_points.dart';
import 'package:shop_app/Shared/Network/local/Cache_Helper.dart';
import 'package:shop_app/Shared/Network/remote/Dio_Helper.dart';
import '../../../Shared/Components/components.dart';
import '../../../Shared/Constants/constants.dart';
import '../Login/Login_Screen.dart';

class HomeCubit extends Cubit<HomeStates>
{
  HomeCubit() : super(HomePageInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavouritesScreen(),
    SettingsScreen(),
  ];

  int currentIndex = 0;

  void changeNavBar(index)
  {
    currentIndex = index;
    if(index == 2) getFavouriteProducts();
    emit(HomePageChangeNavBarState());
  }

  HomeModel? homeModel;

  Map<int,bool>? favourites = {};

  void getHomeData()
  {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(url: HOME,token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      for (var element in homeModel!.data!.products!) {
       favourites?.addAll({
          element.id!: element.inFavorites!
        });
      }
      emit(ShopSuccessHomeDataState(homeModel!));
    }).catchError((onError)
    {
      emit(ShopErrorHomeDataState());
    });
  }



  CategoriesModel? categoriesModel;

  void getCategoriesData()
  {
    DioHelper.getData(url: Get_Categories).
    then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopGetCategoriesSuccessState());
    }).catchError((onError)
    {
      emit(ShopGetCategoriesErrorState());
    });
  }

  CategoryProducts? categoryProductsModel;
  Future<void> getSpecificCategoryData({required id})
  async {
    emit(ShopLoadingSpecificCategoryDataState());
    DioHelper.getData(url: '$Get_Categories/$id').
    then((value) {print("lol");
      categoryProductsModel = CategoryProducts.fromJson(value.data);
      emit(ShopGetSpecificCategorySuccessState());
    }).catchError((onError)
    {
      print(onError.toString());
      emit(ShopGetSpecificCategoryErrorState());
    });
  }


  void signOut(context)
  {
    CacheHelper.removeData(key: 'token').then((value) {
      if(value)
        {
          navigateAndFinish(context,LoginScreen());
        }
    });
  }

  FavouritesModel? favouritesModel;


  void changeFavourites(int id)
  {
    favourites![id] = !favourites![id]!;
    emit(ShopChangeFavouritesState());

    DioHelper.postData(
        url: FAVOURITES,
        data: {
          'product_id': id,
        },
        token: token
    ).then((value) {
        favouritesModel = FavouritesModel.fromJson(value.data);
        if(!favouritesModel!.status!) {
          favourites![id] = !favourites![id]!;
        } else {
          getFavouriteProducts();
        }
        emit(ShopChangeFavouritesSuccessState(favouritesModel!));
    }).catchError((onError) {
        favourites![id] = !favourites![id]!;
        emit(ShopChangeFavouritesErrorState());
    });
  }


  FavouritesProducts? favouriteProducts;

  void getFavouriteProducts()
  {
    emit(ShopGetFavouritesLoadingState());
    DioHelper.getData(url: FAVOURITES,token: token).
    then((value) {
      favouriteProducts = FavouritesProducts.fromJson(value.data);

      emit(ShopGetFavouritesSuccessState());
    }).catchError((onError)
    {
      emit(ShopGetFavouritesErrorState());
    });
  }


  ShopAppModel? userModel;

  void getUserData()
  {
    DioHelper.getData(url: PROFILE,token: token).
    then((value) {
      userModel = ShopAppModel.fromJson(value.data);
      emit(ShopGetUserSuccessState());
    }).catchError((onError)
    {
      emit(ShopGetUserErrorState());
    });
  }

  void updateUserData({
      required String name,
      required String email,
      required String phone
  })
  {
    emit(ShopUpdateUserLoadingState());
    DioHelper.putData(
        url: UPDATE,
        data: {
          'name': name,
          'email': email,
          'phone': phone
        },
        token: token).
    then((value) {
      userModel = ShopAppModel.fromJson(value.data);
      emit(ShopUpdateUserSuccessState());
    }).catchError((onError)
    {
      emit(ShopUpdateUserErrorState());
    });
  }

  Future<void> addToCart({
    required int id,
  })
  async {
    emit(ShopAddToCartLoadingState());
    DioHelper.postData(
        url: CART,
        data: {
          'product_id': id,
        },
        token: token
    ).then((value) {
      print(value.data);
      emit(ShopAddToCartSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(ShopAddToCartErrorState());
    });
  }

}