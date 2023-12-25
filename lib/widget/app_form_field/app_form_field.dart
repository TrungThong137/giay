import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppFormField extends StatefulWidget {
  const AppFormField(
      {super.key,
      this.hintText,
      this.labelText,
      this.validator,
      this.textEditingController,
      this.onChanged,
      this.obscureText = false,
      this.isSpace = false,
      this.keyboardType,
      this.maxLenght,
      this.maxLines,
      this.counterText,
      this.onTap,
      this.enabled = true,
      this.iconPrefix,
      this.suffixText,
      this.inputFormatters,
      this.width,
      this.suffixIcon
  });
  final Function()? onTap;
  final String? hintText;
  final String? labelText;
  final String? validator;
  final bool? enabled;
  final bool? isSpace;
  final String? suffixText;
  final bool obscureText;
  final TextEditingController? textEditingController;
  final Function(String value)? onChanged;
  final TextInputType? keyboardType;
  final int? maxLenght;
  final int? maxLines;
  final String? counterText;
  final Widget? iconPrefix;
  final List<TextInputFormatter>? inputFormatters;
  final double? width;
  final Widget? suffixIcon;
  @override
  State<AppFormField> createState() => _AppFormFieldState();
}

class _AppFormFieldState extends State<AppFormField> {
  late bool hiddenPassword;

  @override
  void initState() {
    hiddenPassword = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: widget.labelText!=null ? true: false,
            child: Text(
              widget.labelText ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ) 
            ),
          ),
          const SizedBox(height: 5,),
          Container(
            width: widget.width,
            decoration: widget.enabled!
                ? const BoxDecoration()
                : BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(20)),
                  ),
            child: TextFormField(
              inputFormatters: widget.inputFormatters,
              enabled: widget.enabled,
              style: const TextStyle(color: Colors.black87),
              maxLines: widget.maxLines ?? 1,
              maxLength: widget.maxLenght,
              keyboardType: widget.keyboardType,
              controller: widget.textEditingController,
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              obscureText: hiddenPassword,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixText: widget.suffixText ?? '',
                counterText: widget.counterText,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                hintText: widget.hintText ?? '',
                hintStyle: const TextStyle(fontSize: 15, color: Colors.black38),
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color:Colors.black, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black38,
                  ),
                ),
                suffixIcon: widget.suffixIcon ?? ((widget.obscureText)
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            hiddenPassword = !hiddenPassword;
                          });
                        },
                        child: Icon(
                          hiddenPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black38,
                        ),
                      )
                    : null),
                prefixIcon: widget.iconPrefix,
              ),
            ),
          ),
          
          const SizedBox(height: 7,),
          Text(
            textAlign: TextAlign.center,
            widget.validator ?? '',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.red
            ) 
          ),
          if (widget.isSpace ?? false)
            const SizedBox(
              height: 5,
            ),
        ],
      ),
    );
  }
}
