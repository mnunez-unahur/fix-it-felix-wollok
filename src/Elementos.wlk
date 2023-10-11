import wollok.game.*
import personaje.*
import animacion.*
import ralph.*

class Ventana {
	var property position
	var salud = 0
	
	const  animacion = new Animacion(	velocidad=0,
  										fotogramas=["ventana/1/rota-2.png", "ventana/1/rota-1.png", "ventana/1/sana.png"]
  								)	

	method image() = animacion.image()
	method salud() = salud
	
	method reparar() {
		salud = 2.min(salud+1)
		animacion.irAFotograma(salud)
	}
	
	method romper() {
		animacion.resetear()
		salud = 0
	}

}

class Ladrillo {
	var posicion

	
	method image() = "ladrillo.png"
	method position() = posicion
	

	method desplazarse(){
		//agregar la colision game.onCollideDo(self,{algo => algo.teChocoElLadrillo()})
		posicion = posicion.right(5)
		game.onTick(80,"ladrillo",{self.moverseAbajo()})
		
	}
	method moverseAbajo(){
		posicion = posicion.down(1)
		if(posicion.y() == 0 ){
			game.removeTickEvent("ladrillo")
			game.removeVisual(self)
		}
	}
	
}


class Vida {
	var posicion
	var property vidasActuales 
	
	method image(){
		if (vidasActuales == 3){
			return "fondo/vida3.png"
		}else if (vidasActuales ==2 ){
			return "fondo/vida2.png"
		}else if (vidasActuales ==1){
			return "fondo/vida1.png"
		}else{
			return "fondo/sin vida.png"
		}
	}
	method position() = posicion
	
	
}											
object vida inherits Vida (posicion=new Position(y=55, x=80),vidasActuales=3){ //prueba
	
}
class Score{ // ver como hacer que sume el puntaje y con que criterio
	var posicion
	var property puntajeActual 
	
	method image()="fondo/score.png"
	method position() = posicion
}

object score inherits Score (posicion=new Position(y=55, x=05),puntajeActual=0){ //prueba
								
}

class Edificio {
	const property image
	const property position = new Position(x=27, y=0)
	
}


