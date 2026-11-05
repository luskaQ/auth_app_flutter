import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/lottie_dialog.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/social_button.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool Validate(String email) {
    bool isvalid = EmailValidator.validate(email);
    return isvalid;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> forgotPassword() async {
    if (emailController.text.trim().isEmpty) {
      showAlert('Digite seu email primeiro.');
      return;
    }
    else if(!Validate(emailController.text)){
      showAlert('Digite um email válido!');
      return;
    }
    
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: emailController.text.trim(),
    );
    if (!mounted) return;
    showAlert('Enviamos um link para seu email!');
  }

  Future<void> signIn() async {
    final navigator = Navigator.of(context);
    final lottieController = LottieDialogController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LottieDialogWidget(
        controller: lottieController,
        loadingMessage: 'Entrando...',
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      lottieController.showSuccess('Login aceito!');
      await Future.delayed(const Duration(milliseconds: 1500));

      if (navigator.canPop()) {
        navigator.pop();
      }
    } on FirebaseAuthException catch (e) {
      if (navigator.canPop()) {
        navigator.pop();
      }
      showAlert(switch (e.code) {
        'invalid-credential' => 'Email ou senha incorretos.',
        _ => 'Não foi possível entrar. Tente novamente.',
      });
    } catch (_) {
      if (navigator.canPop()) {
        navigator.pop();
      }
      showAlert('Ocorreu um erro. Tente novamente.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/icon/icon.png', height: 100),
                const SizedBox(height: 20),
                const Text(
                  'Bem-vindo de volta!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Senha',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                TextButton(
                  onPressed: forgotPassword,
                  child: const Text('Esqueceu a senha?'),
                ),
                MyButton(onTap: (){
                  if (Validate(emailController.text)){
                    signIn();
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Insira um email válido!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }, text: 'Entrar', icon: Icons.login),
                const SizedBox(height: 25),
                const Text('ou continue com'),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      SocialButton(
                        icon: Icons.g_mobiledata,
                        label: 'Google',
                        onTap: () {},
                      ),
                      const SizedBox(width: 12),
                      SocialButton(
                        icon: Icons.apple,
                        label: 'Apple',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                  child: const Text('Registre-se agora'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
