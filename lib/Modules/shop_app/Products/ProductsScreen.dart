import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Models/Categories_Model/Categories_Model.dart';
import 'package:shop_app/Modules/shop_app/Home_Cubit/HomeCubit.dart';
import 'package:shop_app/Modules/shop_app/Home_Cubit/HomeStates.dart';
import 'package:shop_app/Shared/Components/components.dart';
import 'package:shop_app/Shared/Style/color/colors.dart';

import '../../../Models/Home_Model/HomeModel.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeStates>(
        listener: (context,state) {
          if(state is ShopChangeFavouritesSuccessState)
            {
              if(!state.model.status!)
                {
                  showToast(message: state.model.message!, state: ToastStates.ERROR);
                }
            }
        },
        builder: (context,state) {
          return  ConditionalBuilder(
            condition: HomeCubit.get(context).homeModel != null && HomeCubit.get(context).categoriesModel != null,
            builder: (context) => productBuilder(HomeCubit.get(context).homeModel!,HomeCubit.get(context).categoriesModel,context),
            fallback:(context) => const Center(child: CircularProgressIndicator()),
          );
        },
);


  }

  Widget productBuilder(HomeModel model, CategoriesModel? categoriesModel,context) => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),

    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
            items: model.data!.banners!.map((e) =>
                Image(
                  image: NetworkImage(e.image!),
                  width: double.infinity,
                  fit: BoxFit.cover,
                )).toList(),
            options: CarouselOptions(
              height: 250.00,
              initialPage: 0,
              enableInfiniteScroll: true,
              viewportFraction: 1.00,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            )
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.00
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Categories",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),),
              const SizedBox(height: 15,),
              SizedBox(
                height: 100.00,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index) => buildCategoriesItem(categoriesModel!.data!.data[index]),
                    separatorBuilder: (context,index) => const SizedBox(width: 10.00,),
                    itemCount: categoriesModel!.data!.data.length
                ),
              ),
              const SizedBox(height: 15,),
              const Text("New Products",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),),
            ],
          ),
        ),
        const SizedBox(height: 15.00,),
        Container(
          color: Colors.grey,
          child: GridView.count(
            shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 1.00,
              crossAxisSpacing: 1.00,
              childAspectRatio: 1 / 1.55,
              crossAxisCount: 2,
            children: List.generate(model.data!.products!.length, (index) =>buildProductItem(model.data!.products![index],context) ),
          ),
        )
      ],
    ),
  );

  Widget buildCategoriesItem(PageData category) => Stack(
    alignment: AlignmentDirectional.bottomStart,
    children: [
      Image(
        image: NetworkImage(category.image!),
        height: 100.00,
        width: 100.00,
      ),
      Container(
          width: 100,
          color: Colors.black.withOpacity(0.8),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(category.name!,style: const TextStyle(color: Colors.white),textAlign: TextAlign.center,maxLines: 1,),
          )),
    ],
  );


  Widget buildProductItem(ProductModel model,context) => Container(
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
                  Text("${model.price.round()}",style: const TextStyle(fontSize: 14.00,color: defaultColor),),
                  const SizedBox(width: 5.00,),
                  if(model.discount != 0)
                    Text("${model.oldPrice.round()}",style: const TextStyle(fontSize: 12.00,color: Colors.grey,decoration: TextDecoration.lineThrough),),
                  const Spacer(),
                  IconButton(onPressed: () {HomeCubit.get(context).changeFavourites(model.id!);}, icon: CircleAvatar(backgroundColor: HomeCubit.get(context).favourites![model.id]!? defaultColor :  Colors.grey ,radius: 15.00,child: const Icon(Icons.favorite_border,size: 14.00,color: Colors.white,),),padding: EdgeInsets.all(0),)
                ],
              ),
            ],
          ),
        ),

      ],
    ),
  );

}
