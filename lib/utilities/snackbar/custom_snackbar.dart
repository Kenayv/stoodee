import 'package:flutter/material.dart';


class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({
    Key? key,
    required this.errorText,

  }):super(key:key);
  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[


        Container(
            padding: const EdgeInsets.all(16),
            height:90,
            decoration: const BoxDecoration(
                color: Color(0xFFC72C41),
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text("Whoops..", style: TextStyle(fontSize:18,color:Colors.white)),
                        Text(errorText, style: TextStyle(color:Colors.white,fontSize:12),maxLines: 2,overflow: TextOverflow.ellipsis,),


                      ]
                  ),
                ),
              ],
            )

        )
        ]
    );
  }
}