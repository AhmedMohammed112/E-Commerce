import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Models/Categories_Model/Categories_Model.dart';
import 'package:shop_app/Models/category_producs.dart';
import 'package:shop_app/Modules/shop_app/Home_Cubit/HomeCubit.dart';
import 'package:shop_app/Shared/Components/components.dart';

import '../Home_Cubit/HomeStates.dart';
import '../category_products.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeStates>(
        listener: (context,state) {},
        builder: (context,state) {
            return ListView.separated(
                itemBuilder: (context,index) => buildCategoriesItem(HomeCubit.get(context).categoriesModel!.data!.data[index],context),
                separatorBuilder: (context,index) => Container(
                  height: 1.00,
                  color: Colors.grey[300],
                ),
                itemCount: HomeCubit.get(context).categoriesModel!.data!.data.length
            );
        }
    );
  }

  Widget buildCategoriesItem(PageData model,BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.00,vertical: 10.00),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.00),
        color: Colors.grey[300],
      ),
      child: InkWell(
        onTap: () {
          HomeCubit.get(context).getSpecificCategoryData(id: model.id!).then((value) {
            navigateTo(context,const CategoryProductsScreen());
          });

        },
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.00),
              ),
              child: Image(image: NetworkImage(model.image!),
                fit: BoxFit.cover,
                height: 120.00,
                width: 120.00,
              ),
            ),
            const SizedBox(width: 10.00,),
            Text(model.name!,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    ),
  );
}
