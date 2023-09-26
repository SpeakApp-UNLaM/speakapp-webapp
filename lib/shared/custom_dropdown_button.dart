import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdownButton extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final Function(Object?)? onChanged;
  final List<String>? options;
  final String? value;

  const CustomDropdownButton(
      {super.key,
      this.label,
      this.hint,
      this.errorMessage,
      this.onChanged,
      this.options,
      this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(40));

    const borderRadius = Radius.circular(15);

    return Container(
      // padding: const EdgeInsets.only(bottom: 0, top: 15),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: borderRadius,
              bottomLeft: borderRadius,
              bottomRight: borderRadius),
          ),
      child: DropdownButtonFormField<String>(
        items: options?.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option, style: GoogleFonts.nunito(fontSize: 16, color: Colors.black54 )),
          );
        }).toList(),
        value: value,
        onChanged: onChanged,
        style: GoogleFonts.nunito(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold ),
        decoration: InputDecoration(
          floatingLabelStyle: GoogleFonts.nunito(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w900 ),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith(
              borderSide: BorderSide(color: Colors.red.shade800)),
          focusedErrorBorder: border.copyWith(
              borderSide: BorderSide(color: Colors.red.shade800)),
          isDense: true,
          label: label != null ? Text(label!, style: GoogleFonts.nunito(fontSize: 16, color: Colors.black54 ),) : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
          // icon: Icon( Icons.supervised_user_circle_outlined, color: colors.primary, )
        ),
      ),
    );
  }
}
