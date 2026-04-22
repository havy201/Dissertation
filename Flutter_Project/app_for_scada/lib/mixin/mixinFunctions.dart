import 'package:flutter/material.dart';

mixin particularFunctionMixin {
  FormFieldValidator<String> mesIFieldValidator(String message) {
    return (value) {
      if (value == null || value.isEmpty) {
        return message;
      }
      return null;
    };
  }

  FormFieldValidator<String> mesNumberValidator(String message) {
    return (value) {
      if (value == null || value.isEmpty) {
        return message;
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return 'Chỉ được nhập số';
      }
      return null;
    };
  }

  FormFieldValidator<T> mesDropdownValidation<T>(String message) {
    return (value) {
      if (value == null) {
        return message;
      }
      return null;
    };
  }
}

