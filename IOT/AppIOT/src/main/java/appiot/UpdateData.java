package appiot;

import java.util.TimerTask;

import org.json.simple.JSONObject;

import javafx.application.Platform;

public class UpdateData extends TimerTask{
	private DonneesController controller;
	private String fileDonnees;
	private JSONObject donnees;
	
	public UpdateData(DonneesController _controller, String file) {
		this.controller = _controller;
		this.fileDonnees = file;
	}
	
	@Override
	public void run() {
		
		this.donnees = GestionJSON.ouvrirJSON(this.fileDonnees);
		
		Platform.runLater(new Runnable() {
			@Override
			public void run() {
				UpdateData.this.controller.setPage(donnees);
			}
		});
		
		
		
	}
	
}