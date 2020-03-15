public enum LandUse {
  DWELLING, 
  OFFICE, 
  RETAIL, 
  SCHOOL, 
  PUBLIC, 
  HOSPITAL
}

public enum PlaceCategory {
  PRIMARY, 
  SECONDARY, 
  TERTIARY
}

public enum Demographic {
  CHILD, 
  ADULT, 
  SENIOR
}

public enum Compartment {
  SUSCEPTIBLE, 
  INCUBATING, 
  INFECTIOUS, 
  RECOVERED, 
  DEAD
}

public enum Symptom {
  FEVER, 
  COUGH, 
  SHORTNESS_OF_BREATH, 
  FATIGUE, 
  MUSCLE_ACHE, 
  DIARRHEA
}

public enum PathogenType { 
  COVID_19, 
  COMMON_COLD
}

public enum Day { 
  MONDAY, 
  TUESDAY, 
  WEDNESDAY, 
  THURSDAY, 
  FRIDAY, 
  SATURDAY, 
  SUNDAY
}

public enum TimeUnit { 
  MILLISECOND, 
  SECOND, 
  MINUTE, 
  HOUR, 
  DAY, 
  WEEK, 
  MONTH, 
  YEAR;
}

public enum Phase {
  SLEEP, 
  HOME, 
  GO_WORK, 
  WORK, 
  WORK_LUNCH, 
  LEISURE, 
  GO_HOME
}

public enum PersonMode {
  DEMOGRAPHIC, 
  COMPARTMENT
}

public enum PlaceMode {
  LANDUSE, 
  DENSITY
}

public enum ViewParameter {
  SHOW_PERSONS,
  SHOW_COMMUTES,
  SHOW_PLACES,
  SHOW_AGENTS,
  TEXT_HEIGHT, 
  TEXT_FILL, 
  PLACE_SCALE,
  PLACE_STROKE, 
  AGENT_DIAMETER, 
  AGENT_WEIGHT, 
  AGENT_ALPHA,
  PERSON_DIAMETER, 
  PERSON_STROKE, 
  COMMUTE_STROKE,
  COMMUTE_WEIGHT,
  REDUCED_ALPHA
}
