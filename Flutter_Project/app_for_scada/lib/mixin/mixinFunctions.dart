import 'package:flutter/material.dart';
mixin functionMixin {
  FormFieldValidator<String> requiredFieldValidator(String message) {
    return (value) {
      if (value == null || value.isEmpty) {
        return message;
      }
      return null;
    };
  }
}