class ApiResponseModel {
  bool status;
  String message;
  dynamic data;

  ApiResponseModel({
    this.status = false,
    this.message = "",
    this.data = "",
  });
}