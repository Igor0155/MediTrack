import 'package:flutter/material.dart';
import 'package:meditrack/screens/home/type/medicament.dart';
import 'package:meditrack/service/medicament_fire_service.dart';
import 'package:meditrack/shared/services/dio_client_medicine.dart';
import 'package:meditrack/shared/types/api_medicine_response.dart';
import 'package:meditrack/shared/types/medicines.dart';

class AddMedicamentState with ChangeNotifier {
  final MedicamentFireService _service = MedicamentFireService();
  final DioClientMedicine clientMedicine;
  bool isLoading = true;

  ApiMedicineResponse<MedicineDto>? _getMedicaments;
  ApiMedicineResponse<MedicineDto>? get getMedicaments => _getMedicaments;

  bool isMedException = false;
  String medExceptionMessage = '';

  AddMedicamentState({required this.clientMedicine});

  Future<void> loadMedicaments() async {
    try {
      isLoading = true;
      isMedException = false;
      notifyListeners();
      var response = await clientMedicine.get('/v1/medicamentos/');

      _getMedicaments = ApiMedicineResponse<MedicineDto>.fromJson(
        response.data,
        (json) => MedicineDto.fromJson(json),
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      isMedException = true;
      medExceptionMessage = "Erro ao buscar medicamentos: $e";
      notifyListeners();
    }
  }

  Future<List<MedicineDto>> searchMedicine(String medicine) async {
    try {
      var response = await clientMedicine.get('/v1/medicamentos/?search=$medicine');
      var medicines = ApiMedicineResponse<MedicineDto>.fromJson(
        response.data,
        (json) => MedicineDto.fromJson(json),
      );
      return medicines.results;
    } catch (e) {
      throw Exception("Erro ao buscar medicamentos: $e");
    }
  }

  Future<void> createMedicine(MedicamentRepositoryFire input) async {
    isLoading = true;
    isMedException = false;
    medExceptionMessage = '';
    notifyListeners();

    try {
      // Adiciona com segurança
      await _service.adicionarMedicamento(input);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      isMedException = true;
      medExceptionMessage = "Erro ao adicionar medicamento: $e";
      notifyListeners();
      rethrow;
    }
  }

  // Future<bool> createMedicine(MedicamentRepositoryFire input) async {
  //   isLoading = true;
  //   isGEDocsException = false;
  //   notifyListeners();

  //   final String url = '/api/v1/customer/fs/file/$fsFileCuid';
  //   var response = await client.patch(url, input.toJson());
  //   if (response.isSuccess) {
  //     isLoading = false;
  //     notifyListeners();
  //     return true;
  //   } else {
  //     isLoading = false;
  //     notifyListeners();
  //     throw GEDocsException(response.data['message']);
  //   }
  // }
}
