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

class Ladrillo inherits PersonajeInanimado (image= "ladrillo.png") {
	
}
											
object vida inherits Visual (position=new Position(y=55, x=80 )){ 
	var property vidasActuales = 3
	
	override method image(){
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
	
	method perderVida(){
		vidasActuales = 0.max(vidasActuales-1)
	}
	method ganarVida(){
		vidasActuales = 3.min(vidasActuales+1)
	}
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

class Visual {
	//var image
	var property position
	
	method image()
	method mostrar(){ 	game.addVisual(self) }
	method ocultar(){	game.removeVisual(self)}
	
}


