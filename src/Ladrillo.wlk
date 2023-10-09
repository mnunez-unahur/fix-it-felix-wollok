import wollok.game.*
import personaje.*
import animacion.*
import ralph.*

class Ladrillo {
	var posicion
	
	method image() = "ladrillo.png"
	method position() = posicion
	

	method desplazarse(){
		//agregar la colision game.onCollideDo(self,{algo => algo.teChocoElLadrillo()})
		game.onTick(250,"ladrillo",{self.moverseAbajo()})
		
	}
	method moverseAbajo(){
		posicion = posicion.down(1)
		if(posicion.y() == 0 ){
			game.removeTickEvent("ladrillo")
			game.removeVisual(self)
		}
	}
	
}
											
	


