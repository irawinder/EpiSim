import java.util.Random;

/**
 * Collection of Mappings and Probabilities that inform a Person's choice of location over specified duration of time
 */ 
public class ChoiceModel {
  
  // List of Place Elements categorized by whether a specific demographic considers it primary, secondary, or tertiary
  private HashMap<Demographic, HashMap<PlaceCategory, ArrayList<Place>>> placeMap;
  
  // List of LandUse types categorized by whether a specific demographic considers it primary, secondary, or tertiary
  private HashMap<Demographic, HashMap<PlaceCategory, ArrayList<LandUse>>> useMap;
  
  // Maximum Travel Distances categorized by whether a specific demographic considers a given land use primary, secondary, or tertiary
  private HashMap<Demographic, HashMap<PlaceCategory, HashMap<LandUse, Double>>> distanceMap;
  
  // Dominant place category for each phase
  private HashMap<Phase, PlaceCategory> phaseDomain;
  
  // Chance that person will waver from their primary or secondary state
  private HashMap<Phase, Rate> phaseAnomoly;
  
  // Chance that person will return to primary or secondary state if pursuing a dalliance
  private Rate recoverAnomoly;
  
  // Anomoly Rate Unit (e.g. unit of TimeUnit.HOUR corresponds to [probability rate PER Hour])
  private TimeUnit anomolyUnit;
  
  /**
   * Construct Empty Behavior Maps
   */ 
  public ChoiceModel() {
    this.useMap = new HashMap<Demographic, HashMap<PlaceCategory, ArrayList<LandUse>>>();
    this.placeMap = new HashMap<Demographic, HashMap<PlaceCategory, ArrayList<Place>>>();
    this.distanceMap = new HashMap<Demographic, HashMap<PlaceCategory, HashMap<LandUse, Double>>>();
    for(Demographic d : Demographic.values()) {
      HashMap<PlaceCategory, ArrayList<LandUse>> uMap = new HashMap<PlaceCategory, ArrayList<LandUse>>();
      HashMap<PlaceCategory, ArrayList<Place>> pMap = new HashMap<PlaceCategory, ArrayList<Place>>();
      HashMap<PlaceCategory, HashMap<LandUse, Double>> dMap = new HashMap<PlaceCategory, HashMap<LandUse, Double>>();
      for(PlaceCategory c : PlaceCategory.values()) {
        uMap.put(c, new ArrayList<LandUse>());
        pMap.put(c, new ArrayList<Place>());
        dMap.put(c, new HashMap<LandUse, Double>());
      }
      this.useMap.put(d, uMap);
      this.placeMap.put(d, pMap);
      this.distanceMap.put(d, dMap);
    }
    
    this.phaseDomain = new HashMap<Phase, PlaceCategory>();
    this.phaseAnomoly = new HashMap<Phase, Rate>();
    for(Phase phase : Phase.values()) {
      this.phaseAnomoly.put(phase, new Rate(0));
    }
    this.anomolyUnit = TimeUnit.HOUR;
  }
  
 /**
   * Set a list of uses and max travel distance for a specified category in a specified demographic
   *
   * @param d Demographic
   * @param c PlaceCategory
   * @param use LandUse
   * @param distance double
   */
  public void setMap(Demographic d, PlaceCategory c, LandUse use, double maxDistance) {
    
    // Set the LandUse Map
    ArrayList<LandUse> useList = this.useMap.get(d).get(c);
    if(useList.contains(use)) {
      println(use + " already exists in map");
    } else {
      useList.add(use);
    }
    
    //Set the Max Distance Map
    HashMap<LandUse, Double> distMap = this.distanceMap.get(d).get(c);
    distMap.put(use, maxDistance);
  }
  
  /**
   * Add a place to the Behavior Map
   *
   * @param place Place
   */
  public void addPlace(Place place) {
    LandUse placeUse = place.getUse();
    for(Demographic d : Demographic.values()) {
      for(PlaceCategory c : PlaceCategory.values()) {
        if(hasUse(d, c, placeUse)) {
          ArrayList<Place> placeList = this.placeMap.get(d).get(c);
          if(placeList.contains(place)) {
            println(place + " already exists in map");
          } else {
            placeList.add(place);
          }
        }
      }
    }
  }
  
 /**
   * Check if specified Use is valid for a specified category in a specified demographic
   *
   * @param d Demographic
   * @param c PlaceCategory
   * @param use LandUse
   *
   * @return true if use is valid activity
   */
  public boolean hasUse(Demographic d, PlaceCategory c, LandUse use) {
    ArrayList useList = useMap.get(d).get(c);
    if(useList.contains(use)) {
      return true;
    } else {
      return false;
    }
  }
  
 /**
   * Check how far person will travel to specified use if valid for a specified category in a specified demographic
   *
   * @param d Demographic
   * @param c PlaceCategory
   * @param use LandUse
   *
   * @return maximum distance person will travel
   */
  public double maxTravel(Demographic d, PlaceCategory c, LandUse use) {
    ArrayList useList = useMap.get(d).get(c);
    if(useList.contains(use)) {
      return this.distanceMap.get(d).get(c).get(use);
    } else {
      return 0;
    }
  }
  
 /**
   * Get List of Places Associated with a specific category in a specific demographic
   *
   * @param d Demographic
   * @param c PlaceCategory
   *
   * @return list of Places
   */
  public ArrayList<Place> getPlaces(Demographic d, PlaceCategory c) {
    return placeMap.get(d).get(c);
  }
  
  /**
   * Get a random Place from the behavior map within a specified distance of specified person
   *
   * @param p Person
   * @param c PlaceCategory
   * @param d Demographic
   */
  public Place getRandomPlace(Person p, PlaceCategory c) {
    Demographic d = p.getDemographic();
    ArrayList<Place> randomOptions = this.getPlaces(d, c);
    Place current = (Place) p.getEnvironment();
    
    int counter = 0;
    while(counter < 1000) { // Give up after 1000 tries
      counter++;
      
      // Pick Random Place from Options
      int randomIndex = (int) (Math.random() * (randomOptions.size() - 1));
      Place randomPlace = randomOptions.get(randomIndex);
      
      // Calculate whether this environement is close enough to home
      Coordinate iCoord = current.getCoordinate();
      Coordinate fCoord = randomPlace.getCoordinate();
      LandUse use = randomPlace.getUse();
      double maxDistance = this.distanceMap.get(d).get(c).get(use);
      boolean proximate = iCoord.distance(fCoord) < maxDistance;
      
      // If close enough ...
      if(proximate) return randomPlace;
    }
    return current; // stay put if no options found
  }
  
  /**
   * Set Chance that Person will waver from their primary or secondary state (per HOUR)
   *
   * @param p Phase
   * @param anomoly Rate
   */
  public void setPhaseAnomoly(Phase p, Rate anomoly) {
    this.phaseAnomoly.put(p, anomoly);
  }
  
  /**
   * Get Chance that Person will waver from their primary or secondary state (per HOUR)
   *
   * @param p Phase
   */
  public Rate getPhaseAnomoly(Phase p) {
    return this.phaseAnomoly.get(p);
  }
  
  /**
   * Set Chance that Person will return to primary or secondary state if pursuing a dalliance (per HOUR)
   *
   * @param p Phase
   * @param anomoly Rate
   */
  public void setRecoverAnomoly(Rate anomoly) {
    this.recoverAnomoly = anomoly;
  }
  
  /**
   * Get Chance that Person will return to primary or secondary state if pursuing a dalliance (per HOUR)
   *
   * @param p Phase
   */
  public Rate getRecoverAnomoly() {
    return this.recoverAnomoly;
  }
  
  /**
   * Set Anomoly Rate Unit (e.g. unit of TimeUnit.HOUR corresponds to [probability rate PER Hour])
   *
   * @param unit TimeUnit
   */
  public void setAnomolyUnit(TimeUnit unit) {
    this.anomolyUnit = unit;
  }
  
  /**
   * Get Anomoly Rate Unit (e.g. unit of TimeUnit.HOUR corresponds to [probability rate PER Hour])
   */
  public TimeUnit getAnomolyUnit() {
    return this.anomolyUnit;
  }
  
  /**
   * Set Domain Place Category for each Phase
   *
   * @param p Phase
   * @param c PlaceCategory
   */
  public void setPhaseDomain(Phase p, PlaceCategory c) {
    this.phaseDomain.put(p, c);
  }
  
 /**
   * Get Domain Place Category for each Phase
   *
   * @param p Phase
   */
  public PlaceCategory getPhaseDomain(Phase p) {
    return this.phaseDomain.get(p);
  }
  
  /**
   * Update Person Movement over specified period of time
   *
   * @param p Person 
   * @param currentPhase current phase in schedule
   * @param duration of time to apply probabilities
   */
  public void apply(Person p, Phase currentPhase, Time duration) {
    
    // Calculate Anomoly Rates
    Time oneUnit = new Time(1, this.getAnomolyUnit());
    Time rateUnitPerStep = duration.divide(oneUnit);
    Rate anomolyPerUnit = this.getPhaseAnomoly(currentPhase);
    Rate recoverPerUnit = this.getRecoverAnomoly();
    Rate anomolyPerStep = new Rate(rateUnitPerStep.getAmount() * anomolyPerUnit.toDouble());
    Rate recoverPerStep = new Rate(rateUnitPerStep.getAmount() * recoverPerUnit.toDouble());
      
    // Are you dead?
    if(!p.alive()) {
      p.moveToPrimary();
    
    // If you're alive, carry on!
    } else {
      // Current Place
      Place currentPlace = p.getPlace();
      
      // Dominant Place
      PlaceCategory phaseDomain = this.getPhaseDomain(currentPhase);
      Place dominantPlace = currentPlace;
      switch(phaseDomain) {
        case PRIMARY:
          dominantPlace = p.getPrimaryPlace();
          break;
        case SECONDARY:
          dominantPlace = p.getSecondaryPlace();
          break;
        case TERTIARY:
          // Do Nothing
          break;
      }
      
      // Are you at your dominant place?
      if(currentPlace == dominantPlace) {
        // Maybe wander away from domain to tertiary activity
        boolean goToAnomoly = anomolyPerStep.roll();
        if(goToAnomoly) {
          p.moveTo(this.getRandomPlace(p, PlaceCategory.TERTIARY));
        }
        
      // Are you at a tertiary place?
      } else {
        // Maybe return to domain
        boolean goToDomain = recoverPerStep.roll();
        if(goToDomain) {
          p.moveTo(dominantPlace);
        }
      }
    }
  }
}
