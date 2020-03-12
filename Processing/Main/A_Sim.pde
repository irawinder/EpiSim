/**
 * Simulation is an abstract collection of model states over time
 */
public class EpiSim implements Simulation {
  
  // Sequence of Discrete Instants that make up a simulation
  private ArrayList<Time> stepList;
  
  // Unique model states mapped to each time step
  private HashMap<Time, Model> stateMap;
  
  /**
   * Construct Simulation Dictionaries
   */
  public EpiSim() {
    this.stepList = new ArrayList<Time>();
    this.stateMap = new HashMap<Time, Model>();
  }
  
  /**
   * Add model state to simulation.
   *
   * @param t time
   * @param model 
   */
  public void add(Time t, Model model) {
    this.stepList.add(t);
    this.stateMap.put(t, model);
  }
  
  /**
   * Get list of all time step values.
   */
  public ArrayList<Time> getSteps() {
    return this.stepList;
  }
  
  /**
   * Retrieve a model state from a specific time.
   *
   * @param t time
   */
  public Model getState(Time t) {
    if(stateMap.containsKey(t)) {
      return stateMap.get(t);
    } else {
      println("No model state is associated with this time");
      return null;
    }
  }
}
