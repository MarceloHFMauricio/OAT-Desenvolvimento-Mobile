import 'package:flutter/material.dart';
import '../viewmodels/auth_viewmodel.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _viewModel = AuthViewModel();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_balance_wallet, size: 80, color: Theme.of(context).primaryColor),
                    const SizedBox(height: 16),
                    Text("Meu Dinheiro", style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                      onPressed: () {
                        if (_viewModel.authenticate(_emailController.text, _passwordController.text)) {
                          Navigator.pushReplacementNamed(context, '/dashboard');
                        }
                      },
                      child: Text(_viewModel.isLoginMode ? 'Entrar' : 'Cadastrar'),
                    ),
                    TextButton(
                      onPressed: _viewModel.toggleMode,
                      child: Text(_viewModel.isLoginMode ? 'Criar nova conta' : 'Já tenho conta'),
                    )
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}