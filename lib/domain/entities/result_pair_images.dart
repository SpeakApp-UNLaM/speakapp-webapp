class ResultPairImages {
  int idImage;
  String nameImage;
  ResultPairImages({required this.idImage, required this.nameImage});

  void setAudio(String name) {
    nameImage = name;
  }

  void setIdImage(int idImag) {
    idImage = idImag;
  }
}
