/**
 * A Model is a static representation of the objects and rules that govern the 
 * abstraction of a phenomenon's elements. It's state is altered by by applying 
 * governing rules
 */ 
public interface Model {
  
  /**
   * Update the model's state over time
   */
  public void update();
}

public interface Simulation {
  /**
   * Add time-stamped model states to simulation.
   *
   * @param t time
   * @param model 
   */
  public void add(Time t, Model m);
  
  /**
   * Get list of all time-stamp values.
   */
  public ArrayList<Time> getSteps();
  
  /**
   * Retrieve a model state for a specific time-stamp.
   *
   * @param t time
   */
  public Model getState(Time t);
}

public interface ViewModel {
  /**
   * Set the Object Model to be viewed
   *
   * @param model
   */
  public void setModel(Model model);
  
  /**
   * Render ViewModel to GUI
   */
  public void draw();
}
