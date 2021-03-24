class PetType {
  String petTypeId;
  String petTypeName;

  PetType(type){
    this.petTypeId = type['petTypeId'];
    this.petTypeName = type['petTypeName'];
  }
}