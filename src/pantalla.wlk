import elementos.*
import wollok.game.*
import juego.*
import personaje.*

// Una pantalla es una imagen de pantalla completa 
// utilizada como separador de stages y como pantalla de finalizació o comienzo de juego
class Pantalla inherits Visual (position = game.at(0,0)){
	var image
	const incluirScore = true
	
 	override method image() = image
 	
 	method ocultaryLuegoEjecutar(accion) {
 		self.ocultar()
		accion.apply()
 	}
 	
 	// permite programar que la pantalla se muestre un tiempo
 	// luego se oculte, y luego ejecute una acción
 	method mostrarPorMilisegundosYLuegoEjecutar(timeout, accion) {
 		self.mostrar()
 		
	  	game.schedule(timeout,{
			self.ocultar()
			accion.apply()
	  	})
 	}
 	
 	override method mostrar() {
 		super()
 		if(incluirScore) {
 			score.ocultar()
 			score.mostrar()
 		}
 	}
 	
}


