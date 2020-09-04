// import 'package:flutter/material.dart';
// import 'package:redux/redux.dart';
// import 'package:flutter_redux/flutter_redux.dart';

// import 'package:lloud_mobile/routes.dart';
// import 'package:lloud_mobile/states/app_state.dart';
// import 'package:lloud_mobile/view_models/login_vm.dart';
// import 'package:lloud_mobile/views/templates/signup.dart';
// import 'package:lloud_mobile/views/components/links/signup_flow_link.dart';
// import 'package:lloud_mobile/views/components/buttons/signup_flow_btn.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, LoginViewModel>(
//       converter: (Store<AppState> store) => LoginViewModel.fromStore(store),
//       builder: (BuildContext ctx, LoginViewModel vm) => buildContent(ctx, vm),
//     );
//   }

//   Widget buildContent(BuildContext ctx, LoginViewModel vm) {
//     return SignupTemplate(
//       title: 'Login!',
//       content: <Widget>[
//         TextField(
//           controller: email,
//           decoration: InputDecoration(labelText: 'Email', filled: true),
//         ),
//         SizedBox(
//           height: 12.0,
//         ),
//         TextField(
//           controller: password,
//           decoration: InputDecoration(labelText: 'Password', filled: true),
//           obscureText: true,
//         ),
//         ButtonBar(
//           alignment: MainAxisAlignment.end,
//           children: <Widget>[
//             SignupFlowButton(
//               text: 'Log in',
//               cb: () {
//                 vm.login(email.text.trim(), password.text.trim());
//               },
//             ),
//           ],
//         ),
//       ],
//       bottom: <Widget>[
//         SignupFlowLink(route: Routes.forgot_password, text: 'Forgot password?'),
//         Text(
//           '·',
//           textAlign: TextAlign.end,
//         ),
//         SignupFlowLink(route: Routes.signup_email, text: 'Sign up for Lloud'),
//       ],
//     );
//   }
// }
