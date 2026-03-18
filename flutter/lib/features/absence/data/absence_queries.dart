class AbsenceQueries {

  // Get Absence Data 
  static const String createAbsenceData = r'''
    mutation createAbsenceData($prompt: String!){
      createAbsenceData(prompt: $prompt) {
	id
	time_from	
	time_to	
	type_of_absence	
      }
    }
  ''';
}

