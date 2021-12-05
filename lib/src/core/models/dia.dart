class Dia {

  int id;
  String nombre;
  String nombreIngles;

  Dia({
    required this.id, 
    required this.nombre,
    required this.nombreIngles
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'nombreIngles': nombreIngles
  };

  factory Dia.desdeMap(Map<String, dynamic> data) {
    return Dia(
      id: data['id'],
      nombre: data['nombre'],
      nombreIngles: data['nombreIngles'] 
    );
  }

  static List<Dia> desdeLista(List<dynamic> data) {
    List<Dia> dias = [];
    data.forEach((item) {
      dias.add(Dia.desdeMap(item));
    });
    return dias;
  }
}