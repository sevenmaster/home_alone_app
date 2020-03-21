import 'package:flutter/material.dart';
import 'package:home_alone/dependency_injection/locator.dart';
import 'package:home_alone/store/registration_store.dart';
import 'package:home_alone/view/widgets/themed_button.dart';
import 'package:home_alone/viewmodel/registration_model.dart';

class SetUsername extends StatelessWidget {
  final RegistrationModel model;

  const SetUsername({this.model});

  @override
  Widget build(BuildContext context) {
    final store = locator.get<RegistrationStore>();
    return Center(
      child: Container(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildGreetingText(context),
            _buildUserNameTextField(),
            Expanded(child: Container()),
            _buildApplyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingText(BuildContext context) => Text(
        "Super dich an Board zu haben!",
        style: Theme.of(context).textTheme.display1,
      );

  _buildUserNameTextField() {
    final store = locator.get<RegistrationStore>();
    return TextField(
      decoration: InputDecoration(labelText: "Lege einen Benutzername fest:"),
      controller: store.userNameController,
      onChanged: (t) => store.registrationModel.username = t,
    );
  }

  Widget _buildApplyButton() => ThemedButton(
        onPressed: model.usernameIsValid
            ? locator.get<RegistrationStore>().goToNextStep
            : null,
        child: Text("Übernehmen und weiter"),
      );
}