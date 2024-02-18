
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Shared/Cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isDark = false;

  void changeMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(ChangeAppModeState());
    }
    else {
      isDark = !isDark;
      //cache_helper.PutData(key: 'IsDark', value: IsDark).then((value) {
        emit(ChangeAppModeState());
      //});
    }
  }
}
