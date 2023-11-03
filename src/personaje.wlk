import wollok.game.*
import elementos.*

import animacion.*

class MutablePosition inherits Position {
	var mutableX = x
	var mutableY = y
	
	override method x() = mutableX
	method x(nuevaX) {
		mutableX = nuevaX
	}
	
	override method y() = mutableY
	method y(nuevaY) {
		mutableY = nuevaY
	}
	
}

class RelativePosition inherits Position {
	var property referencia
	const deltaX = 0
	const deltaY = 0
	
	override method x() {
//		console.println(referencia.x() + deltaX)
		return referencia.x() + deltaX
	}
	
	override method y() {
//		console.println(referencia.y() + deltaY)
		return referencia.y() + deltaY
	}
	
}

/*
 * un caracter es un elemento que puede ser insertado en el juego
 * un caracter no necesariamente es visible
 */
class Caracter {
	var position = new MutablePosition(x=0, y=0)
	const mutablePosition = false
	
	// indica si ese objeto provoca daño cuando colisiona con felix
	const property haceDanio = false
	
	method initialize() {
		// nos aseguramos de que la posición sea del tipo mutable
		position = new MutablePosition(x=0, y=0)
	}
	
	method position() = position
	method position(nuevaPosicion) {
		if(mutablePosition) {
			position.x(nuevaPosicion.x())
			position.y(nuevaPosicion.y())			
		} else {
			position = nuevaPosicion		
		}
	}
	
	
	method positionXY(x, y) {
		if(mutablePosition) {
			position.x(x)
			position.y(y)
		} else {
			position = new Position(x=x, y=y)
		}	
	}
	
	method addVisual(){
		if(!game.hasVisual(self)) {
			game.addVisual(self)
		}
	}
	method removeVisual(){
		if(game.hasVisual(self)) {
			game.removeVisual(self)		
		}
	}
	
}

// representa un objeto que tiene una representación
// visual en el juego
// es una clase abstracta ya que no implementa cómo se muestra el elemento 
class Visual inherits Caracter {
	
	method image()
//	method image(nuevaImagen)
	
}

// representa un objeto Visual que no puede cambiar su posición inicial
// es útil para obstaculos
class Estatico inherits Visual {
	var image
	
	override method image() = image
	
	
	override method position(nuevaPosicion) {
		self.error("este elemento no puede ser reubicado")
	}
}


// Clase Abstracta que representa un objeto que Visual que puede transladarse
// de una celda a otra, pasando por las intermedias
class Movil inherits Visual {
	
	/*
	 * indica la cantidad máxima de ticks por segundo
	 */
	const maxTiksPorSegundo = 40
	var enMovimiento = false
	
	/*
	 * velocidad en pasos por segundo
	 */
	var velocidad
	
	/*
	 * Cantidad de saltos por paso
	 */
//	var property salto = 1
	
	
	//genera un nombre único para el objeto
	// esto es utilizado por los eventos automaticos
	const nombreEventoMovimiento= "movimiento-personaje-" + 0.randomUpTo(100000)
	
	method velocidad() = velocidad
	method velocidad(nuevaVelocidad) {
		velocidad = nuevaVelocidad
	}
	
	/*
	 * establece la cantidad de ticks por segundo del movimiento
	 */
	method ticksPorSegundo() {
		return if(self.velocidad() > maxTiksPorSegundo) self.velocidad() / 2 else self.velocidad()
	}

	/*
	 * indica la cantidad de saltos por movimiento basado en la velocidad
	 */
	method salto() {
		return if(self.velocidad() > maxTiksPorSegundo) 2 else 1
	}
	
	// Mueve a la coordenada indicada y luego ejecuta una acción
	// TODO: refactorizar
	method moverAPosicionyHacerAccion(x, y,accion) {
		if(enMovimiento) {
			self.detenerMovimiento()
		}
		
		enMovimiento = true
		
		game.onTick(1000 / self.ticksPorSegundo(), nombreEventoMovimiento , {
			
			// legué a mi destino
			if(self.coordenadaActualX() == x && self.coordenadaActualY() == y) {
				self.detenerMovimiento()
				accion.apply()
			}
			else {	
				self.positionXY(
					self.coordenadaActualX() + self.deltaX(x),
					self.coordenadaActualY() + self.deltaY(y)
				)
			}
		})				
		
	}
	method moverAPosicion(x,y){
		self.moverAPosicionyHacerAccion(x,y,{})
	}
	
	
	/*
	 * establece la dirección  y la cantidad de celdas a la que debe moverse
	 * en el eje x
	 */
	method deltaX(x){
		return (x - self.coordenadaActualX()).min(1*self.salto()).max(-1*self.salto())
	}
	
	/*
	 * establece la dirección  y la cantidad de celdas a la que debe moverse
	 * en el eje y
	 */
	method deltaY(y){
		return (y - self.coordenadaActualY()).min(1*self.salto()).max(-1*self.salto())		
	}
	method coordenadaActualX(){
		return self.position().x()
	}
	method coordenadaActualY(){
		return self.position().y()
	}
	
	method detenerMovimiento() {
		if(enMovimiento) {
			enMovimiento = false
			game.removeTickEvent(nombreEventoMovimiento)			
		}
	}
}

// representa un objeto transladable sin animación
class Inanimado inherits Movil{
	var property image
	
}

class Animado inherits Movil {
	var animacion = nullAnimacion
	
	override method image() = animacion.image()
	
	// inicia la animación actual
	method animar() {
		animacion.iniciar()
	}

	//inicia una nueva animación	
	method animar(nuevaAnimacion) {
		if(nuevaAnimacion != animacion) {
			self.detenerAnimacion()		
			animacion = nuevaAnimacion
		}
		self.animar()
	}
	
	// detiene animación actual
	method detenerAnimacion() {
		animacion.detener()		
	}
	
	method resetearAnimacion() {
		animacion.detener()		
		animacion.resetear()
	}	
	method siguienteFotograma(){
		animacion.siguiente()
	}
	
	// indica si actualmente hay una animación en curso
	method animando() = animacion.animando()
	
}

