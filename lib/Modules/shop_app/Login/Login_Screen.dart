import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Layout/shop_layout/Shop_Layout.dart';
import 'package:shop_app/Modules/shop_app/Login/LoginCubit/LoginCubit.dart';
import 'package:shop_app/Modules/shop_app/Login/LoginCubit/LoginStates.dart';
import 'package:shop_app/Modules/shop_app/Register_Screen/Register_Screen.dart';
import 'package:shop_app/Shared/Components/components.dart';
import 'package:shop_app/Shared/Constants/constants.dart';
import 'package:shop_app/Shared/Network/local/Cache_Helper.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit(),
      child: BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state) {
          if(state is ShopAppSuccessState)
            {
              if(state.loginmodel.status!)
                {
                    showToast(message: state.loginmodel.message!, state: ToastStates.SUCCESS);
                    CacheHelper.saveData(key: 'token', value: state.loginmodel.data!.token).then((value) {
                      token = state.loginmodel.data!.token!;
                      navigateAndFinish(context, const ShopAppLayout());
                    });
                }
              else
                {
                  showToast(message: state.loginmodel.message!, state: ToastStates.ERROR);
                }
            }
        },
        builder:  (context,state) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(30.00),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Login",style: Theme.of(context).textTheme.headline5,),
                      const SizedBox(height: 20.00,),
                      Text("Login to browse hot Offers",style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey),),
                      const SizedBox(height: 30.00,),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if(value!.isEmpty)
                          {
                            return 'Email Required';
                          }
                          return null;
                        },
                        onChanged: (value) {},
                        onTap: () {},
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Email Address",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 30.00,),
                      TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if(value!.isEmpty)
                          {
                            return 'Password Required';
                          }
                          return null;
                        },
                        obscureText: ShopCubit.get(context).isShown,
                        onChanged: (value) {
                        },
                        onFieldSubmitted: (value)
                        {
                          if(formKey.currentState!.validate()) {
                            ShopCubit.get(context).login(email: emailController.text, password: passwordController.text);
                          }
                        },
                        onTap: () {},
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                ShopCubit.get(context).changeText();
                              },
                              icon: Icon(ShopCubit.get(context).icon,),),
                        ),

                      ),
                      const SizedBox(height: 30.00,),
                      ConditionalBuilder(
                          condition: state != ShopAppLoadingState,
                          builder: (context) => Container(
                            height: 50.00,
                            width: double.infinity,
                            color: Colors.blue,

                            child: MaterialButton(
                              onPressed: ()
                              {
                                if(formKey.currentState!.validate()) {
                                ShopCubit.get(context).login(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                              child: const Text("LOGIN"),
                            ),
                          ),
                          fallback: (context) => const Center(child: CircularProgressIndicator()),
                      ),
                      const SizedBox(height: 30.00,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("Don't have account?"),
                          const SizedBox(width: 20.00,),
                          TextButton(
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              },
                              child: const Text("REGISTER")
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

      ),
    );
  }
}


