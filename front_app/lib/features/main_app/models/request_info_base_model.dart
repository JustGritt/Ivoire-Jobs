class RequestInfoBaseModel<T> {
  bool isLoading;
  T? data = null;
  String? error = null;

  RequestInfoBaseModel({this.isLoading = false, this.data, this.error});
}
