/// Stores fixed text to display in an error snackbar, depending on the type of the error
class ErrorLabels {

  final title = "Error!!!";

  final api = "Server error";

  final minSearchLength = "Minimum 4 letters needed!!!";
  
}

class SuccessLabels {

  final updated = "Successfully updated!!!";

}

class WarningLabels {}

final tWarning = WarningLabels();

final tErr = ErrorLabels();

final tSuccess = SuccessLabels();