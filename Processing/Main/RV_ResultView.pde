/**
 * Viewer for Model Results, Graphs, and other summary info
 */
public class ResultView extends CityView {
  
  private BarGraph compartmentResults;
  private PGraphics compartmentAxes;
  
  public ResultView(CityModel model, ResultSeries outcome) {
    super(model);
    compartmentResults = new BarGraph();
    
    compartmentAxes = createGraphics(100, 100);
    this.renderAxes(compartmentAxes, compartmentResults);
  }
  
  /**
   * draw Results to screen
   */
  public void drawResults(ResultSeries outcome) {
    //image(compartmentAxes, 500, 500);
  }
  
  /**
   * Render Graph Axes and Labels
   */
  protected void renderAxes(PGraphics axes, BarGraph results) {
    int w = axes.width;
    int h = axes.height;
    int margin = 30;
    axes.beginDraw();
    axes.line(margin, 0,          margin, h - margin);
    axes.line(margin, h - margin, w,      h - margin);
    axes.endDraw();
  }
}
