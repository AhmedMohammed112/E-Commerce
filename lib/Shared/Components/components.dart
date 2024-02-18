import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Modules/shop_app/Home_Cubit/HomeCubit.dart';
import '../Style/color/colors.dart';

void navigateTo(context,widget) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget)
);

void navigateAndFinish(context,widget) => Navigator.pushAndRemoveUntil(
       context,
       MaterialPageRoute(builder: (context) => widget),
       (Route<dynamic>route) => false,
);

void showToast({
       required String message,
       required ToastStates state
}) =>  Fluttertoast.showToast(
                         msg: message,
                         toastLength: Toast.LENGTH_LONG,
                         gravity: ToastGravity.BOTTOM,
                         timeInSecForIosWeb: 5,
                         backgroundColor: showColor(state),
                         textColor: Colors.white,
                         fontSize: 16.0
);

enum ToastStates {SUCCESS,ERROR,WARNING}

Color? color;

Color? showColor(ToastStates state)
{
         switch(state)
         {
                case ToastStates.SUCCESS:
                       color = Colors.green;
                       break;
                case ToastStates.ERROR:
                       color = Colors.red;
                       break;
                case ToastStates.WARNING:
                       color = Colors.amber;
                       break;
         }
         return color;
}


Widget buildItem(model,context) => Padding(
  padding: const EdgeInsets.all(20.00),
  child: SizedBox(
    height: 120.00,
    child: Row(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(image: NetworkImage(
                model.image!),
              fit: BoxFit.cover,
              width: 120.00,
              height: 120.00,
            ),
            if(model.discount != 0)
              Container(
                  color: Colors.red,
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text("Discount",
                      style: TextStyle(color: Colors.white),),
                  )
              ),
          ],
        ),
        const SizedBox(width: 20.00,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                model.name!,
                style: const TextStyle(fontSize: 14.00,
                    height: 1.3,
                    fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,),
              const Spacer(),
              Row(
                children: [
                  Text("${model.price!}", style: const TextStyle(
                      fontSize: 14.00, color: defaultColor),),
                  const SizedBox(width: 5.00,),
                  if(model.discount != 0)
                    Text("${model.oldPrice!}", style: const TextStyle(fontSize: 12.00,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough),),
                  const Spacer(),
                  IconButton(onPressed: () {
                    HomeCubit.get(context).changeFavourites(model.id!);
                  }, icon: CircleAvatar(backgroundColor: HomeCubit.get(context).favourites![model.id!]! ? defaultColor : Colors.grey,
                    radius: 15.00,child: const Icon(Icons
                      .favorite_border, size: 14.00, color: Colors
                      .white,),), padding: const EdgeInsets.all(0),)
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);

