import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:stoodee/services/auth/auth_service.dart';
import 'package:stoodee/utilities/globals.dart';
import 'package:stoodee/utilities/reusables/reusable_stoodee_button.dart';
import 'package:stoodee/utilities/dialogs/add_task_dialog.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    super.key,
  });

  @override
  State<AccountPage> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  void gotomain() {
    context.go('/');
  }


  StoodeeButton resolveWhichButton(){

    if(AuthService.firebase().currentUser == null) {
      return StoodeeButton(onPressed: (){
        context.go("/login_test");
      },
          child: Text("Log-in",style:buttonTextStyle)
      );

      }
    else {
      return StoodeeButton(onPressed: (){
        context.go("/login_test");
      },
          child: Text("Log-out",style:buttonTextStyle)
      );
    }

      }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
                height: 200,
                child:Text("image placeholder")


            ),

            Container(
                height: 200,
                child:Text("stats placeholder")


            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(width:MediaQuery.of(context).size.width*0.2),

                resolveWhichButton(),



                StoodeeButton(child:Icon(Icons.sync,color:Colors.white),onPressed: (){showAddTaskDialog(context: context);},),
              ],

            ),
            Gap(20),


          ],
        ),
      ),
    );
  }
}
