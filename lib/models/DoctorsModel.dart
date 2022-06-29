class DoctorsModel{
  String? name , img , id ,about,age,email,gender,national_id,price;
  int? reservation_count;
  Speciality? speciality;

  DoctorsModel(this.name, this.img, this.id,{this.speciality,this.reservation_count,this.about,this.age,this.email,this.gender,this.national_id,this.price});

  Map<String, dynamic> toMap(DoctorsModel doctorsModel){
    return {
      "name": doctorsModel.name,
      "img": doctorsModel.img,
      "id": doctorsModel.id,
      "about": doctorsModel.about,
      "age": doctorsModel.age,
      "email": doctorsModel.email,
      "gender": doctorsModel.gender,
      "national_id": doctorsModel.national_id,
      "reservation_count": doctorsModel.reservation_count,
      "speciality": {
        "name": doctorsModel.speciality!.name,
        "id": doctorsModel.speciality!.id
      },
    };
  }
}

class Speciality{
  String? id;
  String? name;

  Speciality(this.id, this.name);
}