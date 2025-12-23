import 'package:flutter/material.dart';

class FormCreateWidgets extends StatelessWidget {
  final String text;
  const FormCreateWidgets(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }
}

class ModernInput extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final TextInputType keyboard;

  const ModernInput({
    super.key,
    required this.hint,
    this.controller,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}

class ModernDropdown extends StatelessWidget {
  final String? value;
  final Function(String?) onChanged;

  const ModernDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: const Text("Pilih Unit"),
          items: const [
            DropdownMenuItem(value: "Pcs", child: Text("Pcs")),
            DropdownMenuItem(value: "Kg", child: Text("Kg")),
            DropdownMenuItem(value: "Dus", child: Text("Dus")),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  const DatePickerField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: "Pilih tanggal...",
        filled: true,
        fillColor: Colors.grey.shade100,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              controller.text =
                  "${picked.day}-${picked.month}-${picked.year}";
            }
          },
        ),
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}

class DescriptionBox extends StatelessWidget {
  const DescriptionBox({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 4,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}

class UploadBox extends StatelessWidget {
  final VoidCallback onTap;
  const UploadBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 40, color: Colors.grey.shade600),
            const SizedBox(height: 6),
            Text("Upload Photo",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
