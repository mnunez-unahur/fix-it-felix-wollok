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
 		self.quitarDelJuego()
		accion.apply()
 	}
 	
 	// permite programar que la pantalla se muestre un tiempo
 	// luego se oculte, y luego ejecute una acción
 	method mostrarPorMilisegundosYLuegoEjecutar(timeout, accion) {
 		self.agregarAlJuego()
 		
	  	game.schedule(timeout,{
			self.quitarDelJuego()
			accion.apply()
	  	})
 	}
 	
 	override method agregarAlJuego() {
 		super()
 		if(incluirScore) {
 			score.quitarDelJuego()
 			score.agregarAlJuego()
 		}
 	}
 	
}

const gameOver = new Pantalla(image="fondo/gameOver.png")

const congrats = new Pantalla(image= "fondo/techo.png",position = new Position(x=27, y=0))
