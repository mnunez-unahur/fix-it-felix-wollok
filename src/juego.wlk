import wollok.game.*
import ralph.*

object juego {
	var gameOver = false
	var property vidas = 3
	var property dificultad = 1

	method iniciar() {
		ralph.hacerRutina()
//		game.whenKeyPressedDo(1,{
//		 	console.println("pausa")			
//		})
		game.start()	
	}
	
	
	
}
