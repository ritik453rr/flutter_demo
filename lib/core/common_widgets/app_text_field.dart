import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../extension/sized_box_extension.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? title;
  final String? hintText;
  final double fontSize;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autoValidateMode;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final void Function()? onSuffixTap;
  final TextInputAction? textInputAction;

  const AppTextField({
    super.key,
    this.title,
    this.hintText,
    this.fontSize = 14,
    this.controller,
    this.isPassword = false,
    this.validator,
    this.autoValidateMode,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.textInputAction,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool showText = false;

  /// Builds the text field with a labeled container and styled decoration.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: widget.fontSize,
            ),
          ),
          8.h,
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? !showText : false,
          validator: widget.validator,
          autovalidateMode: widget.autoValidateMode,
          keyboardType: widget.keyboardType,
          style: TextStyle(
            fontSize: widget.fontSize,
          ),
          onTapOutside: (e) {
            AppConstants.hideKeyboard();
          },
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: widget.fontSize,
            ),
            prefixIcon:
                widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        showText = !showText;
                      });
                    },
                    child: Icon(
                      showText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  )
                : widget.suffixIcon == null
                    ? null
                    : GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: widget.onSuffixTap,
                        child: Icon(widget.suffixIcon)),
            enabledBorder: enabledBorder(),
            focusedBorder: focusedBorder(),
            errorBorder: errorBorder(),
            focusedErrorBorder: errorBorder(),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder enabledBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(),
    );
  }

  OutlineInputBorder focusedBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 1.5),
    );
  }

  OutlineInputBorder errorBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    );
  }
}
