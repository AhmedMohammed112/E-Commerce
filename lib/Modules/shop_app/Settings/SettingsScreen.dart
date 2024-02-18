import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Home_Cubit/HomeCubit.dart';
import '../Home_Cubit/HomeStates.dart';
import 'package:shop_app/Shared/Style/color/colors.dart';

class SettingsScreen extends StatelessWidget {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {

          nameController.text = HomeCubit.get(context).userModel!.data!.name!;
          emailController.text = HomeCubit.get(context).userModel!.data!.email!;
          phoneController.text = HomeCubit.get(context).userModel!.data!.phone!;

          return ConditionalBuilder(
              condition: HomeCubit.get(context).userModel != null,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(20.00),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if(state is ShopUpdateUserLoadingState)
                        const LinearProgressIndicator(),
                      const SizedBox(height: 20.00,),
                      //create circle avatar image
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64.00,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 60.00,
                                child: Text(HomeCubit.get(context).userModel!.data!.name![0]),
                              ),
                            ),
                            CircleAvatar(
                              radius: 20.00,
                              backgroundColor: Colors.grey[300],
                              child: IconButton(
                                onPressed: () {

                                },
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 16.00,
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 40.00,),
                      TextFormField(
                        controller: nameController,
                        validator: (value)
                        {
                          if(value!.isEmpty) {
                            return 'Name Required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person),
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
                      const SizedBox(height: 20.00,),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name Required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email),
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
                      const SizedBox(height: 20.00,),
                      TextFormField(
                        controller: phoneController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name Required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          labelText: 'Phone Number',
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
                      const SizedBox(height: 20.00,),
                      SizedBox(
                        height: 45.00,
                        width: double.infinity,
                        child: MaterialButton(
                          color: defaultColor,
                          onPressed:() {
                            if(formKey.currentState!.validate())
                              {
                                HomeCubit.get(context).updateUserData(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text
                                );
                              }
                          },
                          child: const Text("Update Profile",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.00,color: Colors.white),),
                        ),
                      ),
                      const SizedBox(height: 20.00,),
                      SizedBox(
                        height: 45.00,
                        width: double.infinity,
                        child: MaterialButton(
                          color: defaultColor,
                          onPressed:() {
                            HomeCubit.get(context).signOut(context);
                          },
                          child: const Text("Sign Out",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.00,color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              fallback: (context) => const Center(child: CircularProgressIndicator())
          );
        }
    );
  }
}
