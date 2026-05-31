# App Financeiro - OAT Desenvolvimento Mobile

## Descrição do Projeto

O **App Financeiro** é uma aplicação desenvolvida em Flutter com o objetivo de auxiliar usuários no controle de receitas e despesas pessoais. O sistema permite o cadastro de usuários, autenticação, registro de transações financeiras e análise dos dados cadastrados.

O projeto foi desenvolvido como parte da disciplina **Desenvolvimento Mobile (OAT)**, utilizando boas práticas de organização de código, arquitetura baseada em ViewModels e gerenciamento de estado com Riverpod.

## Funcionalidades

### Autenticação

* Cadastro de usuários
* Login com e-mail e senha
* Validação de credenciais

### Controle Financeiro

* Cadastro de receitas
* Cadastro de despesas
* Edição de transações
* Exclusão de transações
* Listagem das movimentações financeiras

### Análises

* Cálculo de saldo total
* Resumo de receitas
* Resumo de despesas
* Indicadores financeiros

## Tecnologias Utilizadas

* Flutter
* Dart
* Riverpod
* Material Design 3

## Estrutura do Projeto

```text
lib/
├── main.dart
├── models/
│   ├── user_model.dart
│   └── transaction_model.dart
├── providers/
│   └── app_providers.dart
├── services/
│   └── database_service.dart
├── viewmodels/
│   ├── auth_viewmodel.dart
│   └── finance_viewmodel.dart
└── views/
    ├── auth_view.dart
    ├── dashboard_view.dart
    ├── analysis_view.dart
    └── transaction_form_sheet.dart
```

## Arquitetura

O projeto segue uma organização inspirada no padrão MVVM (Model-View-ViewModel):

### Models

Responsáveis pela representação dos dados da aplicação.

### Views

Responsáveis pela interface gráfica e interação com o usuário.

### ViewModels

Responsáveis pelas regras de negócio e gerenciamento do estado.

### Services

Responsáveis pelo acesso e manipulação dos dados.

## Como Executar no GitHub Codespaces

### 1. Abrir o projeto

Acesse o repositório no GitHub e selecione:

```text
Code → Codespaces → Create Codespace on main
```

Aguarde o ambiente ser carregado.

### 2. Instalar dependências

Abra o terminal e execute:

```bash
flutter pub get
```

### 3. Gerar a versão Web

No ambiente do Codespaces, o comando:

```bash
flutter run -d web-server
```

pode apresentar tela branca devido a limitações do ambiente de depuração do Flutter Web.

Por isso, recomenda-se utilizar o processo abaixo.

### 4. Compilar o projeto

```bash
flutter build web
```

Ao final deverá aparecer:

```text
✓ Built build/web
```

### 5. Executar servidor local

Entre na pasta gerada:

```bash
cd build/web
```

Inicie um servidor HTTP:

```bash
python3 -m http.server 8080
```

### 6. Abrir a aplicação

No painel **Ports** do Codespaces:

1. Localize a porta 8080.
2. Clique em "Open in Browser".
3. A aplicação será aberta normalmente.


e servido por um servidor HTTP simples.

## Autor

Marcelo Henrique Fernandes Maurício

## Disciplina

Desenvolvimento Mobile - OAT

## Licença

Projeto desenvolvido exclusivamente para fins acadêmicos.
