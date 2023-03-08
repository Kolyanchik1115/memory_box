import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/blocs/auth/auth_bloc.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/utils/helpers.dart';

class NicknameWidget extends StatelessWidget {
  const NicknameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final nameFocusNode = FocusNode();
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return SizedBox(
          width: 183,
          child: TextFormField(

            style: AppTextStyles.black24,
            initialValue: checkName() ? 'Ваше имя'  : FirebaseAuth.instance.currentUser?.displayName,
            textInputAction: TextInputAction.go,
            onChanged: (value){
              context.read<AuthBloc>().add(GetUserNameEvent(userName: value));
            },
            onEditingComplete: nameFocusNode.unfocus,
            cursorColor: AppColors.black,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.black),
              ),
            ),
          ),
        );
      },
    );
  }
}
