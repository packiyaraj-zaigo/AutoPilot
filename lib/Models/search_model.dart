class SearchModel {
  String searchResultTitle;
  String searchResultBody;
  int searchResultId;
  String searchResultType;

  SearchModel({
    required this.searchResultTitle,
    required this.searchResultBody,
    required this.searchResultId,
    required this.searchResultType,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        searchResultTitle: json["search_result_title"],
        searchResultBody: json["search_result_body"],
        searchResultId: json["search_result_id"],
        searchResultType: json["search_result_type"],
      );
}
