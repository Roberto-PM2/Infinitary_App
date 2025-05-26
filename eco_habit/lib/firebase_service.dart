import 'package:cloud_firestore/cloud_firestore.dart';
import 'guias/model_guias.dart'; // Asegúrate de importar tu clase Guia
import 'centros/model_centros.dart';

Future<void> subirGuiasAFirebase(List<Guia> guias) async {
  final CollectionReference guiasRef = FirebaseFirestore.instance.collection('guias');

  for (var guia in guias) {
    await guiasRef.add(guia.toMap());
  }
}

Future<void> subirCentrosAFirebase(List<Centro> centros) async {
  final CollectionReference centrosRef = FirebaseFirestore.instance.collection('centros');

  for (var centro in centros) {
    await centrosRef.add(centro.toMap());
  }
}