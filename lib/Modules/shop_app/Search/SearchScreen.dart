import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Modules/shop_app/Search/Search_Cubit/Search_Cubit.dart';
import 'package:shop_app/Modules/shop_app/Search/Search_Cubit/Search_States.dart';
import '../../../Shared/Components/components.dart';

class SearchScreen extends StatelessWidget {

  final searchController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit,SearchStates>(
        listener: (context,state) {},
        builder: (context,state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.00),
                child: Column(
                  children: [
                    TextFormField(
                      controller: searchController,
                      validator: (value)
                      {
                        if(value!.isEmpty) {
                          return 'Enter Product Name';
                        }
                        return null;
                      },
                      onFieldSubmitted: (String value)
                      {
                        SearchCubit.get(context).search(text: value);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(0.0),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.00,),
                    if(state is ShopSearchSuccessState)
                      Expanded(
                      child: ListView.separated(
                          itemBuilder: (context,index) =>
                              buildItem(SearchCubit.get(context).searchModel!.data!.data![index],context),
                          separatorBuilder: (context, index) =>
                              Container(
                                width: double.infinity,
                                height: 1.00,
                                color: Colors.grey[300],
                              ),
                          itemCount: SearchCubit.get(context).searchModel!.data!.data!.length
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },

      ),
    );
  }


}
