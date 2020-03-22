/**
 * Configure an Epidemiological Model in a City
 *
 * (Edit/modify the initial city model and epidemic state from here!)
 */
private void configModel() {
  
  // Time = 0
  epidemic.setCurrentTime(new Time(0, TimeUnit.DAY));
  
  // Time Step
  epidemic.setTimeStep(new Time(1, TimeUnit.HOUR));
  
  // How often to record a model state to graph
  epidemic.setResultStep(new Time(3, TimeUnit.HOUR));
  
  // Configure Broad City Schedule that describes general population activity
  Schedule nineToFive = new Schedule();
  
      nineToFive.addPhase(Phase.SLEEP,           new Time( 6, TimeUnit.HOUR)); // 00:00 - 06:00  (Sunday)
      nineToFive.addPhase(Phase.HOME,            new Time(16, TimeUnit.HOUR)); // 06:00 - 22:00
      nineToFive.addPhase(Phase.SLEEP,           new Time( 2, TimeUnit.HOUR)); // 22:00 - 24:00
      for(int i=0; i<5; i++) {
        nineToFive.addPhase(Phase.SLEEP,         new Time( 6, TimeUnit.HOUR)); // 00:00 - 06:00  (Monday - Friday
        nineToFive.addPhase(Phase.HOME,          new Time( 1, TimeUnit.HOUR)); // 06:00 - 07:00
        nineToFive.addPhase(Phase.GO_WORK,       new Time( 2, TimeUnit.HOUR)); // 07:00 - 09:00
        nineToFive.addPhase(Phase.WORK,          new Time( 3, TimeUnit.HOUR)); // 09:00 - 12:00
        nineToFive.addPhase(Phase.WORK_LUNCH,    new Time( 1, TimeUnit.HOUR)); // 12:00 - 13:00
        nineToFive.addPhase(Phase.WORK,          new Time( 4, TimeUnit.HOUR)); // 13:00 - 17:00
        nineToFive.addPhase(Phase.GO_HOME,       new Time( 2, TimeUnit.HOUR)); // 17:00 - 19:00
        nineToFive.addPhase(Phase.LEISURE,       new Time( 3, TimeUnit.HOUR)); // 19:00 - 22:00
        nineToFive.addPhase(Phase.SLEEP,         new Time( 2, TimeUnit.HOUR)); // 22:00 - 24:00
      }
      nineToFive.addPhase(Phase.SLEEP,           new Time( 6, TimeUnit.HOUR)); // 00:00 - 06:00  (Saturday)
      nineToFive.addPhase(Phase.LEISURE,         new Time(16, TimeUnit.HOUR)); // 06:00 - 22:00
      nineToFive.addPhase(Phase.SLEEP,           new Time( 2, TimeUnit.HOUR)); // 22:00 - 24:00
  
  epidemic.setSchedule(nineToFive);
  
  // Configure demographic-based probabalistic behaviors that determine how individuals react from moment to moment/
  // In other words, ChoiceModel describes how much people tend to deviate from a City's Schedule.
  ChoiceModel behavior = new ChoiceModel();
  
      // Phase Domains for each Phase (A person's dominant domain state during a specified phase)
      behavior.setPhaseDomain(Phase.SLEEP,       PlaceCategory.PRIMARY);   // e.g. home
      behavior.setPhaseDomain(Phase.HOME,        PlaceCategory.PRIMARY);   // e.g. home
      behavior.setPhaseDomain(Phase.GO_WORK,     PlaceCategory.SECONDARY); // e.g. work or school
      behavior.setPhaseDomain(Phase.WORK,        PlaceCategory.SECONDARY); // e.g. work or school
      behavior.setPhaseDomain(Phase.WORK_LUNCH,  PlaceCategory.SECONDARY); // e.g. work or school
      behavior.setPhaseDomain(Phase.GO_HOME,     PlaceCategory.PRIMARY);   // e.g. home
      behavior.setPhaseDomain(Phase.LEISURE,     PlaceCategory.PRIMARY);   // e.g. home
      
      //Set Behavior Anomoly Rates
      behavior.setAnomolyUnit(TimeUnit.HOUR); // anomoly rate per hour
      
      //Chance that person will shift state from primary OR secondary state TO a tertiary state
      behavior.setPhaseAnomoly(Phase.SLEEP,      new Rate(0.01));
      behavior.setPhaseAnomoly(Phase.HOME,       new Rate(0.20));
      behavior.setPhaseAnomoly(Phase.GO_WORK,    new Rate(0.00));
      behavior.setPhaseAnomoly(Phase.WORK,       new Rate(0.10));
      behavior.setPhaseAnomoly(Phase.WORK_LUNCH, new Rate(0.90));
      behavior.setPhaseAnomoly(Phase.GO_HOME,    new Rate(0.00));
      behavior.setPhaseAnomoly(Phase.LEISURE,    new Rate(0.30));
      
      // Chance that Person will recover FROM a tertiary anomoly and return to their primary OR secondary state
      behavior.setRecoverAnomoly(new Rate(0.40));
      
      // Land Use Proclivities (Demographic, Travel Category, Land Use, Max Distance Willing to Travel)
      double BASE_DIST = 150; // base maximum distance that one is willing to travel to a land use
      
      //--- Valid Children Locations
      behavior.setMap(Demographic.CHILD,  PlaceCategory.PRIMARY,   LandUse.DWELLING,   BASE_DIST*100);
      behavior.setMap(Demographic.CHILD,  PlaceCategory.SECONDARY, LandUse.SCHOOL,     BASE_DIST*1.0);
      behavior.setMap(Demographic.CHILD,  PlaceCategory.TERTIARY,  LandUse.PUBLIC,     BASE_DIST*1.0);
      behavior.setMap(Demographic.CHILD,  PlaceCategory.TERTIARY,  LandUse.RETAIL,     BASE_DIST*1.0);
      
      //--- Valid Adult Locations
      behavior.setMap(Demographic.ADULT,  PlaceCategory.PRIMARY,   LandUse.DWELLING,   BASE_DIST*100);
      behavior.setMap(Demographic.ADULT,  PlaceCategory.SECONDARY, LandUse.OFFICE,     BASE_DIST*1.0);
      behavior.setMap(Demographic.ADULT,  PlaceCategory.SECONDARY, LandUse.SCHOOL,     BASE_DIST*1.0);
      behavior.setMap(Demographic.ADULT,  PlaceCategory.SECONDARY, LandUse.HOSPITAL,   BASE_DIST*1.0);
      behavior.setMap(Demographic.ADULT,  PlaceCategory.SECONDARY, LandUse.RETAIL,     BASE_DIST*1.0);
      behavior.setMap(Demographic.ADULT,  PlaceCategory.TERTIARY,  LandUse.PUBLIC,     BASE_DIST*1.0);
      behavior.setMap(Demographic.ADULT,  PlaceCategory.TERTIARY,  LandUse.RETAIL,     BASE_DIST*1.0);
      
      //--- Valid Senior Locations
      behavior.setMap(Demographic.SENIOR, PlaceCategory.PRIMARY,   LandUse.DWELLING,   BASE_DIST*100);
      behavior.setMap(Demographic.SENIOR, PlaceCategory.SECONDARY, LandUse.DWELLING,   BASE_DIST*1.0);
      behavior.setMap(Demographic.SENIOR, PlaceCategory.TERTIARY,  LandUse.PUBLIC,     BASE_DIST*1.0);
      behavior.setMap(Demographic.SENIOR, PlaceCategory.TERTIARY,  LandUse.RETAIL,     BASE_DIST*1.0);
      behavior.setMap(Demographic.SENIOR, PlaceCategory.TERTIARY,  LandUse.HOSPITAL,   BASE_DIST*1.0);
  
  epidemic.setBehavior(behavior);

  // Add randomly placed Places to Model within a specified rectangle (centerX, centerY, rangeX, rangeY)
  // Parameters (amount, name_prefix, type, x1, y1, x2, y2, minSize, maxSize)
  int N          = 1;
  int CENTER_X   = 500;
  int CENTER_Y   = 500;
  int BASE_RANGE = 100;
  epidemic.randomPlaces(N*25,       "Public Space",    LandUse.PUBLIC,    CENTER_X, CENTER_Y, 5*BASE_RANGE, 5*BASE_RANGE, 500,  2000);
  epidemic.randomPlaces(N*250,      "Dwelling Unit",   LandUse.DWELLING,  CENTER_X, CENTER_Y, 5*BASE_RANGE, 5*BASE_RANGE, 50,   200);
  epidemic.randomPlaces(N*20,       "Office Space",    LandUse.OFFICE,    CENTER_X, CENTER_Y, 4*BASE_RANGE, 4*BASE_RANGE, 500,  1000);
  epidemic.randomPlaces(N*4,        "School",          LandUse.SCHOOL,    CENTER_X, CENTER_Y, 5*BASE_RANGE, 5*BASE_RANGE, 500,  2000);
  epidemic.randomPlaces(N*25,       "Retail Shopping", LandUse.RETAIL,    CENTER_X, CENTER_Y, 4*BASE_RANGE, 4*BASE_RANGE, 50,   1000);
  epidemic.randomPlaces(N*1,        "Hospital",        LandUse.HOSPITAL,  CENTER_X, CENTER_Y, 1*BASE_RANGE, 1*BASE_RANGE, 2000, 2000);
  
  // Resilience*: Impact of Demographic on Pathogen Intensities (1.0 == no impact; < 1 == less resilient; > 1 == more resilient)
  Rate childResilience  = new Rate(1.5);
  Rate adultResilience  = new Rate(1.0);
  Rate seniorResilience = new Rate(0.5);
  
  // Population Attributes
  int adultAge        = 18;
  int seniorAge       = 65;
  int minAge          = 5;
  int maxAge          = 85;
  int minDwellingSize = 1;
  int maxDwellingSize = 4;
  
  // Add people to Model assigned to one random primary location (home) and one random secondary location (job or school)
  epidemic.populate(minAge, maxAge, adultAge, seniorAge, childResilience, adultResilience, seniorResilience, minDwellingSize, maxDwellingSize);
  
  // Number of Ventilator ICU Beds Per Capita:
  // In actuality, this rate is only about 0.04% in the United States according to NYTimes!!!
  // https://www.nytimes.com/2020/03/18/business/coronavirus-ventilator-shortage.html
  Rate bedsPerCapita = new Rate(0.004);
  epidemic.setBedsPerCapita(bedsPerCapita);
  
  // Configure Covid Pathogen
  Pathogen covid19 = new Pathogen();
  configureCoronavirus(covid19, "Covid-2019");
  
  // Configure Cold Pathogen
  Pathogen coldA = new Pathogen();
  configureRhinovirus(coldA, "Common Cold");
  
  // Configure Covid Pathogen
  Pathogen coldB = new Pathogen();
  configureRhinovirus(coldB, "Common Cold (Type B)");
  
  // Configure Cold Pathogen
  Pathogen flu = new Pathogen();
  configureInfluenza(flu, "Flu-2019");
  
  // Deploy Pathogens as Agents into the Host (Person) Population
  // Parameters: pathogen, initial host count
  epidemic.patientZero(covid19, 4);
  epidemic.patientZero(coldA,   20);
  //epidemic.patientZero(coldB, 1);
  //epidemic.patientZero(flu,   4);
}

/**
 * Configure a pathogen to have COVID-19 attributes
 *
 * @param covid pathogen to configure
 */
void configureCoronavirus(Pathogen p, String name) {
  
  // Attributes
  p.setName(name);
  p.setType(PathogenType.CORONAVIRUS);
  p.setAttackRate(new Rate(0.5));
  
  // Length of time that pathogen can survice outside of host via Agent
  Time agentLife = new Time(24, TimeUnit.HOUR);
  p.setAgentLife(agentLife);
  
  // Host Pathogen Manifestations
  Time incubationMean              = new Time(  6, TimeUnit.DAY);
  Time incubationStandardDeviation = new Time(  3, TimeUnit.DAY);
  Time infectiousMean              = new Time( 14, TimeUnit.DAY);
  Time infectiousStandardDeviation = new Time(1.5, TimeUnit.DAY);
  p.setIncubationDistribution(incubationMean, incubationStandardDeviation);
  p.setInfectiousDistribution(infectiousMean, infectiousStandardDeviation);
  
  // Mortality Rates and Hospitalization
  p.setMortalityTreated(new Rate(0.01));    // Smallest
  p.setMortalityUntreated(new Rate(0.05)); 
  p.setHospitalizationRate(new Rate(0.08)); // Largest
  
  // Adult's rate of expression symptoms
  p.setSymptomExpression(Symptom.FEVER,               new Rate(0.50));
  p.setSymptomExpression(Symptom.COUGH,               new Rate(0.50));
  p.setSymptomExpression(Symptom.SHORTNESS_OF_BREATH, new Rate(0.25));
  p.setSymptomExpression(Symptom.FATIGUE,             new Rate(0.05));
  p.setSymptomExpression(Symptom.MUSCLE_ACHE,         new Rate(0.05));
  p.setSymptomExpression(Symptom.DIARRHEA,            new Rate(0.05));
}

/**
 * Configure a pathogen to have Common Cold attributes
 *
 * @param cold pathogen to configure
 */
public void configureRhinovirus(Pathogen p, String name) {
  
  // Attributes
  p.setName(name);
  p.setType(PathogenType.RHINOVIRUS);
  p.setAttackRate(new Rate(0.4));
  
  // Length of time that pathogen can survice outside of host via Agent
  Time agentLife = new Time(8, TimeUnit.HOUR);
  p.setAgentLife(agentLife);
  
  // Host Pathogen Manifestations
  Time incubationMean              = new Time(  2, TimeUnit.DAY);
  Time incubationStandardDeviation = new Time(0.5, TimeUnit.DAY);
  Time infectiousMean              = new Time(  7, TimeUnit.DAY);
  Time infectiousStandardDeviation = new Time(1.5, TimeUnit.DAY);
  p.setIncubationDistribution(incubationMean, incubationStandardDeviation);
  p.setInfectiousDistribution(infectiousMean, infectiousStandardDeviation);
  
  // Mortality Rates and Hospitalization
  p.setMortalityTreated(new Rate(0.0));      // Smallest
  p.setMortalityUntreated(new Rate(0.001));
  p.setHospitalizationRate(new Rate(0.002)); // Largest 
  
  // Child's rate of expression symptoms
  p.setSymptomExpression(Symptom.COUGH,  new Rate(0.50));
}

/**
 * Configure a pathogen to have Common Cold attributes
 *
 * @param cold pathogen to configure
 */
public void configureInfluenza(Pathogen p, String name) {
  
  // Attributes
  p.setName(name);
  p.setType(PathogenType.INFLUENZA);
  p.setAttackRate(new Rate(0.5));
  
  // Length of time that pathogen can survice outside of host via Agent
  Time agentLife = new Time(8, TimeUnit.HOUR);
  p.setAgentLife(agentLife);
  
  // Host Pathogen Manifestations
  Time incubationMean              = new Time(  2, TimeUnit.DAY);
  Time incubationStandardDeviation = new Time(  1, TimeUnit.DAY);
  Time infectiousMean              = new Time(  7, TimeUnit.DAY);
  Time infectiousStandardDeviation = new Time(  2, TimeUnit.DAY);
  p.setIncubationDistribution(incubationMean, incubationStandardDeviation);
  p.setInfectiousDistribution(infectiousMean, infectiousStandardDeviation);
  
  // Mortality Rates and Hospitalization
  p.setMortalityTreated(new Rate(0.0));      // smallest
  p.setMortalityUntreated(new Rate(0.001));
  p.setHospitalizationRate(new Rate(0.005)); // largest
  
  // Child's rate of expression symptoms
  p.setSymptomExpression(Symptom.FEVER,               new Rate(0.50));
  p.setSymptomExpression(Symptom.COUGH,               new Rate(0.50));
  p.setSymptomExpression(Symptom.DIARRHEA,            new Rate(0.50));
  p.setSymptomExpression(Symptom.FATIGUE,             new Rate(0.05));
  p.setSymptomExpression(Symptom.MUSCLE_ACHE,         new Rate(0.05));
  p.setSymptomExpression(Symptom.DIARRHEA,            new Rate(0.05));
}
