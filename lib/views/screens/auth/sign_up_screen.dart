import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/views/screens/auth/login_screen.dart';
import 'package:tiktok_clone/views/widgets/text_input_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();

  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tiktok Clone",
                    style: TextStyle(
                        color: buttonColor,
                        fontSize: 35,
                        fontWeight: FontWeight.w900
                    ),
                  ),
                  Text(
                    "Register",
                    style: TextStyle(
                        color: buttonColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  const SizedBox(height: 25,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextInputField(
                      controller: _userNameController,
                      label: "Username",
                      icon: Icons.person,
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage("https://www.portmelbournefc.com.au/wp-content/uploads/2022/03/avatar-1.jpeg"),
                        backgroundColor: backgroundColor,
                      ),
                      Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(onPressed: (){
                            _authController.pickImage();
                          }, icon: const Icon(Icons.camera_alt))
                      )
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextInputField(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email,
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextInputField(
                      controller: _passwordController,
                      label: "Password",
                      icon: Icons.lock,
                      isObscure: true,
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Container(
                    width: MediaQuery.of(context).size.width-40,
                    height: MediaQuery.of(context).size.height*0.08,
                    //height: 50,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: InkWell(
                      onTap: (){

                        _authController.registerUser(
                            _userNameController.text.trim(),
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _authController.getProfilePic
                        );
                      },
                      child: const Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Get.to(()=>LoginScreen());
                        },
                        child: Text("Login",style: TextStyle(
                            fontSize: 20,
                            color: buttonColor
                        ),),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
