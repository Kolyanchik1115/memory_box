import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_text_styles.dart';

// class TitleAppbarHomePage extends StatelessWidget {
//   const TitleAppbarHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Text(
//             'Подборки',
//             style: AppTextStyles.white24,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: TextButton(
//               onPressed: () {},
//               child: Text(
//                 'Открыть все',
//                 style: AppTextStyles.subtitle,
//               )),
//         ),
//       ],
//     );
//   }
// }

class TitleAppBarRegistrationPage extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const TitleAppBarRegistrationPage({
    super.key,
    this.title = '',
    this.subtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title!, style: AppTextStyles.title),
        Text(
          subtitle!,
          style: AppTextStyles.subtitle,
        ),
      ],
    );
  }
}
