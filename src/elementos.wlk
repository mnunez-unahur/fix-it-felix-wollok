import wollok.game.*
import personaje.*
import animacion.*
import ralph.*
import pantalla.*


// Representa una ventana del tablero
// Nota: si bien es un objeto estático, no se Hereda de Estatico porque Estático requiere una imagen
class Ventana inherits Visual{
	var salud = 0
	const modelo = 1
	
	const  animacion = new Animacion(	velocidad=0,
  										fotogramas=["ventana/"+ modelo +"/rota-2.png", 
  													"ventana/" + modelo +"/rota-1.png", 
  													"ventana/"+ modelo +"/sana.png"]
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

class Ladrillo inherits Inanimado (image= "ladrillo.png") {
	method caer() {
		self.moverAPosicionyHacerAccion(self.coordenadaActualX(), 0, {
			self.removeVisual()
			self.detenerMovimiento()
		})
		
	}
}
											



class Edificio inherits Estatico(position = new Position(x=27, y=0)) {
}


// representa una nube que pasa por el fondo de la pantalla
class Nube inherits Inanimado(image = "varios/nube.png", velocidad=15) {
	method mover() {
		if(self.coordenadaActualX() < 0) {
			self.moverAPosicionyHacerAccion(110, self.coordenadaActualY(), {self.mover()})
		} else {
			self.moverAPosicionyHacerAccion(-15, self.coordenadaActualY(), {self.mover()})
		}
	}
}

// el sensor es un objeto asociado a felix para detectar colisiónes 
class Sensor inherits Caracter {
	// activa el sensor 
	method activarDeteccion(accion) {
		game.whenCollideDo(self, accion)		
	}
	
	method image() = "punto-referencia.png"
	
}

// representa un obstaculo para la celda actual del tablero
// un obstaculo puede impedir el paso a cualquiera de los lados
class Obstaculo inherits Estatico {
	const izquierda = false
	const derecha = false
	const abajo = false
	const arriba = false
	
	method izquierda() =izquierda
	method derecha() =derecha
	method abajo() =abajo
	method arriba() =arriba
}

// Representa un obstaculo para movimiento horizontal
class Postigo inherits Obstaculo(derecha=true, izquierda=true, image="ventana/postigos.png") {
}

// Representa un obstaculo para movimientos verticales
class Maceta inherits Obstaculo(abajo=true, image= "ventana/macetas.png") {
}

class Sonido{
	
	const property sound
	
	method reproducir(){
		game.sound(sound).play()
	}
	method detener(){
		game.sound(sound).stop()
	}
	
	
}
// Sonidos
object sonidoInicial inherits Sonido(sound = "Sonidos/juego.mp3" ){
}
object sonidoSalto inherits Sonido (sound = "Sonidos/salto.mp3"){
}
object arreglar inherits Sonido (sound = "Sonidos/repararVentana.mp3"){
}
object golpe inherits Sonido (sound = "Sonidos/ralphGolpe.mp3"){	
}
object restarVida inherits Sonido (sound = "Sonidos/perderVida2.mp3"){	
}
object sgameOver inherits Sonido (sound = "Sonidos/sinVidas.mp3"){
}
object sonidoStage inherits Sonido (sound = "Sonidos/juego2.mp3"){
}
object sonidoFinal inherits Sonido (sound = "Sonidos/winGame.mp3"){
}






