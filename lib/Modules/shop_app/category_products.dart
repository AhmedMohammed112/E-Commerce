import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Modules/shop_app/Home_Cubit/HomeCubit.dart';
import '../../Models/category_producs.dart';
import '../../Shared/Style/color/colors.dart';
import 'Home_Cubit/HomeStates.dart';


class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = HomeCubit.get(context).categoryProductsModel!.data!.data;

    return BlocConsumer<HomeCubit,HomeStates>(
        listener: (context,state) {},
        builder: (context,state) {
          return  Scaffold(
            appBar: AppBar(),
            body: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 1.00,
              crossAxisSpacing: 1.00,
              childAspectRatio: 1 / 1.55,
              crossAxisCount: 2,
              children: List.generate(model!.length, (index) => buildProductItem(model[index],context)),
            ),
          );
        },
    );
  }

  buildProductItem(CategoryProductsData model, BuildContext context) => Container(
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(image: NetworkImage(model.image!),
              width: double.infinity,
              height: 200,
            ),
            if(model.discount != 0)
              Container(
                  color: Colors.red,
                  child: const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text("Discount",style: TextStyle(color: Colors.white),),
                  )
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10.00),
          child: Column(
            children: [
              Text(model.name!,style: const TextStyle(fontSize: 14.00,height: 1.3,fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),
              Row(
                children: [
                  Text("${model.price}",style: const TextStyle(fontSize: 14.00,color: defaultColor),),
                  const SizedBox(width: 5.00,),
                  if(model.discount != 0)
                    Text("${model.oldPrice}",style: const TextStyle(fontSize: 12.00,color: Colors.grey,decoration: TextDecoration.lineThrough),),
                  const Spacer(),
                  IconButton(onPressed: () {HomeCubit.get(context).changeFavourites(model.id!);}, icon: CircleAvatar(backgroundColor: HomeCubit.get(context).favourites![model.id]!? defaultColor :  Colors.grey ,radius: 15.00,child: const Icon(Icons.favorite_border,size: 14.00,color: Colors.white,),),padding: const EdgeInsets.all(0),)
                ],
              ),
            ],
          ),
        ),

      ],
    ),
  );
}
