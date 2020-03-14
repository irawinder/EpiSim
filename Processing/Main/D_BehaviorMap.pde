/**
 * Land Use and Place Category Maps itemized by Person Demographic
 */ 
public class BehaviorMap {
  
  // List of LandUse types categorized by whether a specific demographic considers it primary, secondary, or tertiary
  private HashMap<Demographic, HashMap<PlaceCategory, ArrayList<LandUse>>> useMap;
  
  // List of Place Elements categorized by whether a specific demographic considers it primary, secondary, or tertiary
  private HashMap<Demographic, HashMap<PlaceCategory, ArrayList<Place>>> placeMap;
  
  /**
   * Construct Empty Activity Maps
   */ 
  public BehaviorMap() {
    useMap = new HashMap<Demographic, HashMap<PlaceCategory, ArrayList<LandUse>>>();
    placeMap = new HashMap<Demographic, HashMap<PlaceCategory, ArrayList<Place>>>();
    for(Demographic d : Demographic.values()) {
      HashMap<PlaceCategory, ArrayList<LandUse>> uMap = new HashMap<PlaceCategory, ArrayList<LandUse>>();
      HashMap<PlaceCategory, ArrayList<Place>> pMap = new HashMap<PlaceCategory, ArrayList<Place>>();
      for(PlaceCategory c : PlaceCategory.values()) {
        uMap.put(c, new ArrayList<LandUse>());
        pMap.put(c, new ArrayList<Place>());
      }
      useMap.put(d, uMap);
      placeMap.put(d, pMap);
    }
  }
  
 /**
   * Set a list of uses for a specified category in a specified demographic
   *
   * @param d Demographic
   * @param c PlaceCategory
   * @param use LandUse
   */
  public void setMap(Demographic d, PlaceCategory c, LandUse use) {
    ArrayList<LandUse> placeList = this.useMap.get(d).get(c);
    if(placeList.contains(use)) {
      println(use + " already exists in map");
    } else {
      placeList.add(use);
    }
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
  public Place getRandomPlace(Person p, PlaceCategory c, double distance) {
    Demographic d = p.getDemographic();
    ArrayList<Place> randomOptions = this.getPlaces(d, c);
    Place current = (Place) p.getEnvironment();
    
    int counter = 0;
    while(counter < 100) { // Give up after 100 tries
      counter++;
      
      // Pick Random Place from Options
      int randomIndex = (int) (Math.random() * (randomOptions.size() - 1));
      Place randomPlace = randomOptions.get(randomIndex);
      
      // Calculate whether this environement is close enough to home
      Coordinate iCoord = current.getCoordinate();
      Coordinate fCoord = randomPlace.getCoordinate();
      boolean proximate = iCoord.distance(fCoord) < distance;
      
      // If close enough ...
      if(proximate) return randomPlace;
    }
    return current; // stay put if no options found
  }
}
