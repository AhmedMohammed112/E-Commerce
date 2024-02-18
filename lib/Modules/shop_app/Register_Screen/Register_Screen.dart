import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Modules/shop_app/Register_Screen/Register_Cubit/Register_Cubit.dart';
import 'package:shop_app/Modules/shop_app/Register_Screen/Register_Cubit/Register_States.dart';
import 'package:shop_app/Shared/Network/local/Cache_Helper.dart';

import '../../../Layout/shop_layout/Shop_Layout.dart';
import '../../../Shared/Components/components.dart';
import '../../../Shared/Constants/constants.dart';
import '../../../Shared/Style/color/colors.dart';

class RegisterScreen extends StatelessWidget {

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => RegisterCubit(),
    child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if(state is ShopRegisterSuccessState)
          {
            if(state.dataModel!.status!)
            {
              showToast(message: state.dataModel!.message!, state: ToastStates.SUCCESS);
              token = state.dataModel!.data!.token!;
              CacheHelper.saveData(key: 'token', value: state.dataModel!.data!.token).then((value) {
                navigateAndFinish(context, const ShopAppLayout());
              });
            }
            else
            {
              showToast(message: state.dataModel!.message!, state: ToastStates.ERROR);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.00),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Register",style: Theme.of(context).textTheme.headline5,),
                        const SizedBox(height: 20.00,),
                        Text("Register to browse hot Offers",style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey),),
                        const SizedBox(height: 20.00,),
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
                              return 'Email Required';
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
                              return 'Phone Required';
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
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password Required';
                            }
                          },
                          obscureText: RegisterCubit.get(context).isShown,

                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {RegisterCubit.get(context).changeText();},
                              icon: Icon(RegisterCubit.get(context).icon),
                            ),
                            labelText: 'Password',
                            border: const OutlineInputBorder(
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
                    ConditionalBuilder(
                      condition: state != ShopRegisterLoadingState,
                      builder: (context) => SizedBox(
                        height: 45.00,
                        width: double.infinity,
                        child: MaterialButton(
                          color: defaultColor,
                          onPressed:() {
                            if(formKey.currentState!.validate()) {
                              RegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          child: const Text("REGISTER",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.00,color: Colors.white),),
                        ),
                      ),
                      fallback: (context) => const Center(child: CircularProgressIndicator()),
                    )]
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    )
    );
  }
}
