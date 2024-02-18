import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Models/Shop_Model/shop_model.dart';
import 'package:shop_app/Modules/shop_app/Register_Screen/Register_Cubit/Register_States.dart';
import 'package:shop_app/Shared/Network/end_points.dart';
import 'package:shop_app/Shared/Network/remote/Dio_Helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(ShopRegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  ShopAppModel? shopAppModel;


  void userRegister({required String name,required String email,required String phone, required String password}) {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
        url: REGISTER,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        }
    ).then((value) {
      shopAppModel = ShopAppModel.fromJson(value.data);

      emit(ShopRegisterSuccessState(shopAppModel));
    }).catchError((onError) {
      emit(ShopRegisterErrorState());
    });
  }

  IconData icon = Icons.remove_red_eye_outlined;
  bool isShown = true;

  void changeText() {
    isShown = ! isShown;
    isShown ? icon = Icons.remove_red_eye_outlined : icon = Icons.remove_red_eye;
    emit(ShoppRegisterChangeText());
  }
}
