import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:stoodee/localization/locales.dart';
import 'package:stoodee/utilities/globals.dart';

class CustomErrorSnackBar extends StatelessWidget {
  const CustomErrorSnackBar({
    super.key,
    required this.errorText,
  });
  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          padding: const EdgeInsets.all(16),

          decoration: const BoxDecoration(
              color: Color(0xFFC72C41),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(color: Colors.grey,offset: Offset(1,2.0))
              ]
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Whoops..",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      Text(
                        errorText,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
              ),
            ],
          ))
    ]);
  }
}






class CustomSuccessSnackBar extends StatelessWidget {
  const CustomSuccessSnackBar({
    super.key,
    required this.successText,
  });
  final String successText;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          padding: const EdgeInsets.all(16),

          decoration: const BoxDecoration(
              color: Color(0xFF0DB71B),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Colors.grey,offset: Offset(1,2.0))            ]
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(LocaleData.snackBarSuccess.getString(context),
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      Text(
                        successText,
                        style:
                        const TextStyle(color: Colors.white, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
              ),
            ],
          ))
    ]);
  }
}





class CustomNeutralSnackBar extends StatelessWidget {
  const CustomNeutralSnackBar({
    super.key,
    required this.neutralText,
  });
  final String neutralText;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          padding: const EdgeInsets.all(16),

          decoration: const BoxDecoration(
              color: analogusColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(color: Colors.grey,offset: Offset(1,2.0))            ]
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(LocaleData.snackBarNeutral.getString(context),
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      Text(
                        neutralText,
                        style:
                        const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ]),
              ),



            ],

          ))
    ]);
  }
}
