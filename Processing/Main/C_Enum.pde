public enum LandUse {
  DWELLING, OFFICE, RETAIL, SCHOOL, PUBLIC, HOSPITAL
}

public enum PlaceCategory {
  PRIMARY, SECONDARY, TERTIARY
}

public enum Demographic {
  CHILD, ADULT, SENIOR
}

public enum Compartment {
  SUSCEPTIBLE, INCUBATING, INFECTIOUS, RECOVERED, DEAD
}

public enum Symptom {
  FEVER, COUGH, SHORTNESS_OF_BREATH, FATIGUE, MUSCLE_ACHE, DIARRHEA
}

public enum PathogenType { 
  COVID_19, COMMON_COLD
}

public enum Day { 
  MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}

public enum TimeUnit { 
  MILLISECOND, SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, YEAR;
}

public enum Phase {
  SLEEP, HOME, GO_WORK, WORK, WORK_LUNCH, LEISURE, GO_HOME
}

public enum PersonViewMode {
  DEMOGRAPHIC, COMPARTMENT
}

public enum PlaceViewMode {
  LANDUSE, DENSITY
}
