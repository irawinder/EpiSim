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

public interface ViewModel {
  
  /**
   * Render ViewModel to GUI
   */
  public void draw(Model model);
}
