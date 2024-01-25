package appiot;

import java.util.TimerTask;

import org.json.simple.JSONObject;

import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

public class UpdateAlertes extends TimerTask{
	private AlertesController controller;
	private JSONObject donneesAlertes;
	private ObservableList<String> listeSalles = FXCollections.observableArrayList();
	private boolean isTemp;
	private boolean isHumidity;
	private boolean isCO2;
	
	public UpdateAlertes(AlertesController _controller, ObservableList<String> listeSalles, boolean isTemp, boolean isHumidity, boolean isCO2) {
		this.controller = _controller;
		this.listeSalles = listeSalles;
		this.isTemp = isTemp;
		this.isHumidity = isHumidity;
		this.isCO2 = isCO2;
	}
	
	@Override
	public void run() {
		
		this.donneesAlertes = GestionJSON.ouvrirJSONAlertes();
		
		Platform.runLater(new Runnable() {
			@Override
			public void run() {
				UpdateAlertes.this.controller.setPageAlertes(donneesAlertes,listeSalles,isTemp,isHumidity,isCO2);
			}
		});
	}
	
}