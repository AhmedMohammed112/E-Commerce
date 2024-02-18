import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Models/Search_Model/Search_Model.dart';
import 'package:shop_app/Modules/shop_app/Search/Search_Cubit/Search_States.dart';
import 'package:shop_app/Shared/Constants/constants.dart';
import 'package:shop_app/Shared/Network/end_points.dart';
import 'package:shop_app/Shared/Network/remote/Dio_Helper.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(ShopSearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;


  void search({required String text}) {
    emit(ShopSearchLoadingState());
    DioHelper.postData(
        url: SEARCH,
        data: {
          'text': text
        },
      token: token
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);

      emit(ShopSearchSuccessState(searchModel));
    }).catchError((onError) {
      emit(ShopSearchErrorState());
    });
  }

}
