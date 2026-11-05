import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/lottie_dialog.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool Validate(String email) {
    bool isvalid = EmailValidator.validate(email);
    return isvalid;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(content: Text(message)),
    );
  }

  Future<void> register() async {
    if (passwordController.text != confirmController.text) {
      showAlert('Senhas não conferem!');
      return;
    }
    final navigator = Navigator.of(context);
    final lottieController = LottieDialogController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LottieDialogWidget(
        controller: lottieController,
        loadingMessage: 'Criando conta...',
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      lottieController.showSuccess('Conta criada com sucesso!');
      await Future.delayed(const Duration(milliseconds: 1500));

      if (navigator.canPop()) {
        navigator.pop();
      }
      if (navigator.canPop()) {
        navigator.pop();
      }
    } on FirebaseAuthException catch (e) {
      if (navigator.canPop()) {
        navigator.pop();
      }
      showAlert(switch (e.code) {
        'email-already-in-use' => 'Já existe um usuário com esse email!',
        'weak-password' => 'Escolha uma senha mais forte.',
        _ => 'Não foi possível cadastrar. Tente novamente.',
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
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Crie sua conta'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
              const SizedBox(height: 15),
              MyTextField(
                controller: confirmController,
                hintText: 'Confirmar senha',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 25),
              MyButton(
                onTap: () {
                  if (Validate(emailController.text)) {
                    register();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Insira um email válido!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                text: 'Registrar',
                icon: Icons.person_add,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
