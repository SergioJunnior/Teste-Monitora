import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical:24),
        height: 50,
        child: StreamBuilder(
          builder: (context,snapthoste){
            return RaisedButton(
              color: Colors.green,
              disabledColor: Colors.green.withAlpha(150),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              onPressed: (){},
              child: Text(
                "Entrar",
                style: TextStyle(
                  color:Colors.white,
                  fontSize:20,
                  fontWeight: FontWeight.w600,
                ),
                ),
            );
        }),
    );
  }
}