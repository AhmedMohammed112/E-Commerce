import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Models/Shop_Model/shop_model.dart';
import 'package:shop_app/Modules/shop_app/Login/LoginCubit/LoginStates.dart';
import 'package:shop_app/Shared/Network/end_points.dart';
import 'package:shop_app/Shared/Network/remote/Dio_Helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopAppLoadingState());

  static ShopCubit get(context) => BlocProvider.of(context);

  ShopAppModel? shopAppModel;


  void login({required String email, required String password}) {
    emit(ShopAppLoadingState());
    DioHelper.postData(
        url: LOGIN,
        data: {
          'email': email,
          'password': password,
        }
    ).then((value) {
      shopAppModel = ShopAppModel.fromJson(value.data);
      emit(ShopAppSuccessState(shopAppModel!));
    }).catchError((onError) {
      emit(ShopAppErrorState(onError));
    });
  }

  IconData icon = Icons.remove_red_eye_outlined;
  bool isShown = true;

  void changeText() {
    isShown = ! isShown;
    isShown ? icon = Icons.remove_red_eye_outlined : icon = Icons.remove_red_eye;
    emit(ShoppAppChangeText());
  }
}
