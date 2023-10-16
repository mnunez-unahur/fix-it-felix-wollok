import wollok.game.*
import personaje.*
import animacion.*
import ralph.*

class Ventana inherits Visual{
	var salud = 0
	
	const  animacion = new Animacion(	velocidad=0,
  										fotogramas=["ventana/1/rota-2.png", "ventana/1/rota-1.png", "ventana/1/sana.png"]
  								)	

	override method image() = animacion.image()
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
	method caer() {
		self.moverAPosicionyHacerAccion(self.coordenadaActualX(), 0, {
			self.ocultar()
			self.detenerMovimiento()
		})
		
	}
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

	// indica si ese objeto provoca daño cuando colisiona con felix
	const property haceDanio = false
	
	method image()
	method mostrar(){
		if(!game.hasVisual(self)) {
			game.addVisual(self)
		}
	}
	method ocultar(){
		if(game.hasVisual(self)) {
			game.removeVisual(self)		
		}
	}
	
}
object gameOver inherits Visual(position= new Position(x= 0, y = 0)) {
	override method image() = "fondo/gameOver.png"
	
}

class Nube inherits PersonajeInanimado(image = "varios/nube.png", velocidad=15) {
	method mover() {
		if(self.coordenadaActualX() < 0) {
			self.moverAPosicionyHacerAccion(110, self.coordenadaActualY(), {self.mover()})
		} else {
			self.moverAPosicionyHacerAccion(-15, self.coordenadaActualY(), {self.mover()})
		}
	}
}

// el sensor es un objeto asociado a felix para detectar colisiónes 
class Sensor inherits Visual {
	
	//TODO eliminar imagen antes de version final
	override method image() = "punto-referencia.png"
}

class Obstaculo inherits Visual {
	const izquierda = false
	const derecha = false
	const abajo = false
	const arriba = false
}

class Postigo inherits Obstaculo(derecha=true, izquierda=true) {
	override method image() = "ventana/postigos.png"
}

class Maceta inherits Obstaculo(abajo=true) {
	override method image() = "ventana/macetas.png"
}













