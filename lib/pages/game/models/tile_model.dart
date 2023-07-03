class TileModel{
  final bool hasPiece;

  TileModel(this.hasPiece);

  @override
  String toString() {
    return hasPiece.toString();
  }
}